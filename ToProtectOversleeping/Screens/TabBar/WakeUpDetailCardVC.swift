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
        configureAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureAddTarget() {
        wakeUpCardView.wakeUpSetAlarmSwitch.addTarget(self, action: #selector(setAlarmSwitch(sender:)), for: .valueChanged)
        wakeUpCardView.chatTeamRegistrationButton.addTarget(self, action: #selector(registerTeamMate), for: .touchUpInside)
        wakeUpCardView.setChatButton.addTarget(self, action: #selector(tapChatButton), for: .touchUpInside)
    }
    
    
    // ここで目覚ましをセット
    @objc func setAlarmSwitch(sender: UISwitch) {
        let onCheck: Bool = sender.isOn
            // UISwitch値を確認
            if onCheck {
                // viewのalphaを1.0にする。
                // 目覚ましをONにする
                print("スイッチの状態はオンです。値: \(onCheck)")
            } else {
                // viewのalphaを0.8にする。
                // 目覚ましをOFFにする
                print("スイッチの状態はオフです。値: \(onCheck)")
            }
    }
    
    
    // ここで登録を確認
    @objc func registerTeamMate() {
        wakeUpCardView.wakeUpTimeTextField.resignFirstResponder()
        wakeUpCardView.chatTeamNameTextField.resignFirstResponder()
        print("登録されました")
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = wakeUpCardView.datePicker.date
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    
    // チャットビューへ画面遷移
    @objc func tapChatButton() {
        wakeUpCardView.wakeUpTimeTextField.resignFirstResponder()
        wakeUpCardView.chatTeamNameTextField.resignFirstResponder()
        getCurrentLocation()
        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
//        print(geoCoderLongitude)
//        print(geoCoderLatitude)
//        print("wakeUpCardView.datePicker.date:" ,wakeUpCardView.datePicker.date)
//        print(wakeUpCardView.prefectureAndCityNameLabel.text)
//        wakeUpCardView.prefectureAndCityNameLabel.text = address
        
//        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
//        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
//        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
//        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = wakeUpCardView.datePicker.date
//        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    
    func configureView() {
        wakeUpCardView.frame = CGRect(x: 10, y: 50, width: view.frame.size.width - 20, height: 280)
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
