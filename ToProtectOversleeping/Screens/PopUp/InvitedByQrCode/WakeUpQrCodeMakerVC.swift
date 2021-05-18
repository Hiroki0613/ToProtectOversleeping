//
//  WakeUpQrCodeVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/16.
//

import UIKit


// 参考URL
// https://www.letitride.jp/entry/2019/12/10/091751
// https://www.avanderlee.com/swift/qr-code-generation-swift/

class WakeUpQrCodeMakerVC: UIViewController {
    
    var qrCodeImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let qrColor:UIColor = .systemOrange
        let wakeUpLogo = UIImage(named: "jinrikisya_man")!

        let qrURLImage = URL(string:"HirokiSample")?.qrImage(using: qrColor, logo: wakeUpLogo)
        
                guard let qr = qrURLImage else{
                        return
                    }
                    let imageView = UIImageView(image: UIImage(ciImage: qr))
                    imageView.frame.size.width = 200
                    imageView.frame.size.height = 200
        
                    imageView.center.x = self.view.frame.width / 2
                    imageView.center.y = self.view.frame.height / 2
        
                    self.view.addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
}



extension CIImage {
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }

    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }

        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }

    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }

    /// Applies the given color as a tint color.
    func tinted(using color: UIColor) -> CIImage?
    {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage

        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

        return filter.outputImage!
    }
    
    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage!
    }
}

extension URL {

    /// Creates a QR code for the current URL in the given color.
    func qrImage(using color: UIColor) -> CIImage? {
        return qrImage?.tinted(using: color)
    }

    /// Returns a black and white QR code for this URL.
    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let qrData = absoluteString.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")

        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
    
    func qrImage(using color: UIColor, logo: UIImage? = nil) -> CIImage? {
            let tintedQRImage = qrImage?.tinted(using: color)

            guard let logo = logo?.cgImage else {
                return tintedQRImage
            }

            return tintedQRImage?.combined(with: CIImage(cgImage: logo))
        }
}