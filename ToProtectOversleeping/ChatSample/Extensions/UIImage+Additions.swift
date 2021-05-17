//
//  UIImage+Additions.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/16.
//

import UIKit

extension UIImage {
  
  
  // 画像投稿を実装する段階になったら入れても良いかも。
  // 待ち合わせにそんなものは不要！
  var scaledToSafeUploadSize: UIImage? {
    let maxImageSideLength: CGFloat = 480
    
    let largerSide: CGFloat = max(size.width, size.height)
    let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
    let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
    
    return image(scaledTo: newImageSize)
  }
  
  func image(scaledTo size: CGSize) -> UIImage? {
    defer {
      UIGraphicsEndImageContext()
    }
    
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    draw(in: CGRect(origin: .zero, size: size))

    return UIGraphicsGetImageFromCurrentImageContext()
  }
  
}
