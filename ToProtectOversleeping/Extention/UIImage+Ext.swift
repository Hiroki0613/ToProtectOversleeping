//
//  UIImage+Ext.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit

// 参考URL
// https://kikuragechan.com/swift/make-qr-code

extension UIImage {
    
    /// 文字列からQRコードを作成します
    /// - Parameter text: 読み込んだ時のデータ文字列
    /// - Returns:
    static func makeQRCode(text: String) -> UIImage? {
        guard let data = text.data(using: .utf8) else { return nil }
        guard let QR = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputmessage": data]) else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        guard let ciImage = QR.outputImage?.transformed(by: transform) else { return nil }
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
