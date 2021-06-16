////
////  ResultWakeUpFloatingVC.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/06/14.
////
//
//import UIKit
//import FloatingPanel
//
//protocol GetArrayOFWakeUpSuccessPersonListDelegate {
//    func getArrayOfWakeUpSuccessPersonList() -> [String]
//}
////
//class ResultWakeUpFloatingVC: UIViewController {
//
//    var wakeUpSuccessPersonList = [String]()
//    var getArrayOFWakeUpSuccessPersonListDelegate: GetArrayOFWakeUpSuccessPersonListDelegate?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("宏輝_FloatingPanel: ", wakeUpSuccessPersonList)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        //グラデーションをつける
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.view.bounds
//        //グラデーションさせるカラーの設定
//        let color1 = UIColor.systemOrange.withAlphaComponent(0.0).cgColor
//        let color2 = UIColor.systemOrange.cgColor
//
//        gradientLayer.colors = [color1, color2]
//        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint.init(x: 0.0 , y: 0.07)
//        self.view.layer.insertSublayer(gradientLayer,at:0)
//
//
//        print("宏輝_FloatingPanel2: ",wakeUpSuccessPersonList)
////        print("宏輝_FloatingPanel2: ",         getArrayOFWakeUpSuccessPersonListDelegate?.getArrayOfWakeUpSuccessPersonList())
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("宏輝_FloatingPanel3: ",wakeUpSuccessPersonList)
////        print("宏輝_FloatingPanel3: ",         getArrayOFWakeUpSuccessPersonListDelegate?.getArrayOfWakeUpSuccessPersonList())
//    }
//}
//
//
//
//class CustomFloatingPanelLayout: FloatingPanelLayout {
//
//    let position: FloatingPanelPosition = .bottom
//        let initialState: FloatingPanelState = .tip
//        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
//            return [
//                .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
//                .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
//                .tip: FloatingPanelLayoutAnchor(absoluteInset: 90.0, edge: .bottom, referenceGuide: .safeArea),
//            ]
//        }
//}
//
