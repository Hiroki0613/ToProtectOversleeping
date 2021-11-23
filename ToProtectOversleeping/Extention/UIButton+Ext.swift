//
//  UIButton+Ext.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/11/20.
//

import UIKit

/*参考URL
 https://stackoverflow.com/questions/25550719/add-a-blur-effect-to-a-uibutton/32861709
 */

extension UIButton {
    func addBlurToButton(alpha: CGFloat, style: UIBlurEffect.Style = .systemUltraThinMaterialDark, cornerRadius: CGFloat = 0, padding: CGFloat = 0) {
        backgroundColor = .clear

//        let blurEffect = UIBlurEffect(style: .regular)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        self.insertSubview(blurView, at: 0)
//
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            self.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding),
//            self.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: padding),
//            self.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding),
//            self.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -padding)
//        ])
//
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect,style: .label)
//        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
//
//        vibrancyView.alpha = alpha
//        vibrancyView.isUserInteractionEnabled = false
//        vibrancyView.backgroundColor = .clear
//        if cornerRadius > 0 {
//            vibrancyView.layer.cornerRadius = cornerRadius
//            vibrancyView.layer.masksToBounds = true
//        }
//        self.insertSubview(vibrancyView, at: 0)
//
//        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
//        vibrancyView.contentView.addSubview(view)
//
//        NSLayoutConstraint.activate([
//            self.topAnchor.constraint(equalTo: vibrancyView.topAnchor, constant: padding),
//            self.leadingAnchor.constraint(equalTo: vibrancyView.leadingAnchor, constant: padding),
//            self.trailingAnchor.constraint(equalTo: vibrancyView.trailingAnchor, constant: -padding),
//            self.bottomAnchor.constraint(equalTo: vibrancyView.bottomAnchor, constant: -padding)
//
//        ])
//
//        if let imageView = self.imageView {
//            imageView.backgroundColor = .clear
//            self.bringSubviewToFront(imageView)
//        }
        
     
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.alpha = alpha
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        if cornerRadius > 0 {
            blurView.layer.cornerRadius = cornerRadius
            blurView.layer.masksToBounds = true
        }
        self.insertSubview(blurView, at: 0)

        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding).isActive = true
        self.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -padding).isActive = true

        if let imageView = self.imageView {
            imageView.backgroundColor = .clear
            self.bringSubviewToFront(imageView)
        }
    }
}
