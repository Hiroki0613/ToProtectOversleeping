//
//  WakeUpAndCutAlertBySlideVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit
import MapKit
import KeychainSwift
import AVKit
import Vision

class WakeUpAndCutAlertBySlideVC: BaseGpsVC {
    
    //keychainのデフォルトセッティング。見つけやすいように共通のprefixを実装。
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKeychain)

    // roomID
    var chatRoomDocumentId = ""
    var userName = ""
    var wakeUpTimeText = ""
    var authId = ""
    
    // Keychainでの設定値に問題があったらデフォルト値を採用
    var myAddressLatitude: Double = PrimaryPlace.primaryAddressLatitude
    var myAddressLongitude: Double = PrimaryPlace.primaryAddressLongitude
    var mySettingAlarmTime = Date()
    
    var alarm = Alarm()
    
    // 地図
    var mapView = MKMapView()
    // 測定結果を表示するラベル
    var swipedActionLabel = WUBodyLabel(fontSize: 16)
    
    // 雨の日用
    let rainyDayLabel = WUBodyLabel(fontSize: 20)
    let rainyDaySwitch = UISwitch()
    
    //　スワイプボタン
//    var swipeButton: SwipeButton!
    var myHomeLocation = CLLocationCoordinate2D()
    var goBuckCheckTimeButton = WUButton(backgroundColor:PrimaryColor.primary, title:"閉じる")
    
    
    
    // CoreMl
//    let machineBlurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    var machineBlurView = UIView()
    var goBuckMachineLeaningCameraModeButton = WUButton(backgroundColor:PrimaryColor.primary, title:"閉じる")
    // 測定結果を表示するラベル
    var machineSwipedActionLabel = WUBodyLabel(fontSize: 16)
    // 雨の日用
    let machineRainyDayLabel = WUBodyLabel(fontSize: 20)
    let machineRainyDaySwitch = UISwitch()
    //　スワイプボタン
    var machineSwipeButton: SwipeButton!
    let captureSession = AVCaptureSession()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PrimaryColor.primary
        configureMachineLearningCamera()
        configureUI()
        configureMachineUI()
