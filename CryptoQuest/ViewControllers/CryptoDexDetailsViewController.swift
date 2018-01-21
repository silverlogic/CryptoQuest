//
//  CryptoDexDetailsViewController.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import UIKit

final class CryptoDexDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var comingSoonButton: BouncyButton!
    @IBOutlet private weak var buyMoreButton: BouncyButton!
    @IBOutlet private weak var cryptoCreatureImageView: UIImageView!
    @IBOutlet private weak var veztAmountLabel: MorphingLabel!
    
    
    // MARK: - Public Instance Attributes
    var shouldShowCongrats = false
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: - IBActions
private extension CryptoDexDetailsViewController {
    @IBAction func backToCryptoDetailsTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - Private Instance Methods
private extension CryptoDexDetailsViewController {
    func setup() {
        if shouldShowCongrats {
            cryptoCreatureImageView.image = #imageLiteral(resourceName: "icon-vezt-cryptodex-details-confetti_dex")
        } else {
            cryptoCreatureImageView.image = #imageLiteral(resourceName: "icon-vezt-cryptodex-details")
        }
    }
    
    func updateVeztAmountLabel() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.veztAmountLabel.text = "2.98913450"
        }
    }
}
