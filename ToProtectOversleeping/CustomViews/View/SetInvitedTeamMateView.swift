//
//  SetInvitedTeamMateView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/09.
//

import UIKit

class SetInvitedTeamMateView: UIView {
    
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
    let wakeUpDismissButton = WUButton(backgroundColor: .systemOrange, title: "×")
    var wakeUpTimeTextFieldAndSwitchStackView = UIStackView(frame: .zero)
    var wakeUpTimeStackView = UIStackView(frame: .zero)
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var chatTeamNewRegisterButton = WUButton(backgroundColor: .systemOrange, title: "登録")
    var chatTeamGoBackButton = WUButton(backgroundColor: .systemOrange, title: "戻る")
    var chatTeamNameAndRegstrationStackView = UIStackView(frame: .zero)
    
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
        formatter.dateFormat = "HH:MM"
        wakeUpTimeTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        wakeUpTimeLabel.text = "チーム名を入力してください"
    }
    
    
    private func configure() {
        wakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        wakeUpDismissButton.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeTextFieldAndSwitchStackView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        chatTeamNewRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamGoBackButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // 起きる時間をStack
        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpTimeTextField)
        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpDismissButton)
        wakeUpTimeTextFieldAndSwitchStackView.axis = .horizontal
        wakeUpTimeTextFieldAndSwitchStackView.alignment = .fill
        wakeUpTimeTextFieldAndSwitchStackView.spacing = 20
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeLabel)
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeTextFieldAndSwitchStackView)
        wakeUpTimeStackView.axis = .vertical
        wakeUpTimeStackView.alignment = .fill
        wakeUpTimeStackView.spacing = 10
        addSubview(wakeUpTimeStackView)
        
        // チャットチーム名をStack
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNewRegisterButton)
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamGoBackButton)
        
        chatTeamNameAndRegstrationStackView.axis = .horizontal
        chatTeamNameAndRegstrationStackView.alignment = .fill
        chatTeamNameAndRegstrationStackView.distribution = .fillEqually
        chatTeamNameAndRegstrationStackView.spacing = 20
        chatTeamNameAndRegstrationStackView.axis = .vertical
        chatTeamNameAndRegstrationStackView.alignment = .fill
        chatTeamNameAndRegstrationStackView.spacing = 10
        addSubview(chatTeamNameAndRegstrationStackView)
        
        
        NSLayoutConstraint.activate([
            //起きる時間
            wakeUpTimeStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            // チャットチーム名
            chatTeamNameAndRegstrationStackView.topAnchor.constraint(equalTo: wakeUpTimeTextFieldAndSwitchStackView.bottomAnchor, constant:  spacePadding),
            chatTeamNameAndRegstrationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chatTeamNameAndRegstrationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chatTeamNameAndRegstrationStackView.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
}
