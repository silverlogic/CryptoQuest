//
//  WarningView.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import UIKit

class WarningView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.red.withAlphaComponent(0.0)
    }
    
    func startAlarming() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: { [weak self] in
            self?.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }, completion: nil)
    }
}
