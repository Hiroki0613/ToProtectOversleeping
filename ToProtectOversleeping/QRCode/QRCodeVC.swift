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
        configureQRCodeView()
        let urlText = "https://kikuragechan.com"

        let image = UIImage.makeQRCode(text: urlText)
        
        self.qrCodeImageView.image = image
    }
    
    func configureQRCodeView() {
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qrCodeImageView)
        
        NSLayoutConstraint.activate([
            qrCodeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            qrCodeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            qrCodeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            qrCodeImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width)
        ])
        
    }


}
