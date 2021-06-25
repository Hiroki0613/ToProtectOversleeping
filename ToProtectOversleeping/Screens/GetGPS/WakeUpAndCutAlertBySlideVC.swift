//
//  WakeUpAndCutAlertBySlideVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit
import MapKit
import KeychainSwift

class WakeUpAndCutAlertBySlideVC: BaseGpsVC {
    
    //keychainのデフォルトセッティング。見つけやすいように共通のprefixを実装。
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKeychain)

    // roomID
    var chatRoomDocumentId = ""
    var userName = ""
    var wakeUpTimeText = ""
    var authId = ""
    
    // Keychainでの設定値に問題があったらデフォルト値を採用
    var myAddressLatitude: Double = 35.637375
    var myAddressLongitude: Double = 139.756308
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
    var swipeButton: SwipeButton!
    
    var myHomeLocation = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        configureUI()
        swipeButton.getGeocoderDelegate = self
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
        let myAddressLatitudeFromKeychainString: String = keychain.get(Keys.myAddressLatitude) ?? "35.637375"
        let myAddressLongitudeFromKeychainString: String = keychain.get(Keys.myAddressLongitude) ?? "139.756308"
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
            // ２時間以上前の時
            swipedActionLabel.text = "現在はアラームを解除できません。\n\n設定した2時間以内になりましたら、\n解除ボタンが表示されます。"
            swipeButton.isHidden = true
            rainyDayLabel.isHidden = true
            rainyDaySwitch.isHidden = true
        } else {
            // ２時間以内の時
            swipedActionLabel.text = "解除するとチームへ\n起床したことが通知されます"
            swipeButton.isHidden = false
            rainyDayLabel.isHidden = false
            rainyDaySwitch.isHidden = false
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
        
        if rainyDaySwitch.isOn {
//            clearAlarm()
            let messageModel = MessageModel()
            messageModel.sendMessageToChatWakeUpAtRainyDay(documentID: chatRoomDocumentId, displayName: userName, wakeUpTimeText: wakeUpTimeText)
            return "OK!、雨の日モードで解除！"
        }
        
        //TODO: ここを任意で距離を決められても面白いかもしれない。
        
        switch rawDistance {
        case 0..<(10):
            return "あと、90m離れてください"
        case (10)..<(20):
            return "あと、80m離れてください"
        case (20)..<(30):
            return "あと、70m離れてください"
        case (30)..<(40):
            return "あと、60m離れてください"
        case (40)..<(50):
            return "あと、50m離れてください"
        case (50)..<(60):
            return "あと、40m離れてください"
        case (60)..<(70):
            return "あと、30m離れてください"
        case (80)..<(90):
            return "惜しい！、20m離れてください"
        case (90)..<(100):
            return "惜しい！、10m離れてください"
        default:
            print("離れました離れたぜ")
//            clearAlarm()
            let messageModel = MessageModel()
            messageModel.sendMessageToChatWakeUpSuccessMessage(documentID: chatRoomDocumentId, displayName: userName, wakeUpTimeText: wakeUpTimeText)
            return "OK!、100m以上離れました！"
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
            swipedActionLabel.text = "家から100m離れなくても\n解除可能です\nただし☔️通知がつきます"
            
        } else {
            print("晴れの日です")
            swipedActionLabel.text = "解除するとチームへ\n起床したことが通知されます"
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
        rainyDaySwitch.addTarget(self, action: #selector(tapRainyDaySwitch), for: .touchUpInside)
        rainyDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rainyDaySwitch)

        let padding:CGFloat = 20.0;
        setupSwipeButton()
        swipeButton.isHidden = true
        
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
            swipedActionLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // TODO: ここでswipeButtonでの判定が行われる。 100m以上離れた時と、離れていない時で分岐する。
    func setupSwipeButton() {
        if swipeButton == nil {
            self.swipeButton = SwipeButton(frame: CGRect(x: 40, y: view.frame.height - 100, width: view.frame.size.width - 80, height: 50))
            swipeButton.isRightToLeft = false
            swipeButton.text = "→右へスワイプ→"
            swipeButton.swipedText = "GPS取得中"
            view.addSubview(swipeButton)
        }
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
        let geoCoderLocation = CLLocationCoordinate2D(latitude: geoCoderLatitude, longitude: geoCoderLongitude)
        setAnnotation(location: geoCoderLocation)
        moveTo(center: geoCoderLocation, animated: false)
        print("geoCoderLatitude:", geoCoderLatitude)
        print("geoCoderLongitude:", geoCoderLongitude)
    }
}
