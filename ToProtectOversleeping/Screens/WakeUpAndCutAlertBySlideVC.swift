//
//  WakeUpAndCutAlertBySlideVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit
import MapKit

class WakeUpAndCutAlertBySlideVC: UIViewController {
    
    // 地図
    var mapView = MKMapView()
    // 測定結果を表示するラベル
    var swipedActionLabel = UILabel()
    //　スワイプボタン
    var swipeButton: SwipeButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()

        

    }
    
    func configure() {
        // Mapの大きさを定義
        mapView = MKMapView(frame: CGRect(x: 20, y: 100, width: view.frame.size.width - 40, height: view.frame.size.width - 40))
//        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        setupSwipeButton()
            

    }
    
    func setupSwipeButton() {
        if swipeButton == nil {
            self.swipeButton = SwipeButton(frame: CGRect(x: 20, y: 700, width: view.frame.size.width - 40, height: 50))
            swipeButton.isRightToLeft = false
            swipeButton.text = "右へスライドしてください"
            swipeButton.swipedText = "GPS取得中"
            view.addSubview(swipeButton)
        }
    }
    


}
