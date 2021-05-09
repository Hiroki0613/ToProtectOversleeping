//
//  WakeUpCardCollectionListCell.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/03.
//

import UIKit

protocol GoToChatNCDelegate {
    func goToChat()
}

class WakeUpCardCollectionListCell: UICollectionViewCell {
    
    var goToChatNCDelegate: GoToChatNCDelegate?
    
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
    
    // チャットへ移動するボタン
    var setChatButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "message")
    // アラームへ移動するボタン
    var setAlarmButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "alarm")
    var setChatAndAlarmButtonStackView = UIStackView(frame: .zero)
    
    
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
        setChatButton.tintColor = .systemBackground
        setAlarmButton.tintColor = .systemBackground
        
        
    }
    
    private func configure() {
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
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
        
        setChatButton.translatesAutoresizingMaskIntoConstraints = false
        setAlarmButton.translatesAutoresizingMaskIntoConstraints = false
        setChatAndAlarmButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNameLabel)
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamInvitationButton)
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
        setChatAndAlarmButtonStackView.addArrangedSubview(setAlarmButton)
        setChatAndAlarmButtonStackView.addArrangedSubview(setChatButton)
        setChatAndAlarmButtonStackView.axis = .horizontal
        setChatAndAlarmButtonStackView.alignment = .fill
        setChatAndAlarmButtonStackView.distribution = .fillEqually
        setChatAndAlarmButtonStackView.spacing = 20
        setChatButton.addTarget(self, action: #selector(goToChatVC), for: .touchUpInside)
        addSubview(setChatAndAlarmButtonStackView)
        
        NSLayoutConstraint.activate([
            //起きる時間
            wakeUpTimeStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            // チャットチーム
            chatTeamNameStackView.topAnchor.constraint(equalTo: wakeUpTimeTextFieldAndSwitchStackView.bottomAnchor, constant:  spacePadding),
            chatTeamNameStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chatTeamNameStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chatTeamNameStackView.heightAnchor.constraint(equalToConstant: 65),
            // アラームとチャットへ遷移するボタン
            setChatAndAlarmButtonStackView.topAnchor.constraint(equalTo: chatTeamNameAndRegstrationStackView.bottomAnchor, constant: spacePadding),
            setChatAndAlarmButtonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setChatAndAlarmButtonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setChatAndAlarmButtonStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func goToChatVC() {
        print("チャットボタンが押されました")
        //        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
        //        wakeUpCommunicateChatVC.title = "目覚ましセット"
        //        wakeUpCommunicateChatNC = UINavigationController(rootViewController: wakeUpCommunicateChatVC)
        //
        //        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
        self.goToChatNCDelegate?.goToChat()
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
