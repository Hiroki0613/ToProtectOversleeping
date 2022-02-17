//
//  EditWakeUpAlarmTimeView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/11.
//

import UIKit

class NotUseEditWakeUpAlarmTimeView: UIView {
    // アラーム時間を一時的に格納する
    var changeWakeUpTimeText = ""
    var changeWakeUpTimeDate = Date()
    
    // チャットのdocumentID
    var chatRoomDocumentID = ""
    var userName = ""
    
    // 起きる時間
    var changeWakeUpTimeLabel = WUBodyLabel(fontSize: 20)
    let changeDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.preferredDatePickerStyle = .wheels
        dp.timeZone = NSTimeZone.local
        dp.locale = Locale.current
        dp.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        return dp
    }()
    var changeWakeUpTimeTextField = WUTextFields()
    
    
    // 戻るボタン
    let changeWakeUpGoBuckButton = WUButton(backgroundColor: .clear, title: "戻る")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configure()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dateChange() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        changeWakeUpTimeTextField.text = "\(formatter.string(from: changeDatePicker.date))"
//        guard let changeWakeUpTimeTextFieldText = changeWakeUpTimeTextField.text else { return }
//        changeWakeUpTimeText = changeWakeUpTimeTextFieldText
        changeWakeUpTimeText = "\(formatter.string(from: changeDatePicker.date))"
        changeWakeUpTimeDate = changeDatePicker.date
        print("wakeUpTimeText: ", changeWakeUpTimeText)
        changeWakeUpTimeLabel.text = "時間が変更されました"
        print("宏輝_アラーム: edit change changeWakeUpTimeText:  ", changeWakeUpTimeText)
        print("宏輝_アラーム: edit change changeWakeUpTimeDate:  ", changeWakeUpTimeDate)
    }
    
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        changeWakeUpTimeLabel.text = "起きる時間"
        changeWakeUpTimeTextField.inputView = changeDatePicker
        print("datePicker: ", changeDatePicker)
        changeWakeUpTimeTextField.delegate = self
    }
    
    // UIDatePickerのDoneを押したら発火
    @objc func done() {
        changeWakeUpTimeTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
//        guard let changeWakeUpTimeTextFieldText = changeWakeUpTimeTextField.text else { return }
        changeWakeUpTimeTextField.text = "\(formatter.string(from: changeDatePicker.date))"
        changeWakeUpTimeText = "\(formatter.string(from: changeDatePicker.date))"
        changeWakeUpTimeDate = changeDatePicker.date
        print("宏輝_アラーム: edit done wakeUpTimeText: ", changeWakeUpTimeText)
        print("宏輝_アラーム: edit done wakeUpTimeDate: ", changeWakeUpTimeDate)
        changeWakeUpTimeLabel.text = "時間が変更されました"
//        //ここで、時間を変更するfireStoreのコードを入れる
//        let sendDBModel = SendDBModel()
//        sendDBModel.changedChatRoomWakeUpAlarmTime(roomNameId: chatRoomDocumentID, wakeUpTimeDate: changeDatePicker.date, wakeUpTimeText: changeWakeUpTimeText)
//        //ここで時間が変更されたことをチャットで知らせる。
//        let messageModel = MessageModel()
//        messageModel.sendMessageToChatEditAlarmTime(documentID: chatRoomDocumentID, displayName: userName, wakeUpTimeText: changeWakeUpTimeText)
    }
    
    
    private func configure() {
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        changeWakeUpTimeTextField.inputAccessoryView = toolbar
        
        changeWakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        changeWakeUpTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        changeWakeUpGoBuckButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // 起きる時間をStack
        addSubview(changeWakeUpTimeLabel)
        addSubview(changeWakeUpTimeTextField)
        addSubview(changeWakeUpGoBuckButton)
        
        NSLayoutConstraint.activate([
            //起きる時間
            changeWakeUpTimeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            changeWakeUpTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpTimeLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            changeWakeUpTimeTextField.topAnchor.constraint(equalTo: changeWakeUpTimeLabel.bottomAnchor, constant: spacePadding),
            changeWakeUpTimeTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpTimeTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpTimeTextField.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            // 戻るボタン
            changeWakeUpGoBuckButton.topAnchor.constraint(equalTo: changeWakeUpTimeTextField.bottomAnchor, constant: spacePadding),
            changeWakeUpGoBuckButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpGoBuckButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpGoBuckButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
}

extension NotUseEditWakeUpAlarmTimeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeWakeUpTimeTextField.resignFirstResponder()
    }
}
