////
////  UIImage+Ext.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/05/08.
////
//
//import UIKit
//
//// 参考URL
//// https://kikuragechan.com/swift/make-qr-code
//
//extension iimage {
//    
//    /// 文字列からQRコードを作成します
//    /// - Parameter text: 読み込んだ時のデータ文字列
//    /// - Returns:
//    static func makeQRCode(text: String) -> CIImage? {
//        let data = text.data(using: .utf8)
//        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "M"])
//        if let qr = qr {
//            let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
//            return qr.outputImage!.transformed(by: sizeTransform)
//        }
//        return nil
//    }
//}
