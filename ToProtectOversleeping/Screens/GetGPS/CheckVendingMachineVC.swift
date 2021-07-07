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

    var goBuckMachineLeaningCameraModeButton = WUButton(backgroundColor:.systemOrange, title:"閉じる")
    
    let identifierLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemOrange
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        

        configureMachineLearningCamera()
//        configureIdentifierConfidenceLabel()
//        configureDismissButton()

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
    
    private func configureDismissButton() {
        goBuckMachineLeaningCameraModeButton.translatesAutoresizingMaskIntoConstraints = false
        goBuckMachineLeaningCameraModeButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        view.addSubview(goBuckMachineLeaningCameraModeButton)
        
        let padding: CGFloat = 70.0
        
        NSLayoutConstraint.activate([
            goBuckMachineLeaningCameraModeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            goBuckMachineLeaningCameraModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            goBuckMachineLeaningCameraModeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            goBuckMachineLeaningCameraModeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    fileprivate func configureIdentifierConfidenceLabel() {
        view.addSubview(identifierLabel)
        
        NSLayoutConstraint.activate([
            identifierLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            identifierLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            identifierLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            identifierLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
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
