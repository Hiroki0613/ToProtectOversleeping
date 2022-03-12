//
//  UIView+Ext.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/11.
//

import Foundation
import UIKit

extension UIView {
    
    func addBlurToView(alpha: CGFloat, style:UIBlurEffect.Style = .systemThinMaterialDark) {
        var blurEffect: UIBlurEffect!
        blurEffect = UIBlurEffect(style: style)
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
    
    func addBackground(name: String) {
        let width = UIScreen.main.bounds.size.width
                let height = UIScreen.main.bounds.size.height

                // スクリーンサイズにあわせてimageViewの配置
                let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                //imageViewに背景画像を表示
                imageViewBackground.image = UIImage(named: name)

                // 画像の表示モードを変更。
                imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

                // subviewをメインビューに追加
                self.addSubview(imageViewBackground)
                // 加えたsubviewを、最背面に設置する
                self.sendSubviewToBack(imageViewBackground)
    }
    
}

