//
//  Untitled.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/9.
//

import UIKit
import AVFoundation

class SystemCameraManager: NSObject {
    
    static let shared = SystemCameraManager()
    
    var onPhotoCaptured: ((UIImage?) -> Void)?
    
    private override init() {}
    
    // MARK: - Public
    
    func takePhoto(from viewController: UIViewController, type: String) {
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                self.showCamera(from: viewController, type: type)
            } else {
                self.showPermissionAlert(from: viewController)
            }
        }
    }
    
    // MARK: - Permission
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func showPermissionAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "相机权限被拒绝",
            message: "请在设置中开启相机权限以使用拍照功能",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        viewController.present(alert, animated: true)
    }
    
    // MARK: - Show Camera
    
    private func showCamera(from viewController: UIViewController, type: String) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = false
        
        if type == "2" {
            picker.cameraDevice = .front
        }else {
            picker.cameraDevice = .rear
        }
        
        viewController.present(picker, animated: true)
    }
    
    private func fixOrientation(_ image: UIImage) -> UIImage {
        if image.imageOrientation == .up { return image }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return normalized
    }
    
    func compressImage(_ image: UIImage, toMaxKB maxKB: Int) -> UIImage? {
        let maxBytes = maxKB * 1024
        let fixedImage = fixOrientation(image)
        
        var compression: CGFloat = 1.0
        guard var data = fixedImage.jpegData(compressionQuality: compression) else { return nil }
        
        if data.count > maxBytes {
            while data.count > maxBytes && compression > 0.05 {
                compression -= 0.05
                if let newData = fixedImage.jpegData(compressionQuality: compression) {
                    data = newData
                }
            }
        }
        
        if data.count > maxBytes {
            var currentImage = fixedImage
            var ratio: CGFloat = 0.9
            
            while data.count > maxBytes {
                let newSize = CGSize(width: currentImage.size.width * ratio,
                                     height: currentImage.size.height * ratio)
                
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
                currentImage.draw(in: CGRect(origin: .zero, size: newSize))
                currentImage = UIGraphicsGetImageFromCurrentImageContext() ?? currentImage
                UIGraphicsEndImageContext()
                
                if let newData = currentImage.jpegData(compressionQuality: compression) {
                    data = newData
                }
                
                ratio *= 0.9
            }
            
            return UIImage(data: data)
        }
        
        return UIImage(data: data)
    }
}


// MARK: - UIImagePickerControllerDelegate

extension SystemCameraManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let original = info[.originalImage] as? UIImage else {
            onPhotoCaptured?(nil)
            return
        }
        
        let compressed = compressImage(original, toMaxKB: 700)
        
        DispatchQueue.main.async {
            self.onPhotoCaptured?(compressed)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        onPhotoCaptured?(nil)
    }
}
