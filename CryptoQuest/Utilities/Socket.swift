//
//  Socket.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation
import Starscream

// MARK: - Socket Error Enum
enum SocketError: Error {
    case byteStream
    case eventTypeNotDetermined
    case eventDataNotPresent
    case spawnEventDataNotPresent
    case capturedSpawnEventDataNotPresent
    case newSpawnEventDataNotPresent
}


// MARK: - Socket Event Enum
enum SocketEvent: String {
    case spawnList = "spawn_list"
    case shoot = "shoot"
    case spawnCaptured = "spawn_captured"
    case newSpawn = "spawn_new"
    case sessionStart = "session_start"
    case shitCoin = "shitcoin"
    case balanceUpdate = "balance_update"
    case balanceUpdated = "balance_updated"
}


// MARK: - Socket
final class Socket {
    
    // MARK: - Shared Instance
    static let shared = Socket()
    
    
    // MARK: - Private Instance Attributes
    private var webSocket: WebSocket
    
    
    // MARK: - Public Instance Attributes
    var didReceiveSpawnList: DynamicBinder<Data?>
    var didCaptureSpawn: DynamicBinder<Data?>
    var newSpawnReceived: DynamicBinder<Data?>
    var shitCoinAppeared: DynamicBinder<Void>
    var balanceUpdated: DynamicBinder<Void>
    var socketError: DynamicBinder<Error?>
    
    
    // MARK: - Initializers
    private init() {
        let url = URL(string: BASE_SOCKET)!
        let urlRequest = URLRequest(url: url)
        webSocket = WebSocket(request: urlRequest)
        didReceiveSpawnList = DynamicBinder(nil)
        didCaptureSpawn = DynamicBinder(nil)
        socketError = DynamicBinder(nil)
        newSpawnReceived = DynamicBinder(nil)
        shitCoinAppeared = DynamicBinder(())
        balanceUpdated = DynamicBinder(())
        setupBindings()
    }
}


// MARK: - Public Instance Methods For Connecting/Disconnecting
extension Socket {
    func connect() {
        webSocket.connect()
    }
    
    func disconnect() {
        webSocket.disconnect()
    }
}


// MARK: - Public Instance Methods For Sending Data
extension Socket {
    func write(with string: String) {
        webSocket.write(string: string)
    }
}


// MARK: - Private Instance Methods For Socket Bindings
private extension Socket {
    func setupBindings() {
        webSocket.onConnect = {
            print("Client is connected")
        }
        webSocket.onDisconnect = { [weak self] (error) in
            guard error != nil else {
                print("Error with socket: \(error?.localizedDescription ?? "unknown")")
                self?.connect()
                return
            }
            print("Client is disconnected")
        }
        webSocket.onText = { [weak self] in
            print("Text received: \($0)")
            self?.processEvent(from: $0)
        }
    }
}


// MARK: - Private Instance Methods For Socket Event Processing
private extension Socket {
    func processEvent(from text: String) {
        guard let textData = text.data(using: .utf8) else {
            print("Error converting text to byte stream")
            socketError.value = SocketError.byteStream
            return
        }
        do {
            guard let dataDic = try JSONSerialization.jsonObject(with: textData, options: []) as? [String: Any] else {
                print("Error converting byte stream to JSON")
                socketError.value = SocketError.byteStream
                return
            }
            guard let type = dataDic["type"] as? String,
                  let socketEvent = SocketEvent(rawValue: type) else {
                    print("Error figuring out socket event")
                    socketError.value = SocketError.eventTypeNotDetermined
                    return
            }
            switch socketEvent {
            case .spawnList:
                guard let socketData = dataDic["data"] as? [String: Any] else {
                    print("Error retrieving socket data")
                    socketError.value = SocketError.eventDataNotPresent
                    return
                }
                guard let spawnList = socketData["spawns"] as? [AnyObject] else {
                    print("Spawn event data not present")
                    socketError.value = SocketError.spawnEventDataNotPresent
                    return
                }
                let spawnData = try JSONSerialization.data(withJSONObject: spawnList, options: [])
                didReceiveSpawnList.value = spawnData
            case .spawnCaptured:
                guard let socketData = dataDic["data"] as? [String: Any] else {
                    print("Error retrieving socket data")
                    socketError.value = SocketError.eventDataNotPresent
                    return
                }
                let capturedSpawn = socketData["spawn"] as AnyObject
                let capturedSpawnData = try JSONSerialization.data(withJSONObject: capturedSpawn, options: [])
                didCaptureSpawn.value = capturedSpawnData
            case .newSpawn:
                guard let socketData = dataDic["data"] as? [String: Any] else {
                    print("Error retrieving socket data")
                    socketError.value = SocketError.eventDataNotPresent
                    return
                }
                let newSpawn = socketData["spawn"] as AnyObject
                let newSpawnData = try JSONSerialization.data(withJSONObject: newSpawn, options: [])
                newSpawnReceived.value = newSpawnData
            case .shitCoin:
                shitCoinAppeared.value = ()
            case .balanceUpdated:
                balanceUpdated.value = ()
            default:
                print("Event not being handled!")
            }
        } catch {
            print("Error occured with serialization: \(error)")
            socketError.value = error
        }
    }
}
