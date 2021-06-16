//
//  UIViewController+Ext.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/17.
//

import UIKit
import SafariServices

extension UIViewController {

    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemOrange
        present(safariVC, animated: true)
    }
}
