//
//  WakeUpDetailCardVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit

class WakeUpDetailCardVC: UIViewController {
    
    // 起きる時間のカード
    var wakeUpCardView = WakeUpCardView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        configureView()
    }
    
    
    func configureView() {
        wakeUpCardView.frame = CGRect(x: 10, y: 50, width: view.frame.size.width - 20, height: 400)
        view.addSubview(wakeUpCardView)
    }
    
    
    
 
    
//    // セルを装飾
//    private func configureDecoration() {
//        wakeUpCardView.backgroundColor = .systemGray
//        wakeUpCardView.layer.cornerRadius = 16
//        wakeUpCardView.layer.shadowOpacity = 0.1
//        wakeUpCardView.layer.shadowRadius = 10
//        wakeUpCardView.layer.shadowOffset = .init(width: 0, height: 10)
//        wakeUpCardView.layer.shouldRasterize = true
//    }
}
