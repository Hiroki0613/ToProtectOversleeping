//
//  WakeUpCardTableListCell.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/12.
//

import UIKit

class WakeUpCardTableListCell: UITableViewCell {
    
//    var goToChatNCDelegate: GoToChatNCDelegate?
    
    static let reuseID = "WakeUpCardCollectionListCell"
    
    // セルの空白を開ける透明ビュー
    var transparentView = UIView()
    
    // tableViewのcell
    var tableCellView = UIView()
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var wakeUpChatTeamLabel = WUBodyLabel(fontSize: 20)
    var wakeUpChatTeamNameLabel = WUBodyLabel(fontSize: 20)
    let wakeUpSetAlarmSwitch = UISwitch() //目覚ましのセット
    var wakeUpChatTeamNameAndRegstrationStackView = UIStackView(frame: .zero)
    var wakeUpChatTeamStack = UIStackView(frame: .zero)
    
    // 起きる時間
    var wakeUpLabel = WUBodyLabel(fontSize: 20)
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
    var wakeUpTimeLabel = WUBodyLabel(fontSize: 20)
//    var wakeUpChatTeamInvitationButton = WUButton(backgroundColor: .systemOrange, title: "招待する")
    var wakeUpTimeTextFieldAndSwitchStackView = UIStackView(frame: .zero)
    var wakeUpTimeStackView = UIStackView(frame: .zero)
    
    // チャットへ移動するボタン
    var setChatButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "message")
    // アラームへ移動するボタン
    var setAlarmButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "alarm")
    var setChatAndAlarmButtonStackView = UIStackView(frame: .zero)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingInformation()
        configureUI()
        configureDecoration()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    @objc func dateChange() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:MM"
//        wakeUpTimeTextField.text = "\(formatter.string(from: datePicker.date))"
//    }
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
//        wakeUpTimeTextField.inputView = datePicker
//        wakeUpTimeLabel.text = "7:77"
        setChatButton.tintColor = .systemBackground
        setAlarmButton.tintColor = .systemBackground
    }
    
//    func set(settingList: SettingList) {
//        wakeUpSetAlarmSwitch.isOn = settingList.wakeUpSetAlarmSwitch
//        wakeUpChatTeamNameLabel.text = settingList.chatTeamName
//        //　ここにchatID
//        //　ここにpersonalID
//    }
    
    func set(chatRoomNameModel: ChatRoomNameModel) {
        wakeUpChatTeamLabel.text = "チーム名"
        wakeUpChatTeamNameLabel.text = chatRoomNameModel.roomName
        wakeUpLabel.text = "起きる時間"
        wakeUpTimeLabel.text = chatRoomNameModel.wakeUpTimeText
        
    }
    
    private func configureUI() {
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        tableCellView.translatesAutoresizingMaskIntoConstraints = false
        
        wakeUpChatTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpChatTeamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpSetAlarmSwitch.translatesAutoresizingMaskIntoConstraints = false
        wakeUpChatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpChatTeamStack.translatesAutoresizingMaskIntoConstraints = false
        wakeUpSetAlarmSwitch.isOn = false
        
        wakeUpLabel.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpChatTeamInvitationButton.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeTextFieldAndSwitchStackView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setChatButton.translatesAutoresizingMaskIntoConstraints = false
        setAlarmButton.translatesAutoresizingMaskIntoConstraints = false
        setChatAndAlarmButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
//        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // セルの空白を開ける透明ビューを追加
        contentView.addSubview(transparentView)
//        self.addSubview(transparentView)
        transparentView.backgroundColor = .systemOrange
        
        // 透明セルの上にtableViewのcellを追加
        transparentView.addSubview(tableCellView)
        tableCellView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        
        
        // チャットチーム名をStack
        wakeUpChatTeamStack.addArrangedSubview(wakeUpChatTeamLabel)
        wakeUpChatTeamNameAndRegstrationStackView.addArrangedSubview(wakeUpChatTeamNameLabel)
        wakeUpChatTeamNameAndRegstrationStackView.addArrangedSubview(wakeUpSetAlarmSwitch)
        wakeUpChatTeamNameAndRegstrationStackView.axis = .horizontal
        wakeUpChatTeamNameAndRegstrationStackView.alignment = .fill
        wakeUpChatTeamNameAndRegstrationStackView.spacing = 20
        wakeUpChatTeamStack.addArrangedSubview(wakeUpChatTeamNameAndRegstrationStackView)
        wakeUpChatTeamStack.axis = .vertical
        wakeUpChatTeamStack.alignment = .fill
        wakeUpChatTeamStack.spacing = 10
        tableCellView.addSubview(wakeUpChatTeamStack)
    
        // 起きる時間をStack
        wakeUpTimeStackView.addArrangedSubview(wakeUpLabel)
//        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpTimeTextField)
        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview((wakeUpTimeLabel))
//        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpChatTeamInvitationButton)
        wakeUpTimeTextFieldAndSwitchStackView.axis = .horizontal
        wakeUpTimeTextFieldAndSwitchStackView.alignment = .fill
        wakeUpTimeTextFieldAndSwitchStackView.distribution = .fillEqually
        wakeUpTimeTextFieldAndSwitchStackView.spacing = 30
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeTextFieldAndSwitchStackView)
        wakeUpTimeStackView.axis = .vertical
        wakeUpTimeStackView.alignment = .fill
        wakeUpTimeStackView.spacing = 10
        tableCellView.addSubview(wakeUpTimeStackView)
        
        // GPSセットをStack
        setChatAndAlarmButtonStackView.addArrangedSubview(setAlarmButton)
        setChatAndAlarmButtonStackView.addArrangedSubview(setChatButton)
        setChatAndAlarmButtonStackView.axis = .horizontal
        setChatAndAlarmButtonStackView.alignment = .fill
        setChatAndAlarmButtonStackView.distribution = .fillEqually
        setChatAndAlarmButtonStackView.spacing = 30
        tableCellView.addSubview(setChatAndAlarmButtonStackView)
        
        NSLayoutConstraint.activate([
            // 透明セル
            transparentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            transparentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            transparentView.heightAnchor.constraint(equalToConstant: 320),
            transparentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // tableViewのcell
            tableCellView.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: padding),
            tableCellView.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: padding),
            tableCellView.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -padding),
            tableCellView.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -padding),
            
            // 起きる時間
            wakeUpChatTeamStack.topAnchor.constraint(equalTo: tableCellView.topAnchor, constant: padding),
            wakeUpChatTeamStack.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            wakeUpChatTeamStack.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding),
            wakeUpChatTeamStack.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            // チャットチーム
            wakeUpTimeStackView.topAnchor.constraint(equalTo: wakeUpChatTeamStack.bottomAnchor, constant:  spacePadding),
            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding),
            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: 60),
            // アラームとチャットへ遷移するボタン
            setChatAndAlarmButtonStackView.topAnchor.constraint(equalTo: wakeUpTimeTextFieldAndSwitchStackView.bottomAnchor, constant: spacePadding),
            setChatAndAlarmButtonStackView.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            setChatAndAlarmButtonStackView.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding),
            setChatAndAlarmButtonStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // セルを装飾
    private func configureDecoration() {
//        tableViewCell.layer.shadowColor = UIColor.systemGray.cgColor
        tableCellView.layer.cornerRadius = 16
//        tableViewCell.layer.shadowOpacity = 0.1
//        tableViewCell.layer.shadowRadius = 10
//        tableViewCell.layer.shadowOffset = .init(width: 0, height: 10)
//        tableViewCell.layer.shouldRasterize = true
    }
}
