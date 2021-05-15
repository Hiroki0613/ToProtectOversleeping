//
//  QRCodeVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit

class QRCodeVC: UIViewController {
    
    var qrCodeImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray

//        guard let qrImage = UIImage.makeQRCode(text: urlText) else { return }
//        qrCodeImageView.backgroundColor = .red
//        self.qrCodeImageView.image = qrImage
        
        let qrCiImage = makeQRCode(str: "sample")
        
        guard let qr = qrCiImage else{
                return
            }
            let imageView = UIImageView(image: UIImage(ciImage: qr))
            imageView.frame.size.width = 200
            imageView.frame.size.height = 200

            imageView.center.x = self.view.frame.width / 2
            imageView.center.y = self.view.frame.height / 2

            self.view.addSubview(imageView)
    }
   
    private func makeQRCode( str:String )->CIImage?{
        guard let data = str.data(using: .utf8) else { return nil }
        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "M"])
        if let qr = qr {
            let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
            return qr.outputImage!.transformed(by: sizeTransform)
        }
        return nil
    }


}
