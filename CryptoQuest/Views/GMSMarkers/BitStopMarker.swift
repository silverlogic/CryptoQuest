//
//  BitStopMarker.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import CoreLocation
import Foundation
import GoogleMaps

final class BitStopMarker: GMSMarker {
    
    // MARK: - Initializers
    override init() {
        super.init()
        self.icon = #imageLiteral(resourceName: "icon-bitstop")
        self.appearAnimation = .pop
    }
}


// MARK: - Public Class Methods
extension BitStopMarker {
    static func defaultLocations() -> [BitStopMarker] {
        var markers: [BitStopMarker] = []
        let streetLocation = CLLocationCoordinate2D(latitude: 25.817863, longitude: -80.207772)
        let labLocation = CLLocationCoordinate2D(latitude: 25.800591, longitude: -80.202153)
        let streetMarker = BitStopMarker()
        streetMarker.position = streetLocation
        markers.append(streetMarker)
        let labMarker = BitStopMarker()
        labMarker.position = labLocation
        markers.append(labMarker)
        return markers
    }
}
