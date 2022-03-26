//
//  WakeUpAndCutAlertVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2022/01/06.
//

import UIKit
import MapKit
import KeychainSwift
import AVKit
import Vision
import Instructions

class WakeUpAndCutAlertVC: BaseGpsVC {
    
    // keychainのデフォルトセッティング。見つけやすいように共通のprefixを実装。
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKeychain)
    
    // roomId
    var chatRoomDocumentId = ""
    var userName = ""
    
    var wakeUpTimeTextArray = [""]
    
    var authId = ""
    
    var twoHoursInSecond: Int = 7200
    
    // Keychainでの設定値に問題があったらデフォルト値を採用
    var myAddressLatitude: Double = PrimaryPlace.primaryAddressLatitude
    var myAddressLongitude: Double = PrimaryPlace.primaryAddressLongitude
    
    var mySettingAlarmTimeArray = [Date()]
    
    var alarm = Alarm()
    
    // 地図
    var mapView = MKMapView()
    // 測定結果を表示するラベル
    var swipedActionLabel = WUBodyLabel(fontSize: 16)
    
    // 雨の日用
    let rainyDayLabel = WUBodyLabel(fontSize: 20)
    let rainyDaySwitch = UISwitch()
    
    // スワイプボタン
    var myHomeLocation = CLLocationCoordinate2D()
    var goBuckCheckTimeButton = WUButton(backgroundColor: .clear, title: "閉じる")
    

    // CoreMl
    var machineBlurView = UIView()
    var goBuckMachineLeaningCameraModeButton = WUButton(backgroundColor: .clear, title: "閉じる")
    // 測定結果を表示するラベル
    var machineSwipedActionLabel = WUBodyLabel(fontSize: 16)
    // 雨の日用
    let machineRainyDayLabel = WUBodyLabel(fontSize: 20)
    let machineRainyDaySwitch = UISwitch()
    // スワイプボタン
    var machineSwipeButton: SwipeButton!
    let captureSession = AVCaptureSession()
    
    // コーチビューコントローラー(イントロダクション)を作成
    let coachMarksController = CoachMarksController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PrimaryColor.background
        configureMachineLearningCamera()
        configureUI()
        configureMachineUI()
        machineSwipeButton.getGeocoderDelegate = self
        getMyAddressFromKeyChain()
        myHomeLocation = CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("宏輝_時間調査: ", mySettingAlarmTimeArray)
        print("宏輝_時間調査2: ", wakeUpTimeTextArray)
        
        if isTodayIsWeekDay() == "平日" {
            checkSettingAlarmWithinTwoHoursAndWeekDAy(settingTime: mySettingAlarmTimeArray[0])
        } else {
            checkSettingAlarmWithinTwoHoursAndWeekDAy(settingTime: mySettingAlarmTimeArray[1])
        }
        
        
        self.view.layoutIfNeeded()
        // ここでUserDefaultsで記録した住所を入れる。
        moveTo(center: myHomeLocation, animated: false)
        drawCircle(center: myHomeLocation, meter: 10, times: 10)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        //イントロダクションのdataSourceを実装
        self.coachMarksController.delegate = self
        self.coachMarksController.dataSource = self
        self.coachMarksController.overlay.blurEffectStyle = .regular
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkTheInstructionModeIsNeed()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.set(false, forKey: UserDefaultsString.isFirstAccessToGPSVendingMachineScan)
        self.coachMarksController.stop(immediately: true)
    }
    
    // instruction
    func checkTheInstructionModeIsNeed() {
        if UserDefaults.standard.bool(forKey: UserDefaultsString.isFirstAccessToGPSVendingMachineScan) == true {
            // 最初にアプリをダウンロードした時に出てくるインストラクション
            self.coachMarksController.start(in: .currentWindow(of: self))
        } else {
            print("instructionが全て終了しました")
        }
    }
    
    func getMyAddressFromKeyChain() {
        let myAddressLatitudeFromKeychainString: String = keychain.get(Keys.myAddressLatitude) ?? "\(PrimaryPlace.primaryAddressLatitude)"
        let myAddressLongitudeFromKeychainString: String = keychain.get(Keys.myAddressLongitude) ?? "\(PrimaryPlace.primaryAddressLongitude)"
        
        print("宏輝_Keys.myAddressLatitude: ", keychain.get(Keys.myAddressLatitude))
        print("宏輝_Keys.myAddressLongitude: ", keychain.get(Keys.myAddressLongitude))
        
        if let myAddressLatitude = Double(myAddressLatitudeFromKeychainString),
           let myAddressLongitude = Double(myAddressLongitudeFromKeychainString) {
            self.myAddressLatitude = myAddressLatitude
            self.myAddressLongitude = myAddressLongitude
        }
    }
    
    // ここで2時間以内だった時の設定を入れる
    func checkSettingAlarmWithinTwoHoursAndWeekDAy(settingTime: Date) {
        var differenceFromCurrenTime = 0
        differenceFromCurrenTime = alarm.calculateTimeInterval(userAwakeTime: settingTime)
        print("宏輝_weekDayOrWeekEnd: ", isTodayIsWeekDay())
        print("宏輝_時間調査_差分: ", differenceFromCurrenTime)
        
        //TODO: まず、押した日が平日or休日を判定し、判定した方の時間が設定値から2時間以内だった場合は、"起きた"報告をチャットに出来るようにする。
        if differenceFromCurrenTime < twoHoursInSecond {
            // 2時間以内
            setAlaramWithin2Hours()
        } else {
            // 2時間よりも前だと、そもそもアラームを解除できない
            setAlarmWithOut2Hours()
        }
    }
    
    // 2時間以上前
    private func setAlarmWithOut2Hours() {
        captureSession.stopRunning()
        // 2時間以上前の時
        swipedActionLabel.text = "現在は自販機をスキャンできません。\n\n設定した2時間以内になりましたら、\n解除ボタンが表示されます。"
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
    }
    
    private func setAlaramWithin2Hours() {
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
        //ストアリリース時は、startRunningをコメントアウトすると、スクリーンショット画面が取得できる。
        captureSession.startRunning()
        machineBlurView.addBlurToView(alpha: 0.4)
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
    
    // 現時刻が平日か、休日かを判定するString
    func isTodayIsWeekDay() -> String {
        enum WeekDay: Int {
            case sunday = 1
            case monday = 2
            case tuesday = 3
            case wednesday = 4
            case thursday = 5
            case friday = 6
            case saturday = 7
        }
        
        let comp = Calendar.Component.weekday
        //1が日曜日7が土曜日で帰ってくる
        let weekday = WeekDay(rawValue: NSCalendar.current.component(comp, from: NSDate() as Date))!
        
        switch weekday {
        case .sunday:
            print("日曜日")
            return "休日"
        case .monday:
            print("月曜日")
            return "平日"
        case .tuesday:
            print("火曜日")
            return "平日"
        case .wednesday:
            print("水曜日")
            return "平日"
        case .thursday:
            print("木曜日")
            return "平日"
        case .friday:
            print("金曜日")
            return "平日"
        case .saturday:
            print("土曜日")
            return "休日"
        }
    }
    
    //TODO: (#2)休日については、日本の祝日を含むようにする。
    //TODO: 現時刻が平日か、土日祝日かを判定するString。returnは平日、休日で良いと思う。ここで分岐をかける。
    
    
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
            messageModel.sendMessageToChatWakeUpAtRainyDay(documentID: chatRoomDocumentId, displayName: userName, wakeUpTimeText: wakeUpTimeTextArray[0])
            // ここでLottieで、OK!を通知したい。
            return "OK!、雨の日モードで報告しました！\n2秒後にHomeに戻ります。"
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
            //ここで自動販売機を検知＋20m以上離れたときのalarmをチャットに送る。
            messageModel.sendMessageToChatWakeUpSuccessMessage(documentID: chatRoomDocumentId, displayName: userName, wakeUpTimeText: wakeUpTimeTextArray[0])
            // ここでLottieで、OK!を通知したい。
            return "OK!\n20m以上離れました！\n起きたことを報告しました\n2秒後にHomeに戻ります。"
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
            machineSwipedActionLabel.text = "家から20m離れなくても\n起きたことを通知可能です\nただし☔️通知がつきます"
            captureSession.stopRunning()
            
        } else {
            print("晴れの日です")
            machineSwipeButton.isHidden = true
            machineSwipeButton.isEnabled = false
            machineSwipedActionLabel.text = "家から20m離れて\n自販機を写してください\n\nスキャンするとチームへ\n起床したことが通知されます"
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
    
    @objc func tapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension WakeUpAndCutAlertVC: MKMapViewDelegate {
    // アノテーションビューについて、設定するdelegate
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

extension WakeUpAndCutAlertVC: GetGeocoderDelegate {
    func getAddressFromCurrentPlace() {
        getCurrentLocation()
        swipedActionLabel.text = "取得完了しました"
        machineSwipedActionLabel.text = "OK!\n雨の日モードで報告！\n起きたことの通知を\n送信しました\n２秒後にHomeに移動します。"
        machineSwipeButton.text = "通知完了"
        let geoCoderLocation = CLLocationCoordinate2D(latitude: geoCoderLatitude, longitude: geoCoderLongitude)
        setAnnotation(location: geoCoderLocation)
        moveTo(center: geoCoderLocation, animated: false)
        print("geoCoderLatitude:", geoCoderLatitude)
        print("geoCoderLongitude:", geoCoderLongitude)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension WakeUpAndCutAlertVC: AVCaptureVideoDataOutputSampleBufferDelegate {
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
        machineBlurView.addBlurToView(alpha: 0.7)
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
        machineSwipedActionLabel.text = "家から20m離れて\n自販機を写してください\n\nスキャンするとチームへ\n起床したことが通知されます"
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
    
    //自動販売機を検知したら動くfunc
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: config).model) else { return }
        
        let request = VNCoreMLRequest(model: model) { finishedReq, error in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            print("宏輝_coreML: 種類： , 精度： ", firstObservation.identifier, firstObservation.confidence)
            
            if firstObservation.identifier == "vending machine" {
                if firstObservation.confidence > 0.8 {
                    self.captureSession.stopRunning()
                    self.getCurrentLocation()
                    let geoCoderLocation = CLLocationCoordinate2D(latitude: self.geoCoderLatitude, longitude: self.geoCoderLongitude)
                    
                    DispatchQueue.main.async {
                        self.machineSwipedActionLabel.text = self.rank(location: geoCoderLocation)
                        self.captureSession.stopRunning()
                        
                        //自販機でスキャンしてOKだった場合は、自動的にHome画面に戻るようにする。
                        let machineSwipedActionLabelText = self.rank(location: geoCoderLocation)
                        
                        if machineSwipedActionLabelText.contains("OK!") {

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                //OK!、雨の日モードで解除！
                                //"OK!\n20m以上離れました！\n起きたことを\n送信しました"
                                //が含まれてたら、１秒後に画面が閉じてHome画面に移動させる。
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

extension WakeUpAndCutAlertVC: CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            var coachMark = coachMarksController.helper.makeCoachMark(for: view)
            coachMark.isDisplayedOverCutoutPath = true
            return coachMark
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        //吹き出しのビューを作成します
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,    //三角の矢印をつけるか
            arrowOrientation: coachMark.arrowOrientation    //矢印の向き(吹き出しの位置)
        )
        
        if UserDefaults.standard.bool(forKey: UserDefaultsString.isFirstAccessToGPSVendingMachineScan) == true {
            switch index {
            case 0:
                coachViews.bodyView.hintLabel.text = "自販機のスキャン画面です。\n\n設定した時間内に自販機をスキャンすると\nチームのチャットへ起きたことが\n通知されます。"
                coachViews.bodyView.nextLabel.text = "OK!"
            default:
                break
            }
        } else {
            switch index {
            default:
                break
            }
        }
        //その他の設定が終わったら吹き出しを返します
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

