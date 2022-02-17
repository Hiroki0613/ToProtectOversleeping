//
//  NewRegistrationGpsVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/29.
//

import UIKit
import MapKit
import Firebase
import KeychainSwift

protocol AuthLoginDelegate {
    func authLogin(isLoggedIn: Bool)
}

// 新規登録時のユーザーネームを登録
class NewRegistrationGpsVC: BaseGpsVC {
    
    let loadDBModel = LoadDBModel()
    
    
    //keychainのデフォルトセッティング。見つけやすいように共通のprefixを実装。
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKeychain)
    
    let db = Firestore.firestore()
    
    // 画面遷移時にユーザ名がここに渡っている。
    var newUserName = ""
    var theGoalSetting = ""
    
    var authLoginDelegate: AuthLoginDelegate?
    
    // GPSの初期設定値が入っている。
    // Keychainでの設定値に問題があったらデフォルト値を採用
    var myAddressLatitude: Double = PrimaryPlace.primaryAddressLatitude
    var myAddressLongitude: Double = PrimaryPlace.primaryAddressLongitude
    
    // 地図
    var mapView = MKMapView()
    var homeLocationLabel = WUBodyLabel(fontSize: 20)
    var homeLocationFetchButton = WUButton(backgroundColor: .clear, title: "タップして取得")
    var myHomeLocation = CLLocationCoordinate2D()
    // アドレスを格納
    var addressString = ""
    
    //平日、休日を定義
    var dayOfTheWeekArray = ["a_weekDay", "b_weekEnd"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("宏輝_theGoal_setting: ", theGoalSetting)
        view.backgroundColor = PrimaryColor.background
        configureView()
        getMyAddressFromKeyChain()
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
    
    func getMyAddressFromKeyChain() {
        let myAddressLatitudeFromKeychainString: String = keychain.get(Keys.myAddressLatitude) ?? "\(PrimaryPlace.primaryAddressLatitude)"
        let myAddressLongitudeFromKeychainString: String = keychain.get(Keys.myAddressLongitude) ?? "\(PrimaryPlace.primaryAddressLongitude)"
        if let myAddressLatitude = Double(myAddressLatitudeFromKeychainString),
           let myAddressLongitude = Double(myAddressLongitudeFromKeychainString) {
            self.myAddressLatitude = myAddressLatitude
            self.myAddressLongitude = myAddressLongitude
        }
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
    
    
    // ランダムStringを作成
    func randomString(length: Int) -> String {
      let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    
    @objc func tapSetGpsButton() {
        let sendDBModel = SendDBModel()
        
        let generatedChatRoomRandomString = "WU\(self.randomString(length: 18))"
        
        sendDBModel.doneCreateUser = self
        
        // アプリのバージョン
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        getCurrentLocation()
        print("gps取得: ", geoCoderLongitude)
        print(geoCoderLongitude)
        
        print("GpsButtonが押されました")
        print(address)
        
        //Keychain
        let geoCoderLatitudeString: String = String(geoCoderLatitude)
        let geoCoderLongitudeString: String = String(geoCoderLongitude)
        
        keychain.set(geoCoderLatitudeString, forKey: Keys.myAddressLatitude)
        keychain.set(geoCoderLongitudeString, forKey: Keys.myAddressLongitude)
        keychain.set(address, forKey: Keys.myAddress)
        
        let geoCoderLocation = CLLocationCoordinate2D(latitude: geoCoderLatitude, longitude: geoCoderLongitude)
        moveTo(center: geoCoderLocation, animated: true)
        drawCircle(center: geoCoderLocation, meter: 10, times: 10)
        setAnnotation(location: geoCoderLocation)
        
        homeLocationLabel.text = "登録されました。 \n\n\(address)"
        
        // GPS情報、住所が取得出来なかった場合は反応なし
        if geoCoderLatitude == PrimaryPlace.primaryAddressLatitude,
           geoCoderLongitude == PrimaryPlace.primaryAddressLongitude,
           address == "" {
            return
        } else {
            
            // 無理矢理ログインしています
            Auth.auth().signInAnonymously { result, error in
                self.homeLocationFetchButton.isEnabled = false
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    //TODO: ここは1.0秒待たせる必要はないけど、あえて住所が登録されているのを見せてローディング画面を見せる。
                    UserDefaults.standard.set(self.newUserName,forKey: "userName")
                    UserDefaults.standard.set(self.newUserName,forKey: "teamChatName")
                
                    //ここでFirebaseFireStoreにUserModelとして登録する。
                    //create時点では、homeRoomIdとteamChatRoomIdは同じにしておく。
                    sendDBModel.createUser(
                        name: self.newUserName,
                        uid: Auth.auth().currentUser!.uid,
                        appVersion: version,
                        isBilling: false,
                        homeRoomId: generatedChatRoomRandomString,
                        teamChatRoomId: generatedChatRoomRandomString,
                        teamChatName: self.newUserName,
                        theGoalSetting: self.theGoalSetting)
                    UserDefaults.standard.set(false, forKey: "isFirstOpenApp")
                    UserDefaults.standard.set(true, forKey: UserDefaultsString.isFirstDownloadInstructions)
                    
                    //ここでデフォルトの部屋IDを用意する。
                    //"Home"のdocumentIDのために、ランダムStringを作成
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    
                    // 平日、休日分の２つを生成する。
                    // 平日
                    sendDBModel.createHomeRoom(
                        roomName: self.newUserName,
                        wakeUpTimeDate: Date(),
                        wakeUpTimeText: "\(formatter.string(from: Date()))",
                        isWakeUpBool: false,
                        dayOfTheWeek: self.dayOfTheWeekArray[0],
                        appVersion: version)
                    // 休日
                    sendDBModel.createHomeRoom(
                        roomName: self.newUserName,
                        wakeUpTimeDate: Date(),
                        wakeUpTimeText: "\(formatter.string(from: Date()))",
                        isWakeUpBool: false, dayOfTheWeek: self.dayOfTheWeekArray[1],
                        appVersion: version)
                    
                    // 自分のチャットルームを用意
                    sendDBModel.createChatRoom(roomName: self.newUserName, defaultWakeUpTimeDate: Date(), defaultWakeUpTimeText: "\(formatter.string(from: Date()))", chatRoomId: generatedChatRoomRandomString, appVersion: version)
                    
                    self.homeLocationFetchButton.isEnabled = true
                    
                    self.authLoginDelegate?.authLogin(isLoggedIn: true)
                }
            }
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
        navigationController?.popToRootViewController(animated: true)
    }
}
