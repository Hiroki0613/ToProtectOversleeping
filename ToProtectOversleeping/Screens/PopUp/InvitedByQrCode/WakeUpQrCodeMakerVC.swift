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
    
    let scrollView = UIScrollView()
    var containerView = UIView()
    
    var qrCodeImageView = UIImageView()
    
    var qrCodeExplainLabel = WUBodyLabel(fontSize: 20)
    var qrCodeTeamNameView = UIView()
    var qrCodeLabel = WUBodyLabel(fontSize: 20)
    var descriptionTheWayHowToInviteIntoTeamLabel = WUBodyLabel(fontSize: 20)
    
    // カード式から招待documentIDを持ってくる。
    var invitedDocumentId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PrimaryColor.primary
        
        let qrColor:UIColor = .darkText
        let wakeUpLogo = UIImage(named: "wakeup")!
        
        let qrURLImage = URL(string: invitedDocumentId)?.qrImage(using: qrColor, logo: wakeUpLogo)
        
        
        
        guard let qr = qrURLImage else{
            return
        }
        let imageView = UIImageView(image: UIImage(ciImage: qr))
        imageView.frame.size.width = 200
        imageView.frame.size.height = 200
        
        imageView.center.x = self.view.frame.width / 2
        imageView.center.y = self.view.frame.height / 2
        
        qrCodeImageView = imageView
//        self.view.addSubview(imageView)
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //ラベルをタップしてコピー
    @objc func tappedLabel(_ sender:UITapGestureRecognizer) {
        UIPasteboard.general.string = qrCodeLabel.text
        print("clip board :\(UIPasteboard.general.string!)")
        alert(title: "コピーしました", message: "")
    }
    
    //アラート
    func alert(title: String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureView() {
        // 画面がスクロールするようにする
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(containerView)
        
        qrCodeExplainLabel.text = "IDをタッチするとコピーができます"
        qrCodeExplainLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(qrCodeExplainLabel)
        
        qrCodeLabel.text = invitedDocumentId
        qrCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        qrCodeLabel.isUserInteractionEnabled = true
        qrCodeLabel.textAlignment = .center
        
        let tg = UITapGestureRecognizer(target: self, action: #selector(tappedLabel(_:)))
        qrCodeLabel.addGestureRecognizer(tg)
        containerView.addSubview(qrCodeLabel)
        
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(qrCodeImageView)
        
        descriptionTheWayHowToInviteIntoTeamLabel.text = "チームへの招待の方法\n\nID招待の場合\n①招待される側でHome画面で右下のプラスボタンをタップ\n②任意の時間を設定し、招待されるボタンをタップ\n③招待IDを入力し、選択ボタンをタップ\n\nQR読み取りの場合\n①招待される側でHome画面で右下のプラスボタンをタップ\n②任意の時間を設定し、招待されるボタンをタップ\n③QR読み取りボタンをタップするとカメラが起動するのでQRコードを読み込むとチームへ招待されます"
        descriptionTheWayHowToInviteIntoTeamLabel.numberOfLines = 0
        descriptionTheWayHowToInviteIntoTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionTheWayHowToInviteIntoTeamLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 1000),
            
            qrCodeExplainLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            qrCodeExplainLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            qrCodeExplainLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            qrCodeExplainLabel.heightAnchor.constraint(equalToConstant: 30),
            
            qrCodeLabel.topAnchor.constraint(equalTo: qrCodeExplainLabel.bottomAnchor, constant: 10),
            qrCodeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            qrCodeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            qrCodeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            qrCodeImageView.topAnchor.constraint(equalTo: qrCodeLabel.bottomAnchor, constant: 10),
            qrCodeImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            descriptionTheWayHowToInviteIntoTeamLabel.topAnchor.constraint(equalTo: qrCodeImageView.bottomAnchor, constant: 20),
            descriptionTheWayHowToInviteIntoTeamLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            descriptionTheWayHowToInviteIntoTeamLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            descriptionTheWayHowToInviteIntoTeamLabel.heightAnchor.constraint(equalToConstant: 600)
        ])
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
