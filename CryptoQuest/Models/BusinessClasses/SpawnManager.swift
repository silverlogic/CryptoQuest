//
//  SpawnManager.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

final class SpawnManager {
    
    // MARK: - Shared Instance
    static let shared = SpawnManager()
    
    
    // MARK: - Private Instance Attributes
    private var spawns: [Spawn] = []
    
    
    // MARK: - Public Instance Attributes
    var newSpawnsAvailable: DynamicBinder<[Spawn]?>
    
    
    // MARK: - Initializers
    private init() {
        newSpawnsAvailable = DynamicBinder(nil)
        setupSocketBindings()
    }
}


// MARK: - Public Instance Methods For Retrieval
extension SpawnManager {
    func spawn(with index: Int) -> Spawn? {
        return spawns[safe: index]
    }
}


// MARK: - Private Instance Methods For Socket Bindings
private extension SpawnManager {
    func setupSocketBindings() {
        Socket.shared.didReceiveSpawnList.bind { [weak self] (data) in
            guard let spawnData = data else {
                print("Spawn data was not received")
                return
            }
            let decoder = JSONDecoder()
            do {
                let newSpawns = try decoder.decode([Spawn].self, from: spawnData)
                self?.spawns.append(contentsOf: newSpawns)
                print("New spawns received")
                self?.newSpawnsAvailable.value = newSpawns
            } catch {
                print("Error parsing spawn list data: \(error)")
            }
        }
    }
}
