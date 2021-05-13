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
        configureQRCodeView()
        let urlText = "https://kikuragechan.com"

        guard let qrImage = UIImage.makeQRCode(text: urlText) else { return }
        qrCodeImageView.backgroundColor = .red
        self.qrCodeImageView.image = qrImage
    }
    
    func configureQRCodeView() {
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qrCodeImageView)
        
        NSLayoutConstraint.activate([
            qrCodeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50),
            qrCodeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            qrCodeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -50),
            qrCodeImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width - 100)
        ])
        
    }


}
