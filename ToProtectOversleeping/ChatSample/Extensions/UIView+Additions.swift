//
//  UIView+Additions.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/16.
//

import UIKit

extension UIView {
  
  // コーナーを角丸にしている。 ログインの画面を装飾している
  func smoothRoundCorners(to radius: CGFloat) {
    let maskLayer = CAShapeLayer()
    maskLayer.path = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: radius
    ).cgPath
    
    layer.mask = maskLayer
  }
  
}
