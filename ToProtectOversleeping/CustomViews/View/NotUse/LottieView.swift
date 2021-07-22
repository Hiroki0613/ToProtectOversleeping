////
////  LottieView.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/07/22.
////
//
//import UIKit
//import Lottie
//
//class LottieView: UIView {
//    
//    var lottieJonsString = ""
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    convenience init(lottieJsonString: String, loopMode: LottieLoopMode) {
//        self.init(frame: .zero)
//        
//        let animationView = AnimationView(name: lottieJsonString)
//                 animationView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
//                 animationView.center = self.center
//                 animationView.loopMode = loopMode
//                 animationView.contentMode = .scaleAspectFit
//                 animationView.animationSpeed = 1
//                 addSubview(animationView)
//                 animationView.play()
//    }
//}
