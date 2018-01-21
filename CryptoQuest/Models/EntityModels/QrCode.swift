//
//  QrCode.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

struct QrCode {
    
    // MARK: - Public Instance Attribues
    
    // Shouldn't hardcode this.
    var address: String = "1NAWrPAa5QaCpdVm43o7Rdt9wrJ6Jzkg6i"
}


// MARK: - Public Instance Methods
extension QrCode {
    func qrCodeImage(width: CGFloat, height: CGFloat) -> UIImage? {
        let data = address.data(using: .isoLatin1)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        guard let qrCodeImage = filter.outputImage else { return nil }
        let scaleX = width / qrCodeImage.extent.size.width
        let scaleY = height / qrCodeImage.extent.size.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
        return UIImage(ciImage: output)
    }
}
