//
//  QrCodeViewController.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

final class QrCodeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var qrCodeImageView: UIImageView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let qrCode = QrCode()
        let width = qrCodeImageView.frame.size.width
        let height = qrCodeImageView.frame.size.height
        guard let image = qrCode.qrCodeImage(width: width, height: height) else { return }
        qrCodeImageView.image = image
    }
}


// MARK: - IBActions
extension QrCodeViewController {
    @IBAction func dismissButtonTapped(sender: UIButton) {
        UserManager.shared.updateBalance()
        navigationController?.popViewController(animated: true)
    }
}
