//
//  WakeUpCommunicateChatVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit

class WakeUpCommunicateChatVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // ここの背景にアプリのロゴを入れる？
        view.backgroundColor = .systemOrange

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }


}
