//
//  WakeUpAndCutAlertBySlideVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit
import MapKit

class WakeUpAndCutAlertBySlideVC: BaseGpsVC {
    
    // 暫定で家の近くに設定している
    var myAddressLatitude = 35.7140224101
    var myAddressLongitude = 139.65362018
    var mySettingAlarmTime = Date()
    
    var alarm = Alarm()
    
    // 地図
    var mapView = MKMapView()
    // 測定結果を表示するラベル
    var swipedActionLabel = WUBodyLabel(fontSize: 20)
    //　スワイプボタン
    var swipeButton: SwipeButton!
    
    var myHomeLocation = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        configureUI()
        swipeButton.getGeocoderDelegate = self
        myHomeLocation = CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude)
//        moveTo(center: CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude), animated: false)
        moveTo(center: myHomeLocation, animated: false)
        print(myAddressLongitude)
        print(myAddressLatitude)

        
//        setAnnotation(location: CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude))
//        setAnnotation(location: myHomeLocation)
//        drawCircle(center: CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude), meter: 10, times: 10)
        drawCircle(center: myHomeLocation, meter: 10, times: 10)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSettingAlarmWithinTwoHours(settingTime: mySettingAlarmTime)
        self.view.layoutIfNeeded()
        moveTo(center: myHomeLocation, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // ここで2時間以内だった時の設定を入れる
    func checkSettingAlarmWithinTwoHours(settingTime: Date) {
        var differenceFromCurrenTime = 0
        differenceFromCurrenTime = alarm.calculateTimeInterval(userAwakeTime: settingTime)
        print("設定時刻との差分2:" ,differenceFromCurrenTime)
        
        
        //TODO: 暫定で2時間以上前に設定しています
        if differenceFromCurrenTime < 7200 {
            // ２時間以上前の時
            swipedActionLabel.text = "２時間以上前です"
            swipeButton.isHidden = true
        } else {
            // ２時間以内の時
            swipedActionLabel.text = "2時間以内です"
            swipeButton.isHidden = false
        }
        
//        if differenceFromCurrenTime > 7200 {
//            // ２時間以上前の時
//            swipedActionLabel.text = "２時間以上前です"
//            swipeButton.isHidden = true
//        } else {
//            // ２時間以内の時
//            swipedActionLabel.text = "2時間以内です"
//            swipeButton.isHidden = false
//        }
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
//        annotation.subtitle = location.distanceTextFromHome(to: CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude))
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
//        let rawDistance = location.distanceFromHome(to: CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude))
        let rawDistance = location.distanceFromHome(to: myHomeLocation)
        
        print("rawDistance: ", rawDistance)
        
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
            return "OK!、100m以上離れました！"
        }
    }
    
    
    
    
    
    func configureUI() {
        mapView.delegate = self
        locationManager.delegate = self
        // Mapの大きさを定義
        mapView.translatesAutoresizingMaskIntoConstraints = false
        swipedActionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        swipedActionLabel.text = "100m離れたところでスワイプ"
        swipedActionLabel.textAlignment = .center
        view.addSubview(swipedActionLabel)
        let padding:CGFloat = 40.0;
        setupSwipeButton()
        swipeButton.isHidden = true
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.size.width),
            
            swipedActionLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 40),
            swipedActionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            swipedActionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            swipedActionLabel.heightAnchor.constraint(equalToConstant: 40)
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
//            annotationView.image = UIImage(named: "jinrikisya_man")
            // figure.waveのサイズを大きくしたい
            annotationView.image = UIImage(systemName: "figure.wave")
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
//        setAnnotation(location: myHomeLocation)
        setAnnotation(location: CLLocationCoordinate2D(latitude: geoCoderLatitude, longitude: geoCoderLongitude))
        print("geoCoderLatitude:", geoCoderLatitude)
        print("geoCoderLongitude:", geoCoderLongitude)
    }
    
    
}

