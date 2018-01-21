//
//  AppDelegate.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import GoogleMaps
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = SpawnManager.shared
        _ = UserManager.shared
        GMSServices.provideAPIKey(GOOGLE_MAPS_API_KEY)
        Socket.shared.connect()
        return true
    }
}
