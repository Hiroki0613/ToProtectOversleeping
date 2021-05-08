//
//  WakeUpSettingVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit


// 暫定で住所を取得させる場所を用意しておく。
class WakeUpSettingVC: BaseGpsVC {
    
    // 起きる時間のカード
    var wakeUpSettingView = WakeUpSettingView()

    
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
    }
    
    func configureAddTarget() {
//        wakeUpCardView.wakeUpSetAlarmSwitch.addTarget(self, action: #selector(setAlarmSwitch(sender:)), for: .valueChanged)
//        wakeUpCardView.chatTeamRegistrationButton.addTarget(self, action: #selector(registerTeamMate), for: .touchUpInside)
        wakeUpSettingView.setGPSButton.addTarget(self, action: #selector(tapSetGPSButton), for: .touchUpInside)
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
        print("登録されました")
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
//        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = wakeUpCardView.datePicker.date
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    
    // ここでGPSを取得
    @objc func tapSetGPSButton() {
//        wakeUpCardView.wakeUpTimeTextField.resignFirstResponder()
//        wakeUpCardView.chatTeamNameTextField.resignFirstResponder()
        getCurrentLocation()
        print(geoCoderLongitude)
        print(geoCoderLatitude)
//        print("wakeUpCardView.datePicker.date:" ,wakeUpCardView.datePicker.date)
//        print(wakeUpCardView.prefectureAndCityNameLabel.text)
        wakeUpSettingView.prefectureAndCityNameLabel.text = address
        
        // 情報は一時的にUserDefaultに保管する。
        
        
//        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
//        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
//        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
//        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = wakeUpCardView.datePicker.date
//        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    
    func configureView() {
        wakeUpSettingView.frame = CGRect(x: 10, y: 50, width: view.frame.size.width - 20, height: 200)
        view.addSubview(wakeUpSettingView)
    }
    
    // セルを装飾
    private func configureDecoration() {
        wakeUpSettingView.layer.shadowColor = UIColor.systemGray.cgColor
        wakeUpSettingView.layer.cornerRadius = 16
        wakeUpSettingView.layer.shadowOpacity = 0.1
        wakeUpSettingView.layer.shadowRadius = 10
        wakeUpSettingView.layer.shadowOffset = .init(width: 0, height: 10)
        wakeUpSettingView.layer.shouldRasterize = true
    }
}

