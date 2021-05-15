////
////  JinrikishaGPS.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/05/04.
////
//
//import UIKit
//import MapKit
//
//// 参考URL
//// https://dev.classmethod.jp/articles/mkmapview-kyoto-imperial-palace/
//
//class JinrikishaGPS: UIViewController {
//
//    private let imperialPalaceLocation = CLLocationCoordinate2D(latitude: 35.024101, longitude: 135.762018)
//    private var polyline: MKPolyline?
//
//    var mapView: MKMapView {
//        return view as! MKMapView
//    }
//
//    override func loadView() {
//        view = MKMapView()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        mapView.delegate = self
//        moveTo(center: imperialPalaceLocation, animated: false)
//        setAnnotation(location: imperialPalaceLocation)
//        drawCircle(center: imperialPalaceLocation, meter: 250, times: 20)
//    }
//
//    // 地図を任意の場所へ移動させる
//    private func moveTo(
//        center location: CLLocationCoordinate2D,
//        animated: Bool,
//        span: CLLocationDegrees = 0.01) {
//
//        let coordinateSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
//        let coordinateRegion = MKCoordinateRegion(center: location, span: coordinateSpan)
//
//        mapView.setRegion(coordinateRegion, animated: animated)
//    }
//
//    // タップした場所の位置情報を取得する
//    private func addTapGestureRecognizer() {
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
//        mapView.addGestureRecognizer(gesture)
//    }
//
//    // タップした場所の位置情報が取れる
//    @objc private func didTap(gesture: UITapGestureRecognizer) {
//        guard gesture.state == .ended else { return }
//
//        let point = gesture.location(in: view)
//        let locationCoordinate = mapView.convert(point, toCoordinateFrom: mapView)
//
//        moveTo(center: locationCoordinate, animated: true)
//        setAnnotation(location: locationCoordinate)
//
//        print(imperialPalaceLocation.distanceText(to: locationCoordinate))
//    }
//
//    // アノテーションを設定
//    private func setAnnotation(location: CLLocationCoordinate2D) {
//        mapView.removeAnnotations(mapView.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = rank(location: location)
//        annotation.subtitle = location.distanceText(to: imperialPalaceLocation)
//        mapView.addAnnotation(annotation)
//    }
//
//    // 地図上にサークルを描く
//    private func drawCircle(
//        center location: CLLocationCoordinate2D,
//        meter: CLLocationDistance,
//        times: Int) {
//
//        mapView.addOverlays((1...times).map { i -> MKCircle in
//            let radius = meter * CLLocationDistance(i)
//            return MKCircle(center: location, radius: radius)
//        })
//    }
//
//    private func drawLine(
//        from fromLocation: CLLocationCoordinate2D,
//        to toLocation: CLLocationCoordinate2D) {
//
//        // 描画中の直線は削除する
//        if let drawPolyLine = polyline {
//            mapView.removeOverlay(drawPolyLine)
//        }
//
//        var coordinates = [fromLocation, toLocation]
//        polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
//
//        mapView.addOverlay(polyline!)
//    }
//
//    // 京都からの距離を測定して、コメントを分類
//    private func rank(location: CLLocationCoordinate2D) -> String {
//        let rawDistance = location.distance(to: imperialPalaceLocation)
//
//        print("rawDistance: ", rawDistance)
//        
//        switch rawDistance {
//        case 0..<(2 * 1000):
//            return "まぁ！由緒ある京都の方なんやねぇ"
//        case (2 * 1000)..<(5 * 1000):
//            return "ええとこに住んではりますねぇ"
//        case (5 * 1000)..<(25 * 1000):
//            return "わざわざ遠いとこから 疲れはったやろ"
//        case (25 * 1000)..<(150 * 1000):
//            return "えらい遠いとこから来はったんやねぇ"
//        case (150 * 1000)..<(1500 * 1000):
//            return "京都には観光客見に来はったんですか?"
//        default:
//            return "・・・"
//        }
//    }
//}
//
//extension JinrikishaGPS:MKMapViewDelegate {
//
//    // アニテーションビューについて、設定するdelegate
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "annotation"
//
//        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
//            annotationView.annotation = annotation
//            return annotationView
//        } else {
//            // アノテーションを画像にする
//            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView.image = UIImage(named: "jinrikisya_man")
//            annotationView.canShowCallout = true
//            return annotationView
//        }
//    }
//
//    // 円を描いた時に、どのような色、太さになるかを決める
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//        if overlay is MKCircle {
//            let circleRenderer = MKCircleRenderer(overlay: overlay)
//            circleRenderer.strokeColor = .brown
//            circleRenderer.lineWidth = 0.5
//            return circleRenderer
//        }
//
//        if overlay is MKPolyline {
//            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = .red
//            polylineRenderer.lineWidth = 2
//            return polylineRenderer
//        }
//        fatalError()
//    }
//
//    // アノテーションに吹き出し文字を入れる
//    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//        guard let annotation = views.first?.annotation else { return }
//        mapView.selectAnnotation(annotation, animated: true)
//    }
//
//}
//
//// 2点間の距離を測定
//extension CLLocationCoordinate2D {
//    func distance(
//        to targetLoacation: CLLocationCoordinate2D) -> CLLocationDistance {
//
//        let location1 = CLLocation(latitude: latitude, longitude: longitude)
//        let location2 = CLLocation(latitude: targetLoacation.latitude, longitude: targetLoacation.longitude)
//        return location1.distance(from: location2)
//    }
//
//    // 距離をStringで表示
//    func distanceText(to targetLocation: CLLocationCoordinate2D) -> String {
//        let rawDistance = distance(to: targetLocation)
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
//}
