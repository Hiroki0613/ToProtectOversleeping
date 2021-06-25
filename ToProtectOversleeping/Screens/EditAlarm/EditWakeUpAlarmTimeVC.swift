//
//  EditWakeUpAlarmTimeVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/11.
//

import UIKit

class EditWakeUpAlarmTimeVC: UIViewController {
    
    // チャットのdocumentID
    var chatRoomDocumentID = ""
    var userName = ""

    var editWakeUpAlarmTimeView = EditWakeUpAlarmTimeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configureAddTarget() {
        editWakeUpAlarmTimeView.changeWakeUpGoBuckButton.addTarget(self, action: #selector(tapToDismiss), for: .touchUpInside)
    }
    
    @objc func tapToDismiss() {
        
        // 何も入っていなかったら、そのままリターン
        if editWakeUpAlarmTimeView.changeWakeUpTimeTextField.text == "" {
            self.navigationController?.popViewController(animated: true)
        } else {
            //ここで、時間を変更するfireStoreのコードを入れる
            let sendDBModel = SendDBModel()
            sendDBModel.changedChatRoomWakeUpAlarmTime(roomNameId: chatRoomDocumentID, wakeUpTimeDate: editWakeUpAlarmTimeView.changeDatePicker.date, wakeUpTimeText: editWakeUpAlarmTimeView.changeWakeUpTimeText)
            //ここで時間が変更されたことをチャットで知らせる。
            let messageModel = MessageModel()
            messageModel.sendMessageToChatEditAlarmTime(documentID: chatRoomDocumentID, displayName: userName, wakeUpTimeText: editWakeUpAlarmTimeView.changeWakeUpTimeText)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func configureView() {
        configureBlurView()
        configureCardView()
    }
    
    func configureCardView() {
        editWakeUpAlarmTimeView.translatesAutoresizingMaskIntoConstraints = false
        editWakeUpAlarmTimeView.layer.cornerRadius = 16
        view.addSubview(editWakeUpAlarmTimeView)
        
        NSLayoutConstraint.activate([
            editWakeUpAlarmTimeView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            editWakeUpAlarmTimeView.heightAnchor.constraint(equalToConstant: 300),
            editWakeUpAlarmTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            editWakeUpAlarmTimeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
}
