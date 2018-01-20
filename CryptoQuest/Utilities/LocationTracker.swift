//
//  LocationTracker.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import CoreLocation
import Foundation

// MARK: - Location Error Enum
enum LocationError: Error {
    case notAvailable
    case locationNotFound
}


// MARK: - Location Tracker
final class LocationTracker: NSObject {
    
    // MARK: - Private Instance Attributes
    private var locationManager: CLLocationManager
    
    
    // MARK: - Public Instance Attributes
    var currentLocation: DynamicBinder<CLLocation?>
    var permissionStatus: DynamicBinder<CLAuthorizationStatus?>
    var locationError: DynamicBinder<Error?>
    
    
    // MARK: - Initializers
    override init() {
        locationManager = CLLocationManager()
        currentLocation = DynamicBinder(nil)
        permissionStatus = DynamicBinder(nil)
        locationError = DynamicBinder(nil)
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}


// MARK: - CLLocationManagerDelegate
extension LocationTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {
            locationError.value = LocationError.locationNotFound
            return
        }
        currentLocation.value = latestLocation
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopTracking()
        print("Location error: \(error)")
        locationError.value = error
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        permissionStatus.value = status
    }
}


// MARK: - Public Instance Methods
extension LocationTracker {
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startTracking() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            locationError.value = LocationError.notAvailable
        }
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
}
