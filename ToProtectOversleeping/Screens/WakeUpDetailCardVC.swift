//
//  WakeUpDetailCardVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit

class WakeUpDetailCardVC: BaseGpsVC {
    
    // 起きる時間のカード
    var wakeUpCardView = WakeUpCardView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        configureView()
        configureDecoration()
        wakeUpCardView.setGPSButton.addTarget(self, action: #selector(tapSetGPSButton), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // ここでGPSを取得
    @objc func tapSetGPSButton() {
        wakeUpCardView.wakeUpTimeTextField.resignFirstResponder()
        wakeUpCardView.chatTeamNameTextField.resignFirstResponder()
        getCurrentLocation()
        print(geoCoderLongitude)
        print(geoCoderLatitude)
        print("wakeUpCardView.datePicker.date:" ,wakeUpCardView.datePicker.date)
//        print(wakeUpCardView.prefectureAndCityNameLabel.text)
        wakeUpCardView.prefectureAndCityNameLabel.text = address
        
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = wakeUpCardView.datePicker.date
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    
    func configureView() {
        wakeUpCardView.frame = CGRect(x: 10, y: 50, width: view.frame.size.width - 20, height: 400)
        view.addSubview(wakeUpCardView)
    }
    
    // セルを装飾
    private func configureDecoration() {
        wakeUpCardView.layer.shadowColor = UIColor.systemGray.cgColor
        wakeUpCardView.layer.cornerRadius = 16
        wakeUpCardView.layer.shadowOpacity = 0.1
        wakeUpCardView.layer.shadowRadius = 10
        wakeUpCardView.layer.shadowOffset = .init(width: 0, height: 10)
        wakeUpCardView.layer.shouldRasterize = true
    }
}
