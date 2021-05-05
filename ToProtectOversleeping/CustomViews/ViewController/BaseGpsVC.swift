//
//  BaseGpsVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/05.
//

import UIKit
import MapKit
import CoreLocation

// 参考URL
// https://qiita.com/vyeah321/items/c6498ff6801da783cc2f


class BaseGpsVC: UIViewController {
    
    // 位置情報を取得
    var locationManager = CLLocationManager()
    // 住所
    var address = ""
    // 住所や地名から緯度経度といった地理座標を付与する
    let geocoder = CLGeocoder()
    
    // 緯度
    var geoCoderLatitude = 0.0
    // 経度
    var longitude = 0.0
    
    // 国
    var countryLabel = UILabel()
    // 郵便番号
    var postalCodeLabel = UILabel()
    // 都道府県
    var administrativeAreaLabel = UILabel()
    // 郡
    var subAdministrativeAreaLabel = UILabel()
    // 市区町村
    var localityLabel = UILabel()
    // 丁番なしの地名
    var subLocalityLabel = UILabel()
    // 地名
    var thoroughfareLabel = UILabel()
    // 番地
    var subThoroughfareLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // 10m単位での精度に設定
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    
    func getCurrentLocation() {
        // 位置情報の更新
        locationManager.startUpdatingLocation()
    }
}


extension BaseGpsVC: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            // 許可をリクエスト
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .restricted:
            print("Restricted")
        case .denied:
            print("denied")
        default:
            print("not allowed")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // 緯度・経度
            self.geoCoderLatitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            
            // 逆ジオコーディング
            self.geocoder.reverseGeocodeLocation(location) { placemark, error in
                if let placemark = placemark?.first {
                    // 位置情報
                    self.countryLabel.text = placemark.country
                    self.postalCodeLabel.text = placemark.postalCode
                    // 都道府県
                    self.administrativeAreaLabel.text = placemark.administrativeArea
                    // 郡
                    self.subAdministrativeAreaLabel.text = placemark.subAdministrativeArea
                    // 市区町村
                    self.localityLabel.text = placemark.locality
                    // 超バンなしの地名
                    self.subLocalityLabel.text = placemark.subLocality
                    self.thoroughfareLabel.text = placemark.thoroughfare
                    self.subThoroughfareLabel.text = placemark.subThoroughfare
                    
                    //住所：都道府県＋(郡)＋市区町村＋丁番なしの地名
                    let administrativeArea = placemark.administrativeArea == nil ? "" : placemark.administrativeArea!
                    let subAdministrativeArea = placemark.subAdministrativeArea == nil ? "" : placemark.subAdministrativeArea!
                    let locality = placemark.locality == nil ? "" : placemark.locality!
                    let subLocality = placemark.subLocality == nil ? "" : placemark.subLocality!
//                    let thoroughfare = placemark.thoroughfare == nil ? "" : placemark.thoroughfare!
//                    let placeName = !thoroughfare.contains( subLocality ) ? subLocality : thoroughfare
                    self.address = administrativeArea + subAdministrativeArea + locality + subLocality
                }
            }
        }
    }
    
}
