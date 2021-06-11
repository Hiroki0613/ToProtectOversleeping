//
//  EditWakeUpAlarmTimeVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/11.
//

import UIKit

class EditWakeUpAlarmTimeVC: UIViewController {
    
    var chatRoomDocumentID = ""
    var editWakeUpAlarmTimeView = EditWakeUpAlarmTimeView()
    
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
        editWakeUpAlarmTimeView.changeWakeUpGoBuckButton.addTarget(self, action: #selector(tapToDismiss), for: .touchUpInside)
    }
    
    @objc func tapToDismiss() {
        //ここで、時間を変更するfireStoreのコードを入れる
        let sendDBModel = SendDBModel()
        sendDBModel.changedChatRoomWakeUpAlarmTime(roomNameId: chatRoomDocumentID, wakeUpTimeDate: editWakeUpAlarmTimeView.changeDatePicker.date, wakeUpTimeText: editWakeUpAlarmTimeView.changeWakeUpTimeText)
        
        
//        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = setAlarmTimeAndNewRegistrationView.datePicker.date
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func configureView() {
        
    }
    
    func configureCardView() {
        editWakeUpAlarmTimeView.frame = CGRect(x: 10, y: view.frame.size.height / 2 - 60, width: view.frame.size.width - 20, height: 300)
        view.addSubview(editWakeUpAlarmTimeView)
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
    
    func configureDecoration() {
        editWakeUpAlarmTimeView.layer.shadowColor = UIColor.systemGray.cgColor
        editWakeUpAlarmTimeView.layer.cornerRadius = 16
        editWakeUpAlarmTimeView.layer.shadowOpacity = 0.1
        editWakeUpAlarmTimeView.layer.shadowRadius = 10
        editWakeUpAlarmTimeView.layer.shadowOffset = .init(width: 0, height: 10)
        editWakeUpAlarmTimeView.layer.shouldRasterize = true
    }
}
