//
//  UIImage+Ext.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/11/23.
//

import UIKit

/*
 参考URL:【Swift4】UIImageで画像のサイズ変更、指定した倍率で拡大/縮小
 https://qiita.com/zlq4863947/items/4b016824cf152bc2a769
 */

extension UIImage {
    // resize image
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }

    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
