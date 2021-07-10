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
    var setChatButton = WUButton(backgroundColor: PrimaryColor.primary, sfSymbolString: "message")
    // アラームへ移動するボタン
    var setAlarmButton = WUButton(backgroundColor: PrimaryColor.primary, sfSymbolString: "alarm")
    var setChatAndAlarmButtonStackView = UIStackView(frame: .zero)
    
    // 左へスワイプ可能を表示するLabel
    var swipeOkLeftLabel = UILabel()
    // 右へスワイプ可能を表示するLabel
    var swipeOkRightLabel = UILabel()
    
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

//        wakeUpChatTeamNameLabel.text = chatRoomNameModel.roomName
        let checkChatTeamNameLabel = UserDefaults.standard.object(forKey: "teamChatName") as! String
        if checkChatTeamNameLabel == "NoName777" {
            wakeUpChatTeamNameLabel.text = "未登録"
        } else {
            wakeUpChatTeamNameLabel.text = checkChatTeamNameLabel
        }
        

        wakeUpSetAlarmSwitch.isOn = chatRoomNameModel.isWakeUpBool
        
        //アラームスイッチがONの時は、
        if wakeUpSetAlarmSwitch.isOn == true {
            self.tableCellView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
            self.setAlarmButton.backgroundColor = PrimaryColor.primary
            self.setAlarmButton.isHidden = false
            self.setAlarmButton.isEnabled = true
        } else {
            self.tableCellView.backgroundColor = .systemGray5.withAlphaComponent(0.9)
            self.setAlarmButton.backgroundColor = PrimaryColor.primary.withAlphaComponent(0.3)
            self.setAlarmButton.isHidden = true
            self.setAlarmButton.isEnabled = false
        }
        
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
        
        swipeOkLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        swipeOkRightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 10.0
        let labelButtonHightPadding: CGFloat = 30
        
        // セルの空白を開ける透明ビューを追加
        contentView.addSubview(transparentView)
        transparentView.backgroundColor = PrimaryColor.primary
        
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
        
        let leftSwipeText = NSMutableAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "arrow.left")!))
        leftSwipeText.append(NSAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "pencil")!)))
        leftSwipeText.append(NSAttributedString(string: "\n"))
        leftSwipeText.append(NSAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "arrow.left")!)))
        leftSwipeText.append(NSAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "person.badge.plus")!)))
        swipeOkLeftLabel.attributedText = leftSwipeText
        swipeOkLeftLabel.numberOfLines = 2
        swipeOkLeftLabel.sizeToFit()
        tableCellView.addSubview(swipeOkLeftLabel)
        
        let rightSwipeText = NSMutableAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "arrow.right")!))
        rightSwipeText.append(NSAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "trash")!)))
        swipeOkRightLabel.attributedText = rightSwipeText
        swipeOkRightLabel.numberOfLines = 1
        swipeOkRightLabel.sizeToFit()
        tableCellView.addSubview(swipeOkRightLabel)
        
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
            
            // 左スワイプ
            swipeOkLeftLabel.topAnchor.constraint(equalTo: tableCellView.centerYAnchor),
            swipeOkLeftLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor),
            
            // 右スワイプ
            swipeOkRightLabel.topAnchor.constraint(equalTo: tableCellView.centerYAnchor),
            swipeOkRightLabel.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor),
            
            // チャットチーム
            wakeUpChatTeamLabel.topAnchor.constraint(equalTo: tableCellView.topAnchor, constant: padding),
            wakeUpChatTeamLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            wakeUpChatTeamLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            wakeUpChatTeamNameLabel.topAnchor.constraint(equalTo: wakeUpChatTeamLabel.bottomAnchor, constant: spacePadding),
            wakeUpChatTeamNameLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            wakeUpChatTeamNameLabel.heightAnchor.constraint(equalToConstant: 30),
            wakeUpSetAlarmSwitch.topAnchor.constraint(equalTo: tableCellView.topAnchor, constant: padding),
            wakeUpSetAlarmSwitch.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding),
            
            // 起きる時間
            wakeUpLabel.topAnchor.constraint(equalTo: wakeUpChatTeamNameLabel.bottomAnchor, constant: padding),
            wakeUpLabel.leadingAnchor.constraint(equalTo: swipeOkLeftLabel.trailingAnchor, constant: padding),
            wakeUpLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            wakeUpTimeLabel.topAnchor.constraint(equalTo: wakeUpChatTeamNameLabel.bottomAnchor, constant: padding),
            wakeUpTimeLabel.leadingAnchor.constraint(equalTo: wakeUpLabel.trailingAnchor, constant: spacePadding),
            wakeUpTimeLabel.heightAnchor.constraint(equalToConstant: 50),
            // アラームとチャットへ遷移するボタン
            setChatAndAlarmButtonStackView.topAnchor.constraint(equalTo: wakeUpTimeLabel.bottomAnchor, constant: 20),
            setChatAndAlarmButtonStackView.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            setChatAndAlarmButtonStackView.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding),
            setChatAndAlarmButtonStackView.bottomAnchor.constraint(equalTo: tableCellView.bottomAnchor, constant: -padding)
        ])
    }
}
