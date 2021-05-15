//
//  QRCodeReaderVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/16.
//

import UIKit
import AVFoundation

class WakeUpQrCodeReaderVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let qrCodeReader = WakeUpQrCodeReaderFunction()
    
    let qrCodeReadLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeReader.delegate = self
        qrCodeReader.setupCamera(view: self.view)
        // 読み込めるカメラ範囲
        qrCodeReader.readRange()
        qrCodeReadLabel.text = "空白"
        qrCodeReadLabel.font = UIFont.boldSystemFont(ofSize: 40.0)
        qrCodeReadLabel.frame = CGRect(x: 70, y: 130, width: view.frame.size.width, height: 100)
        view.addSubview(qrCodeReadLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
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
            }
        }
    }
}
