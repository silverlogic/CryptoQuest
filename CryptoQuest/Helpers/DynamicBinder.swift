//
//  DynamicBinder.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

// MARK: - Listener Typealias
typealias Listener<T> = (T) -> Void


// MARK: - Observer
struct Observer<T> {
    
    // MARK: - Public Instance Attributes
    weak var observer: AnyObject?
    var listener: Listener<T>?
    
    
    // MARK: - Initializers
    init(observer: AnyObject, listener: Listener<T>?) {
        self.observer = observer
        self.listener = listener
    }
}


// MARK: - DynamicBinder
final class DynamicBinder<T> {
    private var observers: [Observer<T>]
    var value: T {
        didSet {
            observers.forEach { $0.listener?(value) }
        }
    }
    
    func bind(_ listener: Listener<T>?, for observer: AnyObject) {
        let observe = Observer(observer: observer, listener: listener)
        observers.append(observe)
    }
    
    func bindAndFire(_ listener: Listener<T>?, for observer: AnyObject) {
        let observe = Observer(observer: observer, listener: listener)
        observers.append(observe)
        listener?(value)
    }
    
    init(_ v: T) {
        value = v
        observers = []
    }
}
