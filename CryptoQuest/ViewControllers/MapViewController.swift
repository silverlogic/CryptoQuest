//
//  MapViewController.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import GoogleMaps
import UIKit

final class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: GMSMapView!
    
    
    // MARK: - Private Instance Variables Maps
    private let zoomLevel: Float = 18.0
    private var mapMarkers: [GMSMarker] = []
    private var userLocationMarker = UserLocationMarker()
    
    
    
    // MARK: - Private Instance Variables Location Tracking
    private var locationTracker = LocationTracker()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestLocationPermission()
    }
}


// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let creatureMarker = marker as? CryptoCreatureMarker else { return true }
        print("Crypto creature tapped")
        return true
    }
}


// MARK: - Private Instance Methods
private extension MapViewController {
    func setup() {
        mapView.alpha = 0
        mapView.delegate = self
        userLocationMarker.map = mapView
        do {
            if let styleUrl = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleUrl)
            } else {
                print("Style file not available")
            }
        } catch {
            print("Loading style error: \(error)")
        }
        setupLocationTrackerBindings()
        setupSpawnManagerBindings()
    }
    
    func setupLocationTrackerBindings() {
        locationTracker.currentLocation.bind { [weak self] (location) in
            guard let location = location else {
                print("Location received not available")
                return
            }
            let coordinate = location.coordinate
            let cameraPosition = GMSCameraPosition.camera(withTarget: coordinate, zoom: self?.zoomLevel ?? 0)
            if self?.mapView.alpha == 0 {
                self?.mapView.camera = cameraPosition
                self?.mapView.animateShow()
            } else {
                self?.mapView.animate(to: cameraPosition)
            }
            self?.mapView.animate(toViewingAngle: 65)
            self?.mapView.animate(toBearing: -18)
            self?.userLocationMarker.position = coordinate
        }
        locationTracker.locationError.bind { _ in
            print("Error occured with location tracking")
        }
        locationTracker.permissionStatus.bind { [weak self] (status) in
            guard let status = status else {
                print("Status not available")
                return
            }
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self?.locationTracker.startTracking()
            default:
                print("Location tracking not available")
            }
        }
    }
    
    func setupSpawnManagerBindings() {
        SpawnManager.shared.newSpawnsAvailable.bind { [weak self] (spawns) in
            guard let newSpawns = spawns else { return }
            let markers = newSpawns.flatMap { (spawn) -> CryptoCreatureMarker? in
                return spawn.cryptoCreatureMarker
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                markers.forEach {
                    $0.map = self?.mapView
                }
            }
        }
        SpawnManager.shared.newSpawnReceived.bind { [weak self] (spawn) in
            guard let receivedSpawn = spawn,
                  let marker = receivedSpawn.cryptoCreatureMarker else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                marker.map = self?.mapView
            }
        }
        SpawnManager.shared.spawnCaptured.bind { (spawn) in
            guard let capturedSpawn = spawn,
                  let marker = capturedSpawn.cryptoCreatureMarker else { return }
            DispatchQueue.main.async {
                marker.map = nil
            }
        }
    }
    
    func requestLocationPermission() {
        locationTracker.requestPermission()
    }
}
