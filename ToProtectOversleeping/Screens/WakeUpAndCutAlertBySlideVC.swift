//
//  WakeUpAndCutAlertBySlideVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit
import MapKit

class WakeUpAndCutAlertBySlideVC: UIViewController {
    
    
    private let imperialPalaceLocation = CLLocationCoordinate2D(latitude: 35.024101, longitude: 135.762018)
    
    
    // 地図
    var mapView = MKMapView()
    // 測定結果を表示するラベル
    var swipedActionLabel = UILabel()
    //　スワイプボタン
    var swipeButton: SwipeButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        moveTo(center: imperialPalaceLocation, animated: false)
        setAnnotation(location: imperialPalaceLocation)
        drawCircle(center: imperialPalaceLocation, meter: 10, times: 10)
        
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
        annotation.subtitle = location.distanceText(to: imperialPalaceLocation)
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
        let rawDistance = location.distance(to: imperialPalaceLocation)
        
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
        // Mapの大きさを定義
        mapView.translatesAutoresizingMaskIntoConstraints = false
        swipedActionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        swipedActionLabel.text = "100m離れたところでスワイプ"
        swipedActionLabel.textAlignment = .center
        view.addSubview(swipedActionLabel)
        let padding:CGFloat = 40.0;
        setupSwipeButton()
        
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
    
    
    func setupSwipeButton() {
        if swipeButton == nil {
            self.swipeButton = SwipeButton(frame: CGRect(x: 20, y: view.frame.height - 100, width: view.frame.size.width - 40, height: 50))
            swipeButton.isRightToLeft = false
            swipeButton.text = "右へスライドしてください"
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
            annotationView.image = UIImage(named: "jinrikisya_man")
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