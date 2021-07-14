////
////  WakeUpCardCollectionListCell.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/05/03.
////
//
//import UIKit
//
//protocol GoToChatNCDelegate {
//    func goToChat()
//}
//
//class WakeUpCardCollectionListCell: UICollectionViewCell {
//
//    var goToChatNCDelegate: GoToChatNCDelegate?
//
//    static let reuseID = "WakeUpCardCollectionListCell"
//
//    // チャットのチーム名、ワンタイムトークンにて招待制
//    var wakeUpChatTeamLabel = WUBodyLabel(fontSize: 20)
//    var wakeUpChatTeamNameLabel = WUBodyLabel(fontSize: 20)
//    let wakeUpSetAlarmSwitch = UISwitch() //目覚ましのセット
//    var wakeUpChatTeamNameAndRegstrationStackView = UIStackView(frame: .zero)
//    var wakeUpChatTeamStack = UIStackView(frame: .zero)
//
//    // 起きる時間
//    var wakeUpTimeLabel = WUBodyLabel(fontSize: 20)
//    let datePicker: UIDatePicker = {
//        let dp = UIDatePicker()
//        dp.datePickerMode = .time
//        dp.preferredDatePickerStyle = .wheels
//        dp.timeZone = NSTimeZone.local
//        dp.locale = Locale.current
//        dp.addTarget(self, action: #selector(dateChange), for: .valueChanged)
//        return dp
//    }()
//    var wakeUpTimeTextField = WUTextFields()
//    var wakeUpChatTeamInvitationButton = WUButton(backgroundColor: PrimaryColor.primary, title: "招待する")
//    var wakeUpTimeTextFieldAndSwitchStackView = UIStackView(frame: .zero)
//    var wakeUpTimeStackView = UIStackView(frame: .zero)
//    
//    // チャットへ移動するボタン
//    var setChatButton = WUButton(backgroundColor: PrimaryColor.primary, sfSymbolString: "message")
//    // アラームへ移動するボタン
//    var setAlarmButton = WUButton(backgroundColor: PrimaryColor.primary, sfSymbolString: "alarm")
//    var setChatAndAlarmButtonStackView = UIStackView(frame: .zero)
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        settingInformation()
//        configure()
//        configureDecoration()
//    }
//
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    @objc func dateChange() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:MM"
//        wakeUpTimeTextField.text = "\(formatter.string(from: datePicker.date))"
//    }
//
//    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
//    private func settingInformation() {
////        wakeUpTimeLabel.text = "起きる時間"
////        chatTeamLabel.text = "チーム"
////        chatTeamNameLabel.text = "早起き"
//        wakeUpTimeTextField.inputView = datePicker
//        setChatButton.tintColor = .systemBackground
//        setAlarmButton.tintColor = .systemBackground
//    }
//
////    func set(settingList: SettingList) {
//////        wakeUpTimeTextField.text = settingList.wakeUpTime
////        wakeUpSetAlarmSwitch.isOn = settingList.wakeUpSetAlarmSwitch
////        wakeUpChatTeamNameLabel.text = settingList.chatTeamName
////        //　ここにchatID
////        //　ここにpersonalID
////    }
//
//    private func configure() {
//        backgroundColor = .systemBackground.withAlphaComponent(0.7)
//        wakeUpChatTeamLabel.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpChatTeamNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpSetAlarmSwitch.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpChatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpChatTeamStack.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpSetAlarmSwitch.isOn = false
//
//        wakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpTimeTextField.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpChatTeamInvitationButton.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpChatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        setChatButton.translatesAutoresizingMaskIntoConstraints = false
//        setAlarmButton.translatesAutoresizingMaskIntoConstraints = false
//        setChatAndAlarmButtonStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        backgroundColor = .systemBackground.withAlphaComponent(0.7)
//        let padding: CGFloat = 20.0
//        let spacePadding: CGFloat = 30.0
//        let labelButtonHightPadding: CGFloat = 60
//
//        // チャットチーム名をStack
//        wakeUpChatTeamStack.addArrangedSubview(wakeUpChatTeamLabel)
//        wakeUpChatTeamNameAndRegstrationStackView.addArrangedSubview(wakeUpChatTeamNameLabel)
//        wakeUpChatTeamNameAndRegstrationStackView.addArrangedSubview(wakeUpSetAlarmSwitch)
//        wakeUpChatTeamNameAndRegstrationStackView.axis = .horizontal
//        wakeUpChatTeamNameAndRegstrationStackView.alignment = .fill
//        wakeUpChatTeamNameAndRegstrationStackView.spacing = 20
//
//        wakeUpChatTeamStack.addArrangedSubview(wakeUpChatTeamNameAndRegstrationStackView)
//        wakeUpChatTeamStack.axis = .vertical
//        wakeUpChatTeamStack.alignment = .fill
//        wakeUpChatTeamStack.spacing = 10
//        addSubview(wakeUpChatTeamStack)
//
//        // 起きる時間をStack
//        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeLabel)
//        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpTimeTextField)
//        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpChatTeamInvitationButton)
//        wakeUpTimeTextFieldAndSwitchStackView.axis = .horizontal
//        wakeUpTimeTextFieldAndSwitchStackView.alignment = .fill
//        wakeUpTimeTextFieldAndSwitchStackView.distribution = .fillEqually
//        wakeUpTimeTextFieldAndSwitchStackView.spacing = 20
//
//        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeTextFieldAndSwitchStackView)
//        wakeUpTimeStackView.axis = .vertical
//        wakeUpTimeStackView.alignment = .fill
//        wakeUpTimeStackView.spacing = 10
//        addSubview(wakeUpTimeStackView)
//
//        // GPSセットをStack
//        setChatAndAlarmButtonStackView.addArrangedSubview(setAlarmButton)
//        setChatAndAlarmButtonStackView.addArrangedSubview(setChatButton)
//        setChatAndAlarmButtonStackView.axis = .horizontal
//        setChatAndAlarmButtonStackView.alignment = .fill
//        setChatAndAlarmButtonStackView.distribution = .fillEqually
//        setChatAndAlarmButtonStackView.spacing = 20
////        setChatButton.addTarget(self, action: #selector(goToChatVC), for: .touchUpInside)
//        addSubview(setChatAndAlarmButtonStackView)
//
//        NSLayoutConstraint.activate([
//            //起きる時間
//            wakeUpChatTeamStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
//            wakeUpChatTeamStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            wakeUpChatTeamStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            wakeUpChatTeamStack.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
//            // チャットチーム
//            wakeUpTimeStackView.topAnchor.constraint(equalTo: wakeUpChatTeamNameAndRegstrationStackView.bottomAnchor, constant:  spacePadding),
//            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: 65),
//            // アラームとチャットへ遷移するボタン
//            setChatAndAlarmButtonStackView.topAnchor.constraint(equalTo: wakeUpTimeTextFieldAndSwitchStackView.bottomAnchor, constant: spacePadding),
//            setChatAndAlarmButtonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            setChatAndAlarmButtonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            setChatAndAlarmButtonStackView.heightAnchor.constraint(equalToConstant: 40)
//        ])
//    }
//
////    @objc func goToChatVC() {
////        print("チャットボタンが押されました")
////        //        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
////        //        wakeUpCommunicateChatVC.title = "目覚ましセット"
////        //        wakeUpCommunicateChatNC = UINavigationController(rootViewController: wakeUpCommunicateChatVC)
////        //
////        //        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
////        self.goToChatNCDelegate?.goToChat()
////    }
//
//    // セルを装飾
//    private func configureDecoration() {
////        layer.shadowColor = UIColor.systemGray.cgColor
//        layer.cornerRadius = 16
////        layer.shadowOpacity = 0.1
////        layer.shadowRadius = 10
////        layer.shadowOffset = .init(width: 0, height: 10)
////        layer.shouldRasterize = true
//    }
//}
