//
//  EditWakeUpAlarmTimeView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/11.
//

import UIKit

class EditWakeUpAlarmTimeView: UIView {
    // アラーム時間を一時的に格納する
    var changeWakeUpTimeText = ""
    var changeWakeUpTimeDate = Date()
    
    // チャットのdocumentID
    var chatRoomDocumentID = ""
    
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
    var changeWakeUpTimeStackView = UIStackView(frame: .zero)
    
    
    // 戻るボタン
    let changeWakeUpGoBuckButton = WUButton(backgroundColor: .systemOrange, title: "戻る")
    
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
        guard let changeWakeUpTimeTextFieldText = changeWakeUpTimeTextField.text else { return }
        changeWakeUpTimeTextField.text = "\(formatter.string(from: changeDatePicker.date))"
        changeWakeUpTimeText = changeWakeUpTimeTextFieldText
        changeWakeUpTimeDate = changeDatePicker.date
        print("wakeUpTimeText: ", changeWakeUpTimeText)
        changeWakeUpTimeLabel.text = "時間が変更されました"
        //ここで、時間を変更するfireStoreのコードを入れる
        let sendDBModel = SendDBModel()
        sendDBModel.changedChatRoomWakeUpAlarmTime(roomNameId: chatRoomDocumentID, wakeUpTimeDate: changeDatePicker.date, wakeUpTimeText: changeWakeUpTimeText)
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
        changeWakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        changeWakeUpGoBuckButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // 起きる時間をStack
        changeWakeUpTimeStackView.addArrangedSubview(changeWakeUpTimeLabel)
        changeWakeUpTimeStackView.addArrangedSubview(changeWakeUpTimeTextField)
        changeWakeUpTimeStackView.axis = .vertical
        changeWakeUpTimeStackView.alignment = .fill
        changeWakeUpTimeStackView.spacing = 10
        addSubview(changeWakeUpTimeStackView)
        
        addSubview(changeWakeUpGoBuckButton)
        
        NSLayoutConstraint.activate([
            //起きる時間
            changeWakeUpTimeStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            changeWakeUpTimeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpTimeStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            // 戻るボタン
            changeWakeUpGoBuckButton.topAnchor.constraint(equalTo: changeWakeUpTimeStackView.bottomAnchor, constant: spacePadding),
            changeWakeUpGoBuckButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpGoBuckButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpGoBuckButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension EditWakeUpAlarmTimeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeWakeUpTimeTextField.resignFirstResponder()
    }
}