//        swipeButton.getGeocoderDelegate = self
        machineSwipeButton.getGeocoderDelegate = self
        getMyAddressFromKeyChain()
        myHomeLocation = CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude)
        print("ゲット",myAddressLongitude)
        print(myAddressLatitude)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("宏輝_時間調査: ", mySettingAlarmTime)
        checkSettingAlarmWithinTwoHours(settingTime: mySettingAlarmTime)
        self.view.layoutIfNeeded()
        // ここでUserDefaultsで記録した住所を入れる。
        moveTo(center: myHomeLocation, animated: false)
        drawCircle(center: myHomeLocation, meter: 10, times: 10)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getMyAddressFromKeyChain() {
        let myAddressLatitudeFromKeychainString: String = keychain.get(Keys.myAddressLatitude) ?? "\(PrimaryPlace.primaryAddressLatitude)"
        let myAddressLongitudeFromKeychainString: String = keychain.get(Keys.myAddressLongitude) ?? "\(PrimaryPlace.primaryAddressLongitude)"
        if let myAddressLatitude = Double(myAddressLatitudeFromKeychainString),
           let myAddressLongitude = Double(myAddressLongitudeFromKeychainString) {
            self.myAddressLatitude = myAddressLatitude
            self.myAddressLongitude = myAddressLongitude
        }
    }
    
    
    // ここで2時間以内だった時の設定を入れる
    func checkSettingAlarmWithinTwoHours(settingTime: Date) {
        var differenceFromCurrenTime = 0
        differenceFromCurrenTime = alarm.calculateTimeInterval(userAwakeTime: settingTime)
        
        print("宏輝_時間調査_差分: ", differenceFromCurrenTime)

        if differenceFromCurrenTime > 7200 {
            captureSession.stopRunning()
            // ２時間以上前の時
            swipedActionLabel.text = "現在はアラームを解除できません。\n\n設定した2時間以内になりましたら、\n解除ボタンが表示されます。"
//            swipeButton.isHidden = true
            rainyDayLabel.isHidden = true
            rainyDaySwitch.isHidden = true
            goBuckCheckTimeButton.isHidden = false
            goBuckCheckTimeButton.isEnabled = true
            
            // coreMLは閉じる
            machineBlurView.removeBlurFromView()
            machineBlurView.isHidden = true
            goBuckMachineLeaningCameraModeButton.isHidden = true
            goBuckMachineLeaningCameraModeButton.isEnabled = false
            machineSwipedActionLabel.isHidden = true
            machineRainyDayLabel.isHidden = true
            machineRainyDaySwitch.isHidden = true
            machineRainyDaySwitch.isEnabled = false
            machineSwipeButton.isHidden = true
            machineSwipeButton.isEnabled = false
            
            
        } else {
            // ２時間以内の時
//            configureMachineLearningCamera()
            
            // Map画面はhidden
            mapView.isHidden = true
            swipedActionLabel.isHidden = true
            swipedActionLabel.text = "2時間以内です\nカメラを起動します"
            rainyDayLabel.isHidden = true
            rainyDaySwitch.isHidden = true
            rainyDaySwitch.isEnabled = false
//            swipeButton.isHidden = true
//            swipeButton.isEnabled = false
            goBuckCheckTimeButton.isHidden = true
            goBuckCheckTimeButton.isEnabled = false

            // CoreMl画面を出す
            captureSession.startRunning()
            machineBlurView.addBlurToView(alpha: 0.9)
            machineBlurView.isHidden = false
            goBuckMachineLeaningCameraModeButton.isHidden = false
            goBuckMachineLeaningCameraModeButton.isEnabled = true
            machineSwipedActionLabel.isHidden = false
            machineRainyDayLabel.isHidden = false
            machineRainyDaySwitch.isHidden = false
            machineRainyDaySwitch.isEnabled = true
            
            if machineRainyDaySwitch.isOn {
                machineSwipeButton.isHidden = false
                machineSwipeButton.isEnabled = true
            } else {
                machineSwipeButton.isHidden = true
                machineSwipeButton.isEnabled = false
            }
        }
    }
    
    // 地図を任意の場所へ移動させる
    private func moveTo(
        center location: CLLocationCoordinate2D,
        animated: Bool,
        span: CLLocationDegrees = 0.0025) {
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let coordinateRegion = MKCoordinateRegion(center: location, span: coordinateSpan)
        mapView.setRegion(coordinateRegion, animated: animated)
    }
    
    // アノテーションを設定
    private func setAnnotation(location: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = rank(location: location)
        annotation.subtitle = location.distanceTextFromHome(to: myHomeLocation)
        mapView.addAnnotation(annotation)
    }
    
    // 地図上にサークルを描く
    private func drawCircle(
        center location: CLLocationCoordinate2D,
        meter: CLLocationDistance,
        times: Int) {
        mapView.addOverlays((1...times).map { i -> MKCircle in
            let radius = meter * CLLocationDistance(i)
            return MKCircle(center: location, radius: radius)
        })
    }
    
    // 距離を測定して、コメントを分類
    private func rank(location: CLLocationCoordinate2D) -> String {
        let rawDistance = location.distanceFromHome(to: myHomeLocation)
        
        print("rawDistance: ", rawDistance)
        
        if machineRainyDaySwitch.isOn {
            
            print("宏輝_起きた_chatRoomDocumentID: ",chatRoomDocumentId)
//            clearAlarm()
            let messageModel = MessageModel()
            messageModel.sendMessageToChatWakeUpAtRainyDay(documentID: chatRoomDocumentId, displayName: userName, wakeUpTimeText: wakeUpTimeText)
            return "OK!、雨の日モードで解除！"
        }
        
        //TODO: ここを任意で距離を決められても面白いかもしれない。
//        switch rawDistance {
//        case 0..<(10):
//            return "あと、90m離れてください"
//        case (10)..<(20):
//            return "あと、80m離れてください"
//        case (20)..<(30):
//            return "あと、70m離れてください"
//        case (30)..<(40):
//            return "あと、60m離れてください"
//        case (40)..<(50):
//            return "あと、50m離れてください"
//        case (50)..<(60):
//            return "あと、40m離れてください"
//        case (60)..<(70):
//            return "あと、30m離れてください"
//        case (80)..<(90):
//            return "惜しい！、20m離れてください"
//        case (90)..<(100):
//            return "惜しい！、10m離れてください"
//        default:
//            print("離れました離れたぜ")
////            clearAlarm()
//            let messageModel = MessageModel()
//            messageModel.sendMessageToChatWakeUpSuccessMessage(documentID: chatRoomDocumentId, displayName: userName, wakeUpTimeText: wakeUpTimeText)
//            return "OK!、100m以上離れました！"
//        }
        
        
        // 家から20m離れたらアラームカット出来るようにする。
        switch rawDistance {
        case 0..<(10):
            return "あと、20mほど離れてください"
        case (10)..<(20):
            return "あと、10mほど離れてください"
        default:
            let messageModel = MessageModel()
            messageModel.sendMessageToChatWakeUpSuccessMessage(documentID: chatRoomDocumentId, displayName: userName, wakeUpTimeText: wakeUpTimeText)
            return "OK!\n20m以上離れました！\nアラームカットの通知を\n送信しました"
        }
    }

    // アラームを消す(予約している投稿を削除する)
    // ここでAuth、roomIDを入れる。
    func clearAlarm(){
        let identifier = authId + chatRoomDocumentId
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    @objc func tapRainyDaySwitch(_ sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        
        if onCheck {
            print("雨の日です")
            machineSwipeButton.isHidden = false
            machineSwipeButton.isEnabled = true
            machineSwipedActionLabel.text = "家から20m離れなくても\n解除可能です\nただし☔️通知がつきます"
            captureSession.stopRunning()
            
        } else {
            print("晴れの日です")
            machineSwipeButton.isHidden = true
            machineSwipeButton.isEnabled = false
            machineSwipedActionLabel.text = "家から20m離れて\n自販機を写してください\n解除するとチームへ\n起床したことが通知されます"
            captureSession.startRunning()
        }
    }
    
    
    func configureUI() {
        mapView.delegate = self
        locationManager.delegate = self
        // Mapの大きさを定義
        mapView.translatesAutoresizingMaskIntoConstraints = false
        swipedActionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        swipedActionLabel.numberOfLines = 0
        swipedActionLabel.textAlignment = .center
        view.addSubview(swipedActionLabel)
        
        rainyDayLabel.text = "☔️の時"
        rainyDayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rainyDayLabel)
        rainyDaySwitch.isOn = false
//        rainyDaySwitch.addTarget(self, action: #selector(tapRainyDaySwitch), for: .touchUpInside)
        rainyDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rainyDaySwitch)

        let padding:CGFloat = 20.0
