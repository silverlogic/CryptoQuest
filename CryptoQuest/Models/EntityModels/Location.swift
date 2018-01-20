//
//  Location.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import CoreLocation
import Foundation

struct Location: Codable {
    
    // MARK: - Public Instance Attributes
    let locationId: Int
    let name: String
    let latitude: String
    let longitude: String
    
    
    // MARK: - Getters & Setters
    var coordinate: CLLocationCoordinate2D {
        let latitude: Double = Double(self.latitude) ?? 0
        let longitude: Double = Double(self.longitude) ?? 0
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case locationId = "id"
        case name = "name"
        case latitude = "lat"
        case longitude = "lng"
    }
}
