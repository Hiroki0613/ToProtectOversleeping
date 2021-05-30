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
    var wakeUpTimeStackView = UIStackView(frame: .zero)
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var chatTeamLabel = WUBodyLabel(fontSize: 20)
    var chatTeamNameLabel = WUBodyLabel(fontSize: 20)
    var chatTeamNameTextField = WUTextFields()
    var chatTeamNewRegisterButton = WUButton(backgroundColor: .systemOrange, title: "新規登録")
    var chatTeamNewInvitedButton = WUButton(backgroundColor: .systemOrange, title: "招待される")
    
    var chatTeamNameAndRegstrationStackView = UIStackView(frame: .zero)
    var chatTeamNameStackView = UIStackView(frame: .zero)
    
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
        wakeUpTimeTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        wakeUpTimeLabel.text = "起きる時間"
        chatTeamLabel.text = "チーム"
        chatTeamNameLabel.text = "早起き"
        
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
        
        wakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        chatTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameTextField.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNewRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNewInvitedButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        wakeUpGoBuckButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // 起きる時間をStack
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeLabel)
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeTextField)
        wakeUpTimeStackView.axis = .vertical
        wakeUpTimeStackView.alignment = .fill
        wakeUpTimeStackView.spacing = 10
        addSubview(wakeUpTimeStackView)
        
        // チャットチーム名をStack
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNewRegisterButton)
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNewInvitedButton)
        chatTeamNameAndRegstrationStackView.axis = .horizontal
        chatTeamNameAndRegstrationStackView.alignment = .fill
        chatTeamNameAndRegstrationStackView.distribution = .fillEqually
        chatTeamNameAndRegstrationStackView.spacing = 20
        chatTeamNameStackView.addArrangedSubview(chatTeamLabel)
        chatTeamNameStackView.addArrangedSubview(chatTeamNameAndRegstrationStackView)
        chatTeamNameStackView.axis = .vertical
        chatTeamNameStackView.alignment = .fill
        chatTeamNameStackView.spacing = 10
        addSubview(chatTeamNameStackView)
        
        addSubview(wakeUpGoBuckButton)
        
        NSLayoutConstraint.activate([
            //起きる時間
            wakeUpTimeStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            // チャットチーム名
            chatTeamNameStackView.topAnchor.constraint(equalTo: wakeUpTimeStackView.bottomAnchor, constant:  spacePadding),
            chatTeamNameStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chatTeamNameStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chatTeamNameStackView.heightAnchor.constraint(equalToConstant: 65),
            
            // 戻るボタン
            wakeUpGoBuckButton.topAnchor.constraint(equalTo: chatTeamNameStackView.bottomAnchor, constant: spacePadding),
            wakeUpGoBuckButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            wakeUpGoBuckButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            wakeUpGoBuckButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wakeUpTimeTextField.resignFirstResponder()
    }
    
}


//extension SetAlarmTimeAndNewRegistrationView: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // キーボード入力や、カット/ペースによる変更を防ぐ
//             return false
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//    }
//

//    override func resignFirstResponder() -> Bool {
//        return true
//    }
//}