//        setupSwipeButton()
//        swipeButton.isHidden = true
        
        goBuckCheckTimeButton.translatesAutoresizingMaskIntoConstraints = false
        goBuckCheckTimeButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        view.addSubview(goBuckCheckTimeButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.size.width),
            
            rainyDayLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10),
            rainyDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            rainyDayLabel.widthAnchor.constraint(equalToConstant: 70),
            rainyDayLabel.heightAnchor.constraint(equalToConstant: 30),
            
            rainyDaySwitch.topAnchor.constraint(equalTo: rainyDayLabel.bottomAnchor, constant: 10),
            rainyDaySwitch.centerXAnchor.constraint(equalTo: rainyDayLabel.centerXAnchor),
            
            swipedActionLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: padding),
            swipedActionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            swipedActionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            swipedActionLabel.heightAnchor.constraint(equalToConstant: 100),
            
            goBuckCheckTimeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            goBuckCheckTimeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            goBuckCheckTimeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            goBuckCheckTimeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // TODO: ここでswipeButtonでの判定が行われる。 100m以上離れた時と、離れていない時で分岐する。
//    func setupSwipeButton() {
//        if swipeButton == nil {
//            self.swipeButton = SwipeButton(frame: CGRect(x: 40, y: view.frame.height - 100, width: view.frame.size.width - 80, height: 50))
//            swipeButton.isRightToLeft = false
//            swipeButton.text = "→右へスワイプ→"
//            swipeButton.swipedText = "GPS取得中"
//            view.addSubview(swipeButton)
//        }
//    }
    
    @objc func tapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}


extension WakeUpAndCutAlertBySlideVC: MKMapViewDelegate {
    // アニテーションビューについて、設定するdelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotation"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            // アノテーションを画像にする
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = UIImage(systemName: "figure.wave")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    // 円を描いた時に、どのような色、太さになるかを決める
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = .brown
        circleRenderer.lineWidth = 0.5
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        guard let annotation = views.first?.annotation else { return }
        mapView.selectAnnotation(annotation, animated: true)
    }
}


// 2点間の距離を測定
extension CLLocationCoordinate2D {
    func distanceFromHome(
        to targetLoacation: CLLocationCoordinate2D) -> CLLocationDistance {
        
        let location1 = CLLocation(latitude: latitude, longitude: longitude)
        let location2 = CLLocation(latitude: targetLoacation.latitude, longitude: targetLoacation.longitude)
        return location1.distance(from: location2)
    }
    // 距離をStringで表示
    func distanceTextFromHome(to targetLocation: CLLocationCoordinate2D) -> String {
        
        let rawDistance = distanceFromHome(to: targetLocation)
        print("distanceTextFromHome. rawDistance", rawDistance)
        
        // 1km未満は四捨五入で10m単位
        if rawDistance < 1000 {
            let roundedDistance = (rawDistance / 10).rounded() * 10
            return "\(Int(roundedDistance))m"
        }
        // 1km以上は四捨五入で0.1km単位
        let roundedDistance = (rawDistance / 100).rounded() * 100
        return "\(roundedDistance / 1000)km"
    }
}

