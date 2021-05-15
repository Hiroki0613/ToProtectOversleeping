//
//  WakeUpSettingVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit


// 暫定で住所を取得させる場所を用意しておく。
class GetGpsAddressVC: BaseGpsVC {
    
    // 起きる時間のカード
    var getGpsAddressView = GetGpsAddressView()

    
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
        getGpsAddressView.setGPSButton.addTarget(self, action: #selector(tapSetGPSButton), for: .touchUpInside)
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
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    
    // ここでGPSを取得
    @objc func tapSetGPSButton() {
        getCurrentLocation()
        print(geoCoderLongitude)
        print(geoCoderLatitude)
        getGpsAddressView.prefectureAndCityNameLabel.text = address
        
        // 情報は一時的にUserDefaultに保管する。
        
        
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
//        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = getGpsAddressView.datePicker.date
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    
    func configureView() {
        getGpsAddressView.frame = CGRect(x: 10, y: 50, width: view.frame.size.width - 20, height: 200)
        view.addSubview(getGpsAddressView)
    }
    
    // セルを装飾
    private func configureDecoration() {
        getGpsAddressView.layer.shadowColor = UIColor.systemGray.cgColor
        getGpsAddressView.layer.cornerRadius = 16
        getGpsAddressView.layer.shadowOpacity = 0.1
        getGpsAddressView.layer.shadowRadius = 10
        getGpsAddressView.layer.shadowOffset = .init(width: 0, height: 10)
        getGpsAddressView.layer.shouldRasterize = true
    }
}

