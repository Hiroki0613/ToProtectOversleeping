//
//  CheckVendingMachineVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/04.
//

import UIKit
import AVKit
import Vision

class CheckVendingMachineVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var goBuckMachineLeaningCameraModeButton = WUButton(backgroundColor:PrimaryColor.primary, title:"閉じる")
    
    // 測定結果を表示するラベル
    var swipedActionLabel = WUBodyLabel(fontSize: 16)
    
    // 雨の日用
    let rainyDayLabel = WUBodyLabel(fontSize: 20)
    let rainyDaySwitch = UISwitch()
    
    
    //　スワイプボタン
    var swipeButton: SwipeButton!

    
//    let identifierLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = PrimaryColor.primary
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMachineLearningCamera()
        configureUI()
    }
    
    private func configureMachineLearningCamera() {
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    @objc func tapRainyDaySwitch(_ sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        
        if onCheck {
            print("雨の日です")
            swipeButton.isHidden = false
            swipeButton.isEnabled = true
            swipedActionLabel.text = "家から20m離れなくても\n解除可能です\nただし☔️通知がつきます"
            captureSession.stopRunning()
            
        } else {
            print("晴れの日です")
            swipeButton.isHidden = true
            swipeButton.isEnabled = false
            swipedActionLabel.text = "家から20m離れて\n自販機を写してください\n解除するとチームへ\n起床したことが通知されます"
            captureSession.startRunning()
        }
    }
    
    
    private func configureUI() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 40
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        
        let blurViewPadding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: blurViewPadding),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -blurViewPadding),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            blurView.heightAnchor.constraint(equalToConstant: view.frame.size.width - 50)
        ])
        
        swipedActionLabel.translatesAutoresizingMaskIntoConstraints = false
        swipedActionLabel.numberOfLines = 0
        swipedActionLabel.textAlignment = .center
        swipedActionLabel.text = "家から20m離れて\n自販機を写してください\n解除するとチームへ\n起床したことが通知されます"
        view.addSubview(swipedActionLabel)
        
        rainyDayLabel.text = "☔️の時"
        rainyDayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rainyDayLabel)
        
        rainyDaySwitch.isOn = false
        rainyDaySwitch.addTarget(self, action: #selector(tapRainyDaySwitch), for: .touchUpInside)
        rainyDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rainyDaySwitch)
        
        goBuckMachineLeaningCameraModeButton.translatesAutoresizingMaskIntoConstraints = false
        goBuckMachineLeaningCameraModeButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        view.addSubview(goBuckMachineLeaningCameraModeButton)
        
        let padding: CGFloat = 20.0
        setupSwipeButton()
        
        // 初期設定
        swipeButton.isHidden = true
        swipeButton.isEnabled = false

        
        NSLayoutConstraint.activate([
            rainyDayLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding),
            rainyDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            rainyDayLabel.widthAnchor.constraint(equalToConstant: 70),
            rainyDayLabel.heightAnchor.constraint(equalToConstant: 30),
            
            rainyDaySwitch.topAnchor.constraint(equalTo: rainyDayLabel.bottomAnchor, constant: 5),
            rainyDaySwitch.centerXAnchor.constraint(equalTo: rainyDayLabel.centerXAnchor),
            
            swipedActionLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding),
            swipedActionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            swipedActionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            swipedActionLabel.heightAnchor.constraint(equalToConstant: 100),
            
            goBuckMachineLeaningCameraModeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            goBuckMachineLeaningCameraModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            goBuckMachineLeaningCameraModeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            goBuckMachineLeaningCameraModeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupSwipeButton() {
        if swipeButton == nil {
            self.swipeButton = SwipeButton(frame: CGRect(x: 40, y: view.frame.height - 210, width: view.frame.size.width - 80, height: 50))
            swipeButton.isRightToLeft = false
            swipeButton.text = "→右へスワイプ→"
            view.addSubview(swipeButton)
        }
    }
    
    
//    fileprivate func configureIdentifierConfidenceLabel() {
//        view.addSubview(identifierLabel)
//
//        NSLayoutConstraint.activate([
//            identifierLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
//            identifierLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            identifierLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            identifierLabel.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
    
    @objc func tapBackButton() {
        captureSession.stopRunning()
        dismiss(animated: true, completion: nil)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: config).model) else { return }
        
        let request = VNCoreMLRequest(model: model) { finishedReq, error in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            print("宏輝_coreML: 種類： , 精度： ", firstObservation.identifier, firstObservation.confidence)
            
//            DispatchQueue.main.async {
//                self.identifierLabel.text = "\(firstObservation.identifier) \(firstObservation.confidence * 100)"
//            }
            if firstObservation.identifier == "vending machine" {
                if firstObservation.confidence > 0.8 {
                    self.captureSession.stopRunning()
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
