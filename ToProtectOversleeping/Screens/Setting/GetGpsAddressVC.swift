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
        
        
        homeLocationLabel.text = "登録されました。\n\n\(address)"
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
        homeLocationLabel.numberOfLines = 0
        
        // Mapの大きさを定義
        mapView.translatesAutoresizingMaskIntoConstraints = false
        homeLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        homeLocationFetchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        view.addSubview(homeLocationLabel)
        view.addSubview(homeLocationFetchButton)
        
        let padding: CGFloat = 10.0;
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.size.width),
            
            homeLocationLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor,constant:  padding),
            homeLocationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            homeLocationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            homeLocationLabel.heightAnchor.constraint(equalToConstant: 80),
            
            homeLocationFetchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            homeLocationFetchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            homeLocationFetchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            homeLocationFetchButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
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
