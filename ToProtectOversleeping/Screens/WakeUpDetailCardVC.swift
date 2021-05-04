//
//  WakeUpDetailCardVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit

class WakeUpDetailCardVC: UIViewController {
    
    var wakeUpCardView = WakeUpCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    
    func configureCollectionView() {
        wakeUpCardView.frame = view.bounds
        view.addSubview(wakeUpCardView)
    }
}
