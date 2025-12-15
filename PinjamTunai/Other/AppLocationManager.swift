//
//  AppLocationManager.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/10.
//

import Foundation
import CoreLocation
import UIKit

struct LocationModel {
    var story: String?
    var jest: String?
    var meal: String?
    var followed: String?
    var leading: String?
    var thereafter: String?
    var afoot: String?
    var drinking: String?
}

class AppLocationManager: NSObject {

    static let shared = AppLocationManager()

    private let locationManager = CLLocationManager()
    
    private var completion: ((LocationModel?) -> Void)?

    private var debounceWorkItem: DispatchWorkItem?
    
    private let debounceInterval: TimeInterval = 2.0

    override init() {
        super.init()
        locationManager.delegate = self
    }

    /// ⭐
    func getCurrentLocation(completion: @escaping (LocationModel?) -> Void) {
        self.completion = completion

        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()

        case .denied, .restricted:
            completion(nil)

        @unknown default:
            completion(nil)
        }
    }

    private func startLocationUpdate() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}

extension AppLocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        let status = manager.authorizationStatus

        switch status {

        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()

        case .denied, .restricted:
            completion?(nil)

        case .notDetermined:
            break

        @unknown default:
            completion?(nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        locationManager.stopUpdatingLocation()
        debounceWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
                guard let self = self else { return }

                let placemark = placemarks?.first

                let model = LocationModel(
                    story: placemark?.administrativeArea,
                    jest: placemark?.isoCountryCode,
                    meal: placemark?.country,
                    followed: placemark?.thoroughfare,
                    leading: String(format: "%.6f", location.coordinate.latitude),
                    thereafter: String(format: "%.6f", location.coordinate.longitude),
                    afoot: placemark?.locality,
                    drinking: placemark?.subLocality
                )
                self.completion?(model)
            }
        }

        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        completion?(nil)
    }
}


class LocationManagerModel {
    static let shared = LocationManagerModel()
    private init() {}
    var model: LocationModel?
}

class LocationPermissionAlert {
    private static let lastAlertDateKey = "LocationPermissionAlert.lastAlertDate"
    static func show(on viewController: UIViewController) {
        guard shouldShowAlert() else { return }
        
        let alert = UIAlertController(
            title: LanguageManager.localizedString(for: "Location Services Disabled"),
            message: LanguageManager.localizedString(for: "Location access is required to process your loan application. Please enable it in Settings to continue."),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: LanguageManager.localizedString(for: "Cancel"),
            style: .default
        )
        
        let settingsAction = UIAlertAction(
            title: LanguageManager.localizedString(for: "Settings"),
            style: .cancel
        ) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        recordAlertShown()
        
        viewController.present(alert, animated: true)
    }
    
    private static func shouldShowAlert() -> Bool {
        guard let lastDate = UserDefaults.standard.object(forKey: lastAlertDateKey) as? Date else {
            return true
        }
        
        guard let nextAvailableDate = Calendar.current.date(
            byAdding: .hour,
            value: 24,
            to: lastDate
        ) else {
            return true
        }
        
        return Date() >= nextAvailableDate
    }
    
    private static func recordAlertShown() {
        UserDefaults.standard.set(Date(), forKey: lastAlertDateKey)
    }
    
    static func resetAlertRecord() {
        UserDefaults.standard.removeObject(forKey: lastAlertDateKey)
    }
    
    static func nextAvailableTime() -> Date? {
        guard let lastDate = UserDefaults.standard.object(forKey: lastAlertDateKey) as? Date else {
            return nil
        }
        
        return Calendar.current.date(byAdding: .hour, value: 24, to: lastDate)
    }
}
