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
    var spawnCaptured: DynamicBinder<Spawn?>
    var newSpawnReceived: DynamicBinder<Spawn?>
    
    
    // MARK: - Initializers
    private init() {
        newSpawnsAvailable = DynamicBinder(nil)
        spawnCaptured = DynamicBinder(nil)
        newSpawnReceived = DynamicBinder(nil)
        setupSocketBindings()
    }
}


// MARK: - Public Instance Methods For Retrieval
extension SpawnManager {
    func spawn(with index: Int) -> Spawn? {
        return spawns[safe: index]
    }
}


// MARK: - Public Instance Methods For Attacking
extension SpawnManager {
    
    /// Attacks a crypto.
    ///
    /// - Note: For EG, the id should be 1. For VM, the id should be 2.
    ///
    /// - Parameters:
    ///   - spawn: A `Spawn` containing the crypto creature to attack.
    ///   - userId: A `Int` representing the id of the user that performed the attack.
    func attackCryptoCreature(spawn: Spawn, userId: Int) {
        let socketEventData: [String: Any] = [
            "spawn_id": spawn.spawnId,
            "user_id": userId
        ]
        let socketEventInfo: [String: Any] = [
            "type": SocketEvent.shoot.rawValue,
            "data": socketEventData
        ]
        do {
            let socketData = try JSONEncoder().encode(socketEventInfo)
            Socket.shared.write(with: socketData)
        } catch {
            print("Error serialization spawn attack socket data")
        }
    }
}


// MARK: - Public Instance Methods For Starting Session
extension SpawnManager {
    
    /// Starts a session for the user.
    ///
    /// - Note: For EG, the id should be 1. For VM, the id should be 2.
    ///
    /// - Parameter userId: A `Int` representing the id of the user.
    func startSession(for userId: Int) {
        let socketEventData: [String: Any] = [
            "user_id": userId
        ]
        let socketEventInfo: [String: Any] = [
            "type": SocketEvent.sessionStart.rawValue,
            "data": socketEventData
        ]
        do {
            let socketData = try JSONEncoder().encode(socketEventInfo)
            Socket.shared.write(with: socketData)
        } catch {
            print("Error serialization start session socket data")
        }
    }
}


// MARK: - Private Instance Methods For Socket Bindings
private extension SpawnManager {
    func setupSocketBindings() {
        Socket.shared.didReceiveSpawnList.bind({ [weak self] (data) in
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
        }, for: self)
        Socket.shared.didCaptureSpawn.bind({ [weak self] (data) in
            guard let capturedSpawnData = data else {
                print("Captured spawn data was not received")
                return
            }
            let decoder = JSONDecoder()
            do {
                let capturedSpawn = try decoder.decode(Spawn.self, from: capturedSpawnData)
                guard let index = self?.spawns.index(where: { $0.spawnId == capturedSpawn.spawnId }) else {
                    print("Could not located captured spawn in datasource")
                    return
                }
                self?.spawns[index] = capturedSpawn
                self?.spawnCaptured.value = capturedSpawn
            } catch {
                print("Error parsing captured spawn data: \(error)")
            }
        }, for: self)
        Socket.shared.newSpawnReceived.bind({ [weak self] (data) in
            guard let newSpawnReceivedData = data else {
                print("New spawn data was not received")
                return
            }
            let decoder = JSONDecoder()
            do {
                let newSpawn = try decoder.decode(Spawn.self, from: newSpawnReceivedData)
                self?.spawns.append(newSpawn)
                self?.newSpawnReceived.value = newSpawn
            } catch {
                print("Error parsing new spawn data: \(error)")
            }
        }, for: self)
    }
}
