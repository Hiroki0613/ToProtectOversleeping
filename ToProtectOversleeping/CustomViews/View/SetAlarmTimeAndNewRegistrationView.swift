//
//  SetAlarmTimeAndNewRegistrationView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit

class SetAlarmTimeAndNewRegistrationView: UIView, UITableViewDelegate {
    
    // アラーム時間を一時的に格納する
    var wakeUpTimeText = ""
    var wakeUpTimeDate = Date()
    
    // 起きる時間
    var wakeUpTimeLabel = WUBodyLabel(fontSize: 20)
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.preferredDatePickerStyle = .wheels
        dp.timeZone = NSTimeZone.local
        dp.locale = Locale.current
        dp.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        return dp
    }()
    var wakeUpTimeTextField = WUTextFields()
    var wakeUpTimeView = UIView(frame: .zero)
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var chatTeamLabel = WUBodyLabel(fontSize: 20)
    var chatTeamNameLabel = WUBodyLabel(fontSize: 20)
    var chatTeamNameTextField = WUTextFields()
    var chatTeamNewRegisterButton = WUButton(backgroundColor: .systemOrange, title: "新規登録")
    var chatTeamNewInvitedButton = WUButton(backgroundColor: .systemOrange, title: "招待される")
    var chatTeamNameAndRegstrationStackView = UIStackView(frame: .zero)
    
    // 戻るボタン
    let wakeUpGoBuckButton = WUButton(backgroundColor: .systemOrange, title: "戻る")
    
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
        guard let wakeUpTimeTextFieldText = wakeUpTimeTextField.text else { return }
        wakeUpTimeTextField.text = "\(formatter.string(from: datePicker.date))"
        wakeUpTimeText = wakeUpTimeTextFieldText
        wakeUpTimeDate = datePicker.date
        print("wakeUpTimeText: ", wakeUpTimeText)
    }
    
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        wakeUpTimeLabel.text = "起きる時間"
        chatTeamLabel.text = "チーム"
        wakeUpTimeTextField.inputView = datePicker
        print("datePicker: ", datePicker)
        wakeUpTimeTextField.delegate = self
    }
    
    // UIDatePickerのDoneを押したら発火
    @objc func done() {
        wakeUpTimeTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let wakeUpTimeTextFieldText = wakeUpTimeTextField.text else { return }
        wakeUpTimeTextField.text = "\(formatter.string(from: datePicker.date))"
        wakeUpTimeText = wakeUpTimeTextFieldText
        wakeUpTimeDate = datePicker.date
        print("wakeUpTimeText: ", wakeUpTimeText)
    }
    
    
    private func configure() {
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        wakeUpTimeTextField.inputAccessoryView = toolbar
        
        wakeUpTimeView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        chatTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameTextField.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNewRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNewInvitedButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        wakeUpGoBuckButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 10.0
        let labelSpacePadding: CGFloat = 30
        let labelButtonHightPadding: CGFloat = 50
        
        // 起きる時間をStack
        addSubview(wakeUpTimeView)
        wakeUpTimeView.addSubview(wakeUpTimeLabel)
        wakeUpTimeView.addSubview(wakeUpTimeTextField)
        
        // チャットチーム名をStack
        wakeUpTimeView.addSubview(chatTeamLabel)
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNewRegisterButton)
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNewInvitedButton)
        chatTeamNameAndRegstrationStackView.axis = .horizontal
        chatTeamNameAndRegstrationStackView.distribution = .fillEqually
        chatTeamNameAndRegstrationStackView.spacing = 20
        wakeUpTimeView.addSubview(chatTeamNameAndRegstrationStackView)
        wakeUpTimeView.addSubview(wakeUpGoBuckButton)
        
        NSLayoutConstraint.activate([
            //起きる時間
            wakeUpTimeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            wakeUpTimeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            wakeUpTimeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            wakeUpTimeView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            wakeUpTimeLabel.topAnchor.constraint(equalTo: wakeUpTimeView.topAnchor, constant: padding),
            wakeUpTimeLabel.leadingAnchor.constraint(equalTo: wakeUpTimeView.leadingAnchor, constant: padding),
            wakeUpTimeLabel.trailingAnchor.constraint(equalTo: wakeUpTimeView.trailingAnchor, constant: -padding),
            wakeUpTimeLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            wakeUpTimeTextField.topAnchor.constraint(equalTo: wakeUpTimeLabel.bottomAnchor, constant: spacePadding),
            wakeUpTimeTextField.leadingAnchor.constraint(equalTo: wakeUpTimeView.leadingAnchor, constant: padding),
            wakeUpTimeTextField.trailingAnchor.constraint(equalTo: wakeUpTimeView.trailingAnchor, constant: -padding),
            wakeUpTimeTextField.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            // チャットチーム名
            chatTeamLabel.topAnchor.constraint(equalTo: wakeUpTimeTextField.bottomAnchor, constant: spacePadding),
            chatTeamLabel.leadingAnchor.constraint(equalTo: wakeUpTimeView.leadingAnchor, constant: padding),
            chatTeamLabel.trailingAnchor.constraint(equalTo: wakeUpTimeView.trailingAnchor, constant: -padding),
            chatTeamLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            chatTeamNameAndRegstrationStackView.topAnchor.constraint(equalTo: chatTeamLabel.bottomAnchor, constant: spacePadding),
            chatTeamNameAndRegstrationStackView.leadingAnchor.constraint(equalTo: wakeUpTimeView.leadingAnchor, constant: padding),
            chatTeamNameAndRegstrationStackView.trailingAnchor.constraint(equalTo: wakeUpTimeView.trailingAnchor, constant: -padding),
            chatTeamNameAndRegstrationStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            // 戻るボタン
            wakeUpGoBuckButton.topAnchor.constraint(equalTo: chatTeamNameAndRegstrationStackView.bottomAnchor, constant: labelSpacePadding),
            wakeUpGoBuckButton.leadingAnchor.constraint(equalTo: wakeUpTimeView.leadingAnchor, constant: padding),
            wakeUpGoBuckButton.trailingAnchor.constraint(equalTo: wakeUpTimeView.trailingAnchor, constant: -padding),
            wakeUpGoBuckButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wakeUpTimeTextField.resignFirstResponder()
    }
    
}
