//
//  WakeUpCardTableListCell.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/12.
//

import UIKit

class WakeUpCardTableListCell: UITableViewCell {
        
    static let reuseID = "WakeUpCardCollectionListCell"
    
    // セルの空白を開ける透明ビュー
    var transparentView = UIView()
    
    // tableViewのcell
    var tableCellView = UIView()
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var wakeUpChatTeamLabel = WUBodyLabel(fontSize: 20)
    var wakeUpChatTeamNameLabel = WUBodyLabel(fontSize: 20)
    let wakeUpSetAlarmSwitch = UISwitch() //目覚ましのセット
    
    // 起きる時間
    var wakeUpLabel = WUBodyLabel(fontSize: 20)
    var wakeUpTimeLabel = WUBodyLabel(fontSize: 40)

    // チャットへ移動するボタン
    var setChatButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "message")
    // アラームへ移動するボタン
    var setAlarmButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "alarm")
    var setChatAndAlarmButtonStackView = UIStackView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingInformation()
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        setChatButton.tintColor = .systemBackground
        setAlarmButton.tintColor = .systemBackground
    }
    
    func set(chatRoomNameModel: ChatRoomNameModel) {
        wakeUpChatTeamLabel.text = "チーム名"
        wakeUpChatTeamNameLabel.text = chatRoomNameModel.roomName
        wakeUpSetAlarmSwitch.isOn = chatRoomNameModel.isWakeUpBool
        wakeUpLabel.text = "起きる時間"
        wakeUpTimeLabel.text = chatRoomNameModel.wakeUpTimeText
        
    }
    
    private func configureUI() {
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        tableCellView.translatesAutoresizingMaskIntoConstraints = false
        tableCellView.layer.cornerRadius = 16
        
        wakeUpChatTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpChatTeamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpSetAlarmSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        wakeUpLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setChatButton.translatesAutoresizingMaskIntoConstraints = false
        setAlarmButton.translatesAutoresizingMaskIntoConstraints = false
        setChatAndAlarmButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 10.0
        let labelButtonHightPadding: CGFloat = 30
        
        // セルの空白を開ける透明ビューを追加
        contentView.addSubview(transparentView)
        transparentView.backgroundColor = .systemOrange
        
        // 透明セルの上にtableViewのcellを追加
        transparentView.addSubview(tableCellView)
        tableCellView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        
        
        // チャットチーム名をStack
        tableCellView.addSubview(wakeUpChatTeamLabel)
        tableCellView.addSubview(wakeUpChatTeamNameLabel)
        tableCellView.addSubview(wakeUpSetAlarmSwitch)
        
        // 起きる時間をStack
        tableCellView.addSubview(wakeUpLabel)
        tableCellView.addSubview(wakeUpTimeLabel)
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
            transparentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // tableViewのcell
            tableCellView.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: padding),
            tableCellView.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: padding),
            tableCellView.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -padding),
            tableCellView.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -padding),
            
            // 起きる時間
            wakeUpChatTeamLabel.topAnchor.constraint(equalTo: tableCellView.topAnchor, constant: padding),
            wakeUpChatTeamLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            wakeUpChatTeamLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            wakeUpChatTeamNameLabel.topAnchor.constraint(equalTo: wakeUpChatTeamLabel.bottomAnchor, constant: spacePadding),
            wakeUpChatTeamNameLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            wakeUpChatTeamNameLabel.heightAnchor.constraint(equalToConstant: 30),
            wakeUpSetAlarmSwitch.topAnchor.constraint(equalTo: tableCellView.topAnchor, constant: padding),
            wakeUpSetAlarmSwitch.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding),
            
            // チャットチーム
            wakeUpLabel.topAnchor.constraint(equalTo: wakeUpChatTeamNameLabel.bottomAnchor, constant: padding),
            wakeUpLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            wakeUpLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            wakeUpTimeLabel.topAnchor.constraint(equalTo: wakeUpChatTeamNameLabel.bottomAnchor, constant: padding),
            wakeUpTimeLabel.leadingAnchor.constraint(equalTo: wakeUpLabel.trailingAnchor, constant: spacePadding),
            wakeUpTimeLabel.heightAnchor.constraint(equalToConstant: 50),
//            // アラームとチャットへ遷移するボタン
            setChatAndAlarmButtonStackView.topAnchor.constraint(equalTo: wakeUpTimeLabel.bottomAnchor, constant: spacePadding),
            setChatAndAlarmButtonStackView.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            setChatAndAlarmButtonStackView.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding),
            setChatAndAlarmButtonStackView.bottomAnchor.constraint(equalTo: tableCellView.bottomAnchor, constant: -padding)
        ])
    }
}
