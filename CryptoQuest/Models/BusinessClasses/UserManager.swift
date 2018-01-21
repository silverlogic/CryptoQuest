//
//  UserManager.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

// MARK: - Available Users Enum
enum AvailableUsers {
    case user1
    case user2
}

final class UserManager {
    
    // MARK: - Shared Instance
    static let shared = UserManager()
    
    
    // MARK: - Private Instance Attributes
    private var currentUser = User.mockUser1()
    
    
    // MARK: - Public Instance Attributes
    var bitcoinAmount: Float {
        return currentUser.bitcoinAmount
    }
    var bitcoinCashAmount: Float {
        return currentUser.bitcoinCashAmount
    }
    var veztAmount: Float {
        return currentUser.veztAmount
    }
    var ethereumAmount: Float {
        return currentUser.ethereumAmount
    }
    var litecoinAmount: Float {
        return currentUser.litecoinAmount
    }
    var neoAmount: Float {
        return currentUser.neoAmount
    }
    var userId: Int {
        return currentUser.userId
    }
    
    
    // MARK: - Initializers
    private init() {}
}


// MARK: - Public Instance Methods For Setting User In Use
extension UserManager {
    func activateUser(_ user: AvailableUsers) {
        switch user {
        case .user1:
            currentUser = User.mockUser1()
        case .user2:
            currentUser = User.mockUser2()
        }
    }
}


// MARK: - Public Instance Methods For Updating Balance
extension UserManager {
    func updateBalance() {
        let socketEventInfo: [String: Any] = [
            "type": SocketEvent.balanceUpdate.rawValue,
            "data": [:]
        ]
        do {
            let socketData = try JSONSerialization.data(withJSONObject: socketEventInfo,
                                                        options: .prettyPrinted)
            guard let socketDataString = String(data: socketData, encoding: .utf8) else {
                return
            }
            Socket.shared.write(with: socketDataString)
        } catch {
            print("Error serialization balance update socket data")
        }
    }
}


// MARK: - Private Instance Methods
private extension UserManager {
    func setupSocketBindings() {
        Socket.shared.balanceUpdated.bind({ [weak self] in
            self?.currentUser.bitcoinAmount = 0.00262964
        }, for: self)
    }
    
    func setupSpawnManagerBindings() {
        SpawnManager.shared.spawnCaptured.bind({ [weak self] _ in
            self?.currentUser.bitcoinAmount = 0.00141812
        }, for: self)
    }
}
