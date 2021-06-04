//
//  QRCodeReaderVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/16.
//

import UIKit
import AVFoundation
import Firebase

class WakeUpQrCodeReaderVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let sendDBModel = SendDBModel()
    var wakeUpTimeText = ""
    var wakeUpTimeDate = Date()
    
    let qrCodeReader = WakeUpQrCodeReaderFunction()
    let qrCodeReadLabel = UILabel()
    var goBuckQRReadCameraModeButton = WUButton(backgroundColor: .systemOrange, title: "閉じる")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeReader.delegate = self
        qrCodeReader.setupCamera(view: self.view)
        // 読み込めるカメラ範囲
        qrCodeReader.readRange()
        qrCodeReadLabel.text = "空白"
        qrCodeReadLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        qrCodeReadLabel.frame = CGRect(x: 70, y: 130, width: view.frame.size.width, height: 100)
        view.addSubview(qrCodeReadLabel)
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configureUI() {
        goBuckQRReadCameraModeButton.translatesAutoresizingMaskIntoConstraints = false
        goBuckQRReadCameraModeButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        view.addSubview(goBuckQRReadCameraModeButton)
        
        let padding: CGFloat = 70.00
        
        NSLayoutConstraint.activate([
            goBuckQRReadCameraModeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            goBuckQRReadCameraModeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            goBuckQRReadCameraModeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
            goBuckQRReadCameraModeButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    @objc func tapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    //対象を認識、読み込んだ時に呼ばれる
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // 一画面上に複数のQRがある場合、複数読み込むが今回は便宜的に先頭のオブジェクトを処理
        if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
            let barCode = qrCodeReader.previewLayer.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
            //読み込んだQRを映像上で枠を囲む。ユーザへの通知。必要な時は記述しなくてよい。
            qrCodeReader.qrView.frame = barCode.bounds
            //QRデータを表示
            if let str = metadata.stringValue {
                print(str)
                qrCodeReadLabel.text = str
                
                sendDBModel.invitedChatRoom(roomNameId: str, wakeUpTimeDate: wakeUpTimeDate, wakeUpTimeText: wakeUpTimeText)
                
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
