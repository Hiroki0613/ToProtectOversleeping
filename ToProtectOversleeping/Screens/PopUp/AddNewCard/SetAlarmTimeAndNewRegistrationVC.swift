//
//  SetAlarmTimeAndNewRegistrationVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit

class SetAlarmTimeAndNewRegistrationVC: UIViewController {
    
    // 起きる時間のカード
    var setAlarmTimeAndNewRegistrationView = SetAlarmTimeAndNewRegistrationView()
    
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
        setAlarmTimeAndNewRegistrationView.wakeUpGoBuckButton.addTarget(self, action: #selector(tapToDismiss), for: .touchUpInside)
        //        if setAlarmTimeAndNewRegistrationView.isChatTeamRegistered {
        //            setAlarmTimeAndNewRegistrationView.chatTeamInvitationButton.addTarget(self, action: #selector(invitedFromTeam), for: .touchUpInside)
        //        } else {
        setAlarmTimeAndNewRegistrationView.chatTeamNewRegisterButton.addTarget(self, action: #selector(registerNewTeam), for: .touchUpInside)
        setAlarmTimeAndNewRegistrationView.chatTeamNewInvitedButton.addTarget(self, action: #selector(invitedToTeam), for: .touchUpInside)
        //        }
        
        //        wakeUpCardView.setChatButton.addTarget(self, action: #selector(tapChatButton), for: .touchUpInside)
    }
    
    
    // ここで目覚ましをセット
    @objc func tapToDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // 新規登録
    @objc func registerNewTeam() {
        print("新規登録します")
        let setNewTeamMateNameVC = SetNewTeamMateNameVC()
        
        // 新規登録時にアラームも同時タイミングでセットしたいので、値を渡して画面遷移を行う
        setNewTeamMateNameVC.wakeUpTimeText = setAlarmTimeAndNewRegistrationView.wakeUpTimeText
        setNewTeamMateNameVC.wakeUpTimeDate = setAlarmTimeAndNewRegistrationView.wakeUpTimeDate
        print("setNewTeamMateNameVC.wakeUpTimeText: ",setNewTeamMateNameVC.wakeUpTimeText)
        print("setNewTeamMateNameVC.wakeUpTimeDate: ",setNewTeamMateNameVC.wakeUpTimeDate)
        
        if setNewTeamMateNameVC.wakeUpTimeText == "" {
            return
        } else {
            setNewTeamMateNameVC.modalPresentationStyle = .overFullScreen
            setNewTeamMateNameVC.modalTransitionStyle = .crossDissolve
            self.present(setNewTeamMateNameVC, animated: true, completion: nil)
        }
    }
    
    // 招待してもらう
    @objc func invitedToTeam() {
        print("招待してもらいました")
        let setInvitedTeamMateVC = SetInvitedTeamMateVC()
        // 招待時にアラームも同時タイミングでセットしたいので、値を渡して画面遷移を行う
        setInvitedTeamMateVC.wakeUpTimeText = setAlarmTimeAndNewRegistrationView.wakeUpTimeText
        setInvitedTeamMateVC.wakeUpTimeDate = setAlarmTimeAndNewRegistrationView.wakeUpTimeDate
        print("setInvitedTeamMateVC.wakeUpTimeText: ",setInvitedTeamMateVC.wakeUpTimeText)
        print("setInvitedTeamMateVC.wakeUpTimeDate: ", setInvitedTeamMateVC.wakeUpTimeDate)
        if setInvitedTeamMateVC.wakeUpTimeText == "" {
            return
        } else {
            setInvitedTeamMateVC.modalPresentationStyle = .overFullScreen
            setInvitedTeamMateVC.modalTransitionStyle = .crossDissolve
            self.present(setInvitedTeamMateVC, animated: true, completion: nil)
        }
        
    }
    
    
    // チームへ招待する
    @objc func invitedFromTeam() {
        //        setAlarmTimeAndNewRegistrationView.wakeUpTimeTextField.resignFirstResponder()
        //        setAlarmTimeAndNewRegistrationView.chatTeamNameTextField.resignFirstResponder()
        print("招待しました")
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        //        wakeUpAndCutAlertBySlideVC.myAddressLatitude = geoCoderLatitude
        //        wakeUpAndCutAlertBySlideVC.myAddressLongitude = geoCoderLongitude
        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = setAlarmTimeAndNewRegistrationView.datePicker.date
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
        setAlarmTimeAndNewRegistrationView.frame = CGRect(x: 10, y: view.frame.size.height / 2 - 60, width: view.frame.size.width - 20, height: 300)
        view.addSubview(setAlarmTimeAndNewRegistrationView)
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
    
    // セルを装飾
    private func configureDecoration() {
        setAlarmTimeAndNewRegistrationView.layer.shadowColor = UIColor.systemGray.cgColor
        setAlarmTimeAndNewRegistrationView.layer.cornerRadius = 16
        setAlarmTimeAndNewRegistrationView.layer.shadowOpacity = 0.1
        setAlarmTimeAndNewRegistrationView.layer.shadowRadius = 10
        setAlarmTimeAndNewRegistrationView.layer.shadowOffset = .init(width: 0, height: 10)
        setAlarmTimeAndNewRegistrationView.layer.shouldRasterize = true
    }
}

extension SetAlarmTimeAndNewRegistrationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
}
