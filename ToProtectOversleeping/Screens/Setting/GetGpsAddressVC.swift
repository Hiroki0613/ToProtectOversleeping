//
//  WakeUpSettingVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit
import MapKit


// 暫定で住所を取得させる場所を用意しておく。
class GetGpsAddressVC: BaseGpsVC {
    
    // 起きる時間のカード
    //    var getGpsAddressView = GetGpsAddressView()
    
    // 暫定で家の近くに設定している
    var myAddressLatitude = 25.7140224101
    var myAddressLongitude = 139.65363018
    var mySettingAlarmTime = Date()
    
    var alarm = Alarm()
    
    // 地図
    var mapView = MKMapView()
    var homeLocationLabel = WUBodyLabel(fontSize: 20)
    var homeLocationFetchButton = WUButton(backgroundColor: .systemBlue, title: "タップして取得")
    
    var myHomeLocation = CLLocationCoordinate2D()
    
    // アドレスを格納
    var addressString = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        configureView()
        //        configureDecoration()
        //        configureAddTarget()
        // ここにdefaultで設定した住まいを入れる渡す。
        myHomeLocation = CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude)
        moveTo(center: myHomeLocation, animated: false)
        drawCircle(center: myHomeLocation, meter: 10, times: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        // ここにUserDefaultsで設定した住まいを入れる。nilの場合(住所未設定の場合は、defaultsの場所にしておく)
        moveTo(center: myHomeLocation, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        configureAddTarget()
    }
    
    func configureAddTarget() {
        homeLocationFetchButton.addTarget(self, action: #selector(tapSetGPSButton), for: .touchUpInside)
    }
    
    
    // ここで目覚ましをセット
    @objc func setAlarmSwitch(sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        // UISwitch値を確認
        if onCheck {
            // viewのalphaを1.0にする。
            // 目覚ましをONにする
            print("スイッチの状態はオンです。値: \(onCheck)")
        } else {
            // viewのalphaを0.8にする。
            // 目覚ましをOFFにする
            print("スイッチの状態はオフです。値: \(onCheck)")
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
    
    
    // ここで登録を確認
    @objc func registerTeamMate() {
        print("登録されました")
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    private func setAnnotation(location: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    
    // ここでGPSを取得
    @objc func tapSetGPSButton() {
        getCurrentLocation()
        print(geoCoderLongitude)
        print(geoCoderLatitude)
        
        
        homeLocationLabel.text = address
        print("GpsButtonが押されました")
        print(address)
        let geoCoderLocation = CLLocationCoordinate2D(latitude: geoCoderLatitude, longitude: geoCoderLongitude)
        moveTo(center: geoCoderLocation, animated: true)
        drawCircle(center: geoCoderLocation, meter: 10, times: 10)
        setAnnotation(location: geoCoderLocation)
        //        getGpsAddressView.prefectureAndCityNameLabel.text = address
        
        // 情報は一時的にUserDefaultに保管する。
        
        
        //        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        //        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
        //        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
        ////        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = getGpsAddressView.datePicker.date
        //        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    // 位置から住所を取得
    func convert(latitude:CLLocationDegrees, longitude: CLLocationDegrees) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemark, error in
            
            if placemark != nil {
                if let pm = placemark?.first {
                    
                    if pm.administrativeArea != nil || pm.locality != nil {
                        
                        self.addressString = pm.name! + pm.administrativeArea! + pm.locality!
                    } else {
                        self.addressString = pm.name!
                    }
                    
                    self.homeLocationLabel.text = self.addressString
                }
            }
        }
    }
    
    
    func configureView() {
        mapView.delegate = self
        locationManager.delegate = self
        homeLocationLabel.text = "ここに住所が表示されます"
        homeLocationLabel.textAlignment = .center
        
        // Mapの大きさを定義
        mapView.translatesAutoresizingMaskIntoConstraints = false
        homeLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        homeLocationFetchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        view.addSubview(homeLocationLabel)
        view.addSubview(homeLocationFetchButton)
        
        let padding: CGFloat = 40.0;
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.size.width),
            
            homeLocationLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor,constant:  padding),
            homeLocationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            homeLocationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            homeLocationLabel.heightAnchor.constraint(equalToConstant: padding),
            
            homeLocationFetchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            homeLocationFetchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            homeLocationFetchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            homeLocationFetchButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        //        getGpsAddressView.frame = CGRect(x: 10, y: 50, width: view.frame.size.width - 20, height: 200)
        //        view.addSubview(getGpsAddressView)
    }
    
    // セルを装飾
    //    private func configureDecoration() {
    //        getGpsAddressView.layer.shadowColor = UIColor.systemGray.cgColor
    //        getGpsAddressView.layer.cornerRadius = 16
    //        getGpsAddressView.layer.shadowOpacity = 0.1
    //        getGpsAddressView.layer.shadowRadius = 10
    //        getGpsAddressView.layer.shadowOffset = .init(width: 0, height: 10)
    //        getGpsAddressView.layer.shouldRasterize = true
    //    }
}


extension GetGpsAddressVC: MKMapViewDelegate {
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
            annotationView.image = UIImage(systemName: "house")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))
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
    //    func distanceFromHome(
    //        to targetLoacation: CLLocationCoordinate2D) -> CLLocationDistance {
    //
    //        let location1 = CLLocation(latitude: latitude, longitude: longitude)
    //        let location2 = CLLocation(latitude: targetLoacation.latitude, longitude: targetLoacation.longitude)
    //        return location1.distance(from: location2)
    //    }
    
    // 距離をStringで表示
    //    func distanceTextFromHome(to targetLocation: CLLocationCoordinate2D) -> String {
    //
    //        let rawDistance = distanceFromHome(to: targetLocation)
    //        print("distanceTextFromHome. rawDistance", rawDistance)
    //
    //        // 1km未満は四捨五入で10m単位
    //        if rawDistance < 1000 {
    //            let roundedDistance = (rawDistance / 10).rounded() * 10
    //            return "\(Int(roundedDistance))m"
    //        }
    //        // 1km以上は四捨五入で0.1km単位
    //        let roundedDistance = (rawDistance / 100).rounded() * 100
    //        return "\(roundedDistance / 1000)km"
    //    }
}

extension GetGpsAddressVC: GetGeocoderDelegate {
    func getAddressFromCurrentPlace() {
        getCurrentLocation()
        //        swipedActionLabel.text = "取得完了しました"
        //        setAnnotation(location: myHomeLocation)
        //        setAnnotation(location: CLLocationCoordinate2D(latitude: geoCoderLatitude, longitude: geoCoderLongitude))
        print("geoCoderLatitude:", geoCoderLatitude)
        print("geoCoderLongitude:", geoCoderLongitude)
    }
    
    
}
