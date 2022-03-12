//
//  EditWakeUpAlarmTimeVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2022/01/03.
//

import UIKit

class EditWakeUpAlarmTimeVC: UIViewController {
    
    // チャットのdocumentID
    var chatRoomDocumentIDArray = [""]
    var userName = ""
    var teamChatRoomId = ""
    
    var editWakeUpAlarmTimeView = EditWakeUpAlarmTimeViewByWeekDayWeekEnd()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addBackground(name: "orange")
        self.view.backgroundColor = PrimaryColor.background
        print("宏輝_chatRoomDocumentIDArray", chatRoomDocumentIDArray)
        print("宏輝_userName", userName)
        print("宏輝_teamChatRoomId", teamChatRoomId)
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
        
        //TODO: 暫定で平日の時間を変更するようにしている。休日は、これから設定する。
        
        // 何も入っていなかったら、そのままリターン
        if editWakeUpAlarmTimeView.changeWakeUpTimeWeekDayTextField.text == ""
            &&
            editWakeUpAlarmTimeView.changeWakeUpTimeWeekEndTextField.text == ""
        {
            self.navigationController?.popViewController(animated: true)
            
        } else {
            
            if editWakeUpAlarmTimeView.changeWakeUpTimeWeekDayTextField.text != "" {
                //ここで、平日の時間を変更するfireStoreのコードを入れる
                let sendDBModel = SendDBModel()
                sendDBModel.changedChatRoomWakeUpAlarmTime(roomNameId: chatRoomDocumentIDArray[0], wakeUpTimeDate: editWakeUpAlarmTimeView.changeDatePickerWeekDay.date, wakeUpTimeText: editWakeUpAlarmTimeView.changeWakeUpTimeWeekDayText)
                //ここで時間が変更されたことをチャットで知らせる。
                let messageModel = MessageModel()
                
                messageModel.sendMessageToChatEditAlarmTime(documentID: teamChatRoomId, displayName: userName, dayOfTheWeek: "a_weekDay", wakeUpTimeText: editWakeUpAlarmTimeView.changeWakeUpTimeWeekDayText)
            }
            
            if editWakeUpAlarmTimeView.changeWakeUpTimeWeekEndTextField.text != "" {
                //ここで、休日の時間を変更するfireStoreのコードを入れる
                let sendDBModel = SendDBModel()
                sendDBModel.changedChatRoomWakeUpAlarmTime(roomNameId: chatRoomDocumentIDArray[1], wakeUpTimeDate: editWakeUpAlarmTimeView.changeDatePickerWeekEnd.date, wakeUpTimeText: editWakeUpAlarmTimeView.changeWakeUpTimeWeekEndText)
                //ここで時間が変更されたことをチャットで知らせる。
                let messageModel = MessageModel()
                
                messageModel.sendMessageToChatEditAlarmTime(documentID: teamChatRoomId, displayName: userName, dayOfTheWeek: "b_weekEnd", wakeUpTimeText: editWakeUpAlarmTimeView.changeWakeUpTimeWeekEndText)
            }
            
           
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
            editWakeUpAlarmTimeView.heightAnchor.constraint(equalToConstant: 500),
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
