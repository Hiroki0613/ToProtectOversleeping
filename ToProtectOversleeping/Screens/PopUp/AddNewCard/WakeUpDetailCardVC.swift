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
        wakeUpCardView.wakeUpDismissButton.addTarget(self, action: #selector(tapToDismiss), for: .touchUpInside)
        if wakeUpCardView.isChatTeamRegistered {
            wakeUpCardView.chatTeamInvitationButton.addTarget(self, action: #selector(invitedFromTeam), for: .touchUpInside)
        } else {
            wakeUpCardView.chatTeamNewRegisterButton.addTarget(self, action: #selector(registerNewTeam), for: .touchUpInside)
            wakeUpCardView.chatTeamNewInvitedButton.addTarget(self, action: #selector(invitedToTeam), for: .touchUpInside)
        }

//        wakeUpCardView.setChatButton.addTarget(self, action: #selector(tapChatButton), for: .touchUpInside)
    }
    
    
    // ここで目覚ましをセット
    @objc func tapToDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // 新規登録
    @objc func registerNewTeam() {
        print("新規登録しました")
    }
    
    // 招待してもらう
    @objc func invitedToTeam() {
        print("招待してもらいました")
    }
    
    
    // チームへ招待する
    @objc func invitedFromTeam() {
        wakeUpCardView.wakeUpTimeTextField.resignFirstResponder()
        wakeUpCardView.chatTeamNameTextField.resignFirstResponder()
        print("招待しました")
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = wakeUpCardView.datePicker.date
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    
//    // チャットビューへ画面遷移
//    @objc func tapChatButton() {
//        wakeUpCardView.wakeUpTimeTextField.resignFirstResponder()
//        wakeUpCardView.chatTeamNameTextField.resignFirstResponder()
//        getCurrentLocation()
//        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
//        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
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
//    }
    
    
    func configureView() {
        configureBlurView()
        configureCardView()
    }
    
    func configureCardView(){
        wakeUpCardView.frame = CGRect(x: 10, y: view.frame.size.height / 2 - 60, width: view.frame.size.width - 20, height: 200)
        view.addSubview(wakeUpCardView)
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
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