extension WakeUpAndCutAlertBySlideVC: GetGeocoderDelegate {
    func getAddressFromCurrentPlace() {
        getCurrentLocation()
        swipedActionLabel.text = "取得完了しました"
        machineSwipedActionLabel.text = "OK!\n雨の日モードで解除！\nアラームカットの通知を\n送信しました"
        machineSwipeButton.text = "通知完了"
        let geoCoderLocation = CLLocationCoordinate2D(latitude: geoCoderLatitude, longitude: geoCoderLongitude)
        setAnnotation(location: geoCoderLocation)
        moveTo(center: geoCoderLocation, animated: false)
        print("geoCoderLatitude:", geoCoderLatitude)
        print("geoCoderLongitude:", geoCoderLongitude)
    }
}


// CoreMl関連
extension WakeUpAndCutAlertBySlideVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private func configureMachineLearningCamera() {
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
//        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    private func configureMachineUI() {
        
        machineBlurView.layer.cornerRadius = 40
        machineBlurView.clipsToBounds = true
        machineBlurView.translatesAutoresizingMaskIntoConstraints = false
        machineBlurView.addBlurToView(alpha: 0.9)
        view.addSubview(machineBlurView)
        
        let blurViewPadding: CGFloat = 10
        setupMachineSwipeButton()
        
        NSLayoutConstraint.activate([
            machineBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: blurViewPadding),
            machineBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -blurViewPadding),
            machineBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            machineBlurView.heightAnchor.constraint(equalToConstant: view.frame.size.width - 50)
        ])
        
        machineSwipedActionLabel.translatesAutoresizingMaskIntoConstraints = false
        machineSwipedActionLabel.numberOfLines = 0
        machineSwipedActionLabel.textAlignment = .center
        machineSwipedActionLabel.text = "家から20m離れて\n自販機を写してください\n解除するとチームへ\n起床したことが通知されます"
        view.addSubview(machineSwipedActionLabel)
        
        machineRainyDayLabel.text = "☔️の時"
        machineRainyDayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(machineRainyDayLabel)
        
        machineRainyDaySwitch.isOn = false
        machineRainyDaySwitch.addTarget(self, action: #selector(tapRainyDaySwitch), for: .touchUpInside)
        machineRainyDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(machineRainyDaySwitch)
        
        goBuckMachineLeaningCameraModeButton.translatesAutoresizingMaskIntoConstraints = false
        goBuckMachineLeaningCameraModeButton.addTarget(self, action: #selector(tapMachineBackButton), for: .touchUpInside)
        view.addSubview(goBuckMachineLeaningCameraModeButton)
        
        let padding: CGFloat = 20.0
        
        
        // 初期設定
//        machineSwipeButton.isHidden = true
//        machineSwipeButton.isEnabled = false

        
        NSLayoutConstraint.activate([
            machineRainyDayLabel.topAnchor.constraint(equalTo: machineBlurView.topAnchor, constant: padding),
            machineRainyDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            machineRainyDayLabel.widthAnchor.constraint(equalToConstant: 70),
            machineRainyDayLabel.heightAnchor.constraint(equalToConstant: 30),
            
            machineRainyDaySwitch.topAnchor.constraint(equalTo: machineRainyDayLabel.bottomAnchor, constant: 5),
            machineRainyDaySwitch.centerXAnchor.constraint(equalTo: machineRainyDayLabel.centerXAnchor),
            
            machineSwipedActionLabel.topAnchor.constraint(equalTo: machineBlurView.topAnchor, constant: padding),
            machineSwipedActionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            machineSwipedActionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            machineSwipedActionLabel.heightAnchor.constraint(equalToConstant: 100),
            
            goBuckMachineLeaningCameraModeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            goBuckMachineLeaningCameraModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            goBuckMachineLeaningCameraModeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            goBuckMachineLeaningCameraModeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupMachineSwipeButton() {
        if machineSwipeButton == nil {
            self.machineSwipeButton = SwipeButton(frame: CGRect(x: 40, y: view.frame.height - 210, width: view.frame.size.width - 80, height: 50))
            machineSwipeButton.isRightToLeft = false
            machineSwipeButton.text = "→右へスワイプ→"
            machineSwipeButton.swipedText = "通知完了"
            view.addSubview(machineSwipeButton)
        }
    }
    
    
    @objc func tapMachineBackButton() {
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
                    self.getCurrentLocation()
                    let geoCoderLocation = CLLocationCoordinate2D(latitude: self.geoCoderLatitude, longitude: self.geoCoderLongitude)
                    
                    DispatchQueue.main.async {
                        self.machineSwipedActionLabel.text = self.rank(location: geoCoderLocation)
//                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
}
