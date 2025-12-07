//
//  LaunchViewModel.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/7.
//

import Foundation

class LaunchViewModel {

    var onError: ((String) -> Void)?
    var onSuccess: ((BaseModel?) -> Void)?
    
    func initLaunchInfo(with json: [String: Any]) async {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/ecutiveof/became", parameters: json)
            self.onSuccess?(model)
        } catch {
            print("error===: \(error)")
            self.onError?(error.localizedDescription)
        }
        
    }
    
}

class UpLoadIDFAViewModel {

    var onError: ((String) -> Void)?
    var onSuccess: ((BaseModel?) -> Void)?
    
    func uploadIDFAInfo(with json: [String: Any]) async {
//        LoadingView.show()
//        
//        defer {
//            LoadingView.hide()
//        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/prayer", parameters: json)
            self.onSuccess?(model)
        } catch {
            print("error===: \(error)")
            self.onError?(error.localizedDescription)
        }
        
    }
    
}
