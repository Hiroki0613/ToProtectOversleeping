//
//  UIView+Ext.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/11.
//

import Foundation
import UIKit

extension UIView {
    
    func addBlurToView(alpha: CGFloat) {
        var blurEffect: UIBlurEffect!
        blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = alpha
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func removeBlurFromView() {
        for subView in self.subviews {
            if subView is UIVisualEffectView {
                subView.removeFromSuperview()
            }
        }
    }
    
}

