//
//  NewRegistrationGpsVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/29.
//

import UIKit
import MapKit
import Firebase

// 新規登録時のユーザーネームを登録
class NewRegistrationGpsVC: BaseGpsVC {
    
    let db = Firestore.firestore()
    
    // 画面遷移時にユーザ名がここに渡っている。
    var newUserName = ""
    
    // GPSの初期設定値が入っている。
    var myAddressLatitude = UserDefaults.standard.double(forKey: "myAddressLatitude")
    var myAddressLongitude = UserDefaults.standard.double(forKey: "myAddressLongitude")
//    var myAddressLongLongtitude = UserDefaults.standard.double(forKey: "myAddressLongLongtitude")

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
        myHomeLocation = CLLocationCoordinate2D(latitude: myAddressLatitude, longitude: myAddressLongitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        moveTo(center: myHomeLocation, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        configureAddTarget()
    }
    
    private func configureAddTarget() {
        homeLocationFetchButton.addTarget(self, action: #selector(tapSetGpsButton), for: .touchUpInside)
    }
    
    private func moveTo(
        center location: CLLocationCoordinate2D,
        animated: Bool,
        span: CLLocationDegrees = 0.0025) {
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let coordinateRegion = MKCoordinateRegion(center: location, span: coordinateSpan)
        mapView.setRegion(coordinateRegion, animated: animated)
    }
    
    private func drawCircle(
        center location: CLLocationCoordinate2D,
        meter: CLLocationDistance,
        times: Int) {
        mapView.addOverlays((1...times).map{ i -> MKCircle in
            let radius = meter * CLLocationDistance(i)
            return MKCircle(center: location, radius: radius)
        })
    }
    
    private func setAnnotation(location: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotaiton = MKPointAnnotation()
        annotaiton.coordinate = location
        mapView.addAnnotation(annotaiton)
    }
    
    @objc func tapSetGpsButton() {
        let sendDBModel = SendDBModel()
        sendDBModel.doneCreateUser = self
        
        // アプリのバージョン
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        getCurrentLocation()
        print("gps取得: ", geoCoderLongitude)
        print(geoCoderLongitude)
        
        homeLocationLabel.text = "登録されました。 \n\n\(address)"
        print("GpsButtonが押されました")
        print(address)
        
        //TODO: keychainに変えること
        UserDefaults.standard.set(geoCoderLongitude, forKey: "myAddressLongitude")
        UserDefaults.standard.set(geoCoderLatitude, forKey: "myAddressLatitude")
//        UserDefaults.standard.set(geoCoderLongitude,forKey: "myAddressLongLongtitude")
        UserDefaults.standard.set(address, forKey: "myAddress")
        
        let geoCoderLocation = CLLocationCoordinate2D(latitude: geoCoderLatitude, longitude: geoCoderLongitude)
        moveTo(center: geoCoderLocation, animated: true)
        drawCircle(center: geoCoderLocation, meter: 10, times: 10)
        setAnnotation(location: geoCoderLocation)
        
        // GPS情報、住所が取得出来なかった場合は反応なし
        if geoCoderLatitude == 35.637375,
           geoCoderLongitude == 139.756308,
           address == "" {
            return
        } else {
            //TODO: １秒後に画面をpopUpして、カード画面に遷移させる
            //ここでFirebaseFireStoreにUserModelとして登録する。
            UserDefaults.standard.set(newUserName,forKey: "userName")
            sendDBModel.createUser(name: newUserName, uid: Auth.auth().currentUser!.uid, appVersion: version, isWakeUpBool: false)
            UserDefaults.standard.set(false, forKey: "isFirstOpenApp")
        }
    }
    
    private func convert(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
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


    private func configureView() {
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
        
        let padding: CGFloat = 10.0
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.size.width),
            
            homeLocationLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: padding),
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

extension NewRegistrationGpsVC: MKMapViewDelegate {
    // アノテーションビューについて、設定するdelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotation"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
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

extension NewRegistrationGpsVC: GetGeocoderDelegate {
    func getAddressFromCurrentPlace() {
        getCurrentLocation()
        
        print("geoCoderLatitude: ", geoCoderLatitude)
        print("geoCoderLongitude: ", geoCoderLongitude)
    }
}

extension NewRegistrationGpsVC: DoneCreateUser {
    func doneCreateUser() {
        // 新規登録が終わった後に行う処理
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
}
