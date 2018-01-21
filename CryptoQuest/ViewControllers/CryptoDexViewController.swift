//
//  CryptoDexViewController.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import UIKit

// MARK: - CryptoDex Section Enum
enum CryptoDexSection: Int {
    case goodCrypto
    case badCrypto
}


// MARK: - Supported Crypto Creatures Enum
enum SupportedCryptoCreatures: Int {
    case bitcoin
    case bitcoinCash
    case vezt
    case ethereum
    case litecoin
    case neo
}


// MARK: - CryptoDex View Controlelr
final class CryptoDexViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bitcoinAmountLabel: MorphingLabel!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBitcoinAmountLabel()
    }
}


// MARK: - IBActions
private extension CryptoDexViewController {
    @IBAction func dismissButtonTapped(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - UICollectionViewDataSource
extension CryptoDexViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cryptoSection = CryptoDexSection(rawValue: section) else { return 0 }
        switch cryptoSection {
        case .goodCrypto:
            return 6
        case .badCrypto:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cryptoCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CryptoDexCollectionViewCell",
            for: indexPath
        ) as? CryptoDexCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let cryptoDexSection = CryptoDexSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch cryptoDexSection {
        case .goodCrypto:
            guard let supportedCrypto = SupportedCryptoCreatures(rawValue: indexPath.item) else {
                return UICollectionViewCell()
            }
            let cryptoImage: UIImage
            let cryptoName: String
            let cryptoAmount: Float
            switch supportedCrypto {
            case .bitcoin:
                cryptoImage = #imageLiteral(resourceName: "icon-bitcoin-cryptodex")
                cryptoName = CryptoCreatureName.bitcoin.rawValue
                cryptoAmount = UserManager.shared.bitcoinAmount
            case .bitcoinCash:
                cryptoImage = #imageLiteral(resourceName: "icon-bitcoincash-cryptodex")
                cryptoName = CryptoCreatureName.bitcoinCash.rawValue
                cryptoAmount = UserManager.shared.bitcoinCashAmount
            case .vezt:
                cryptoImage = #imageLiteral(resourceName: "icon-vezt-gray-cryptodex")
                cryptoName = CryptoCreatureName.vezt.rawValue
                cryptoAmount = UserManager.shared.veztAmount
            case .ethereum:
                cryptoImage = #imageLiteral(resourceName: "icon-erthereum-cryptodex")
                cryptoName = CryptoCreatureName.ethereum.rawValue
                cryptoAmount = UserManager.shared.ethereumAmount
            case .litecoin:
                cryptoImage = #imageLiteral(resourceName: "icon-litecoin-cryptodex")
                cryptoName = CryptoCreatureName.litecoin.rawValue
                cryptoAmount = UserManager.shared.litecoinAmount
            case .neo:
                cryptoImage = #imageLiteral(resourceName: "icon-neo-cryptodex")
                cryptoName = "Neo"
                cryptoAmount = UserManager.shared.neoAmount
            }
            cryptoCell.configure(cryptoImage: cryptoImage, cryptoName: cryptoName, cryptoAmount: cryptoAmount)
            return cryptoCell
        case .badCrypto:
            let cryptoImage = #imageLiteral(resourceName: "icon-shit-cryptodex")
            cryptoCell.configure(cryptoImage: cryptoImage, cryptoName: "Sh*tcoin", cryptoAmount: 0.0)
            return cryptoCell
        }
    }
}


// MARK: - UICollectionViewDelegate
extension CryptoDexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cryptoSection = CryptoDexSection(rawValue: indexPath.section),
              cryptoSection != .badCrypto,
              let cryptoCreatureSection = SupportedCryptoCreatures(rawValue: indexPath.item),
              cryptoCreatureSection == .vezt else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let cryptoDetailViewController = storyboard.instantiateViewController(withIdentifier: "CryptoDexDetailsViewController") as? CryptoDexDetailsViewController else {
            return
        }
        cryptoDetailViewController.shouldShowCongrats = true
        navigationController?.pushViewController(cryptoDetailViewController, animated: true)
    }
}


// MARK: - Private Instance Attributes
private extension CryptoDexViewController {
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = CryptoDexVerticalFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.numberOfItemsPerRow = 3
        collectionView.reloadData()
    }
    
    func updateBitcoinAmountLabel() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.bitcoinAmountLabel.text = "\(UserManager.shared.bitcoinAmount)"
        }
    }
}
