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
    @IBOutlet private weak var amountOfBitcoinLabel: MorphingLabel!
    @IBOutlet private weak var bitcoinImageView: UIImageView!
    @IBOutlet private weak var sendBitcoinButton: BouncyButton!
    @IBOutlet private weak var cryptoDexButton: BouncyButton!
    
    
    // MARK: - Private Instance Variables Maps
    private let zoomLevel: Float = 18.0
    private var mapMarkers: [GMSMarker] = []
    private var userLocationMarker = UserLocationMarker()
    
    
    // MARK: - Private Instance Variables Location Tracking
    private var locationTracker = LocationTracker()
    
    
    // MARK: - Private Instance Variables UITiming
    private var timeInterval = 0.5
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mapView.alpha == 0 {
            showActivityIndicator()
        }
        requestLocationPermission()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "goToAR":
            guard let arController = segue.destination as? ViewController,
                  let spawn = sender as? Spawn else {
                break
            }
            arController.spawn = spawn
        default:
            break
        }
    }
}


// MARK: - IBActions
private extension MapViewController {
    @IBAction func cryptoDexButtonTapped(sender: BouncyButton) {
        _ = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            self?.goToCryptoDexView()
        }
    }
}


// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let creatureMarker = marker as? CryptoCreatureMarker,
              let spawn = SpawnManager.shared.spawn(with: creatureMarker.spawnId) else { return true }
        print("Crypto creature tapped")
        performSegue(withIdentifier: "goToAR", sender: spawn)
        return true
    }
}


// MARK: - Private Instance Methods
private extension MapViewController {
    func setup() {
        mapView.alpha = 0
        amountOfBitcoinLabel.alpha = 0
        bitcoinImageView.alpha = 0
        sendBitcoinButton.alpha = 0
        cryptoDexButton.alpha = 0
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
        locationTracker.currentLocation.bind({ [weak self] (location) in
            guard let location = location else {
                print("Location received not available")
                return
            }
            let coordinate = location.coordinate
            let cameraPosition = GMSCameraPosition.camera(withTarget: coordinate, zoom: self?.zoomLevel ?? 0)
            if self?.mapView.alpha == 0 {
                self?.mapView.camera = cameraPosition
                self?.dismissActivityIndicator()
                self?.mapView.animateShow()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self?.bitcoinImageView.animateShow()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self?.amountOfBitcoinLabel.animateShow()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self?.sendBitcoinButton.animateShow()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self?.cryptoDexButton.animateShow()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    self?.amountOfBitcoinLabel.text = "0.0"
                                }
                            }
                        }
                    }
                }
            } else {
                self?.mapView.animate(to: cameraPosition)
            }
            self?.mapView.animate(toViewingAngle: 65)
            self?.mapView.animate(toBearing: -18)
            self?.userLocationMarker.position = coordinate
        }, for: self)
        locationTracker.locationError.bind({ _ in
            print("Error occured with location tracking")
        }, for: self)
        locationTracker.permissionStatus.bind({ [weak self] (status) in
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
        }, for: self)
    }
    
    func setupSpawnManagerBindings() {
        SpawnManager.shared.newSpawnsAvailable.bind({ [weak self] (spawns) in
            guard let newSpawns = spawns else { return }
            let markers = newSpawns.flatMap { (spawn) -> CryptoCreatureMarker? in
                return spawn.cryptoCreatureMarker
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                markers.forEach {
                    $0.map = self?.mapView
                }
            }
        }, for: self)
        SpawnManager.shared.newSpawnReceived.bind({ [weak self] (spawn) in
            guard let receivedSpawn = spawn,
                  let marker = receivedSpawn.cryptoCreatureMarker else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                marker.map = self?.mapView
            }
        }, for: self)
        SpawnManager.shared.spawnCaptured.bind({ (spawn) in
            guard let capturedSpawn = spawn,
                  let marker = capturedSpawn.cryptoCreatureMarker else { return }
            DispatchQueue.main.async {
                marker.map = nil
            }
        }, for: self)
    }
    
    func requestLocationPermission() {
        locationTracker.requestPermission()
    }
    
    func goToCryptoDexView() {
        performSegue(withIdentifier: "goToCryptoDex", sender: nil)
    }
}
