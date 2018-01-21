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
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateVeztAmountLabel()
    }
}


// MARK: - IBActions
private extension CryptoDexDetailsViewController {
    @IBAction func backToCryptoDetailsTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buyMoreButtonTapped(_ sender: BouncyButton) {
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.performSegue(withIdentifier: "goToQrCode", sender: nil)
        }
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
            self?.veztAmountLabel.text = "\(UserManager.shared.veztAmount)"
        }
    }
}
