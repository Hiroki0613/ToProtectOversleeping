//
//  Alert.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2022/01/22.
//

import UIKit

final class Alert {

    // OK&キャンセルアラート
    static func okAndCancelAlert(vc: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let cancelAlertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        cancelAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        cancelAlertVC.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        vc.present(cancelAlertVC, animated: true, completion: nil)
    }
}
