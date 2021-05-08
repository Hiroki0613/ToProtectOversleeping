//
//  NotUseWakeUpCardCollectionListCell.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit

class NotUseWakeUpCardCollectionListCell: UICollectionViewCell {
    
    static let reuseID = "WakeUpCardCollectionListCell"
    
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
    let wakeUpSetAlarmSwitch = UISwitch() //目覚ましのセット
    var wakeUpTimeTextFieldAndSwitchStackView = UIStackView(frame: .zero)
    var wakeUpTimeStackView = UIStackView(frame: .zero)
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var chatTeamLabel = WUBodyLabel(fontSize: 20)
    var chatTeamNameLabel = WUBodyLabel(fontSize: 20)
    var chatTeamNameTextField = WUTextFields()
    var chatTeamNewRegisterButton = WUButton(backgroundColor: .systemOrange, title: "新規登録")
    var chatTeamNewInvitedButton = WUButton(backgroundColor: .systemOrange, title: "招待される")
    var chatTeamInvitationButton = WUButton(backgroundColor: .systemOrange, title: "招待する")
    var chatTeamNameAndRegstrationStackView = UIStackView(frame: .zero)
    var chatTeamNameStackView = UIStackView(frame: .zero)
    var isChatTeamRegistered = false
    
    // チャットへ移動するボタン
    var setChatButton = WUButton(backgroundColor: .systemOrange, title: "チャットへ移動")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configure()
        configureDecoration()
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
        wakeUpTimeLabel.text = "起きる時間"
        chatTeamLabel.text = "チーム"
        chatTeamNameLabel.text = "早起き"
        wakeUpTimeTextField.inputView = datePicker
    }
    
    private func configure() {
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        //        translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        wakeUpSetAlarmSwitch.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeTextFieldAndSwitchStackView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpSetAlarmSwitch.isOn = false
        
        chatTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameTextField.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNewRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNewInvitedButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamInvitationButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameStackView.translatesAutoresizingMaskIntoConstraints = false
                
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // 起きる時間をStack
        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpTimeTextField)
        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpSetAlarmSwitch)
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
        if isChatTeamRegistered {
            // チームが登録済みの場合
            chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNameLabel)
            chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamInvitationButton)
        } else {
            // チームが未定の場合
            chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNewRegisterButton)
            chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNewInvitedButton)
        }
        
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
                    
        // GPSセットをStack
        addSubview(setChatButton)
        
        NSLayoutConstraint.activate([
            //起きる時間
            wakeUpTimeStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            // チャットチーム名
            chatTeamNameStackView.topAnchor.constraint(equalTo: wakeUpTimeTextFieldAndSwitchStackView.bottomAnchor, constant:  spacePadding),
            chatTeamNameStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chatTeamNameStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chatTeamNameStackView.heightAnchor.constraint(equalToConstant: 65),
            // GPS
            setChatButton.topAnchor.constraint(equalTo: chatTeamNameAndRegstrationStackView.bottomAnchor, constant: spacePadding),
            setChatButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setChatButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setChatButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // セルを装飾
    private func configureDecoration() {
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shouldRasterize = true
    }
}
