//
//  WakeUpCardCollectionListCell.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/03.
//

import UIKit

class WakeUpCardCollectionListCell: UICollectionViewCell {
    
    static let reuseID = "WakeUpCardCollectionListCell"
    // 起きる時間
    var wakeUpTimeLabel = UILabel()
    var wakeUpTimeTextField = UITextField()
    var wakeUpTimeStackView = UIStackView(frame: .zero)
    // チャットのチーム名、ピッカー式にするか悩む
    var chatTeamNameLabel = UILabel()
    var chatTeamNameTextField = UITextField()
    var chatTeamNameStackView = UIStackView(frame: .zero)
    // GPSを設定するボタン
    var setGPSLabel = UILabel()
    var setGPSButton = UIButton()
    var setGPSStackView = UIStackView(frame: .zero)
    // 地図の表示は要望があったら
    
    // 住所の表示、プライバシーの保護のために市区町村まで
    var prefectureAndCityNameLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemRed
//        settingInformation()
        configure()
        configureDecoration()
        settingInformation()
        
        self.backgroundView = UIView()
        addSubview(self.backgroundView!)
    }
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        wakeUpTimeLabel.text = "起きる時間"
        chatTeamNameLabel.text = "チャットチーム名"
        setGPSLabel.text = "住所"
        prefectureAndCityNameLabel.text = "GPSを取得すると、ここに表示されます"
    }
    
    
    private func configure() {
//        translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameStackView.translatesAutoresizingMaskIntoConstraints = false
        setGPSStackView.translatesAutoresizingMaskIntoConstraints = false
        prefectureAndCityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemRed
        let padding: CGFloat = 8
        // 起きる時間をStack
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeLabel)
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeTextField)
        wakeUpTimeStackView.axis = .vertical
        wakeUpTimeStackView.alignment = .fill
        addSubview(wakeUpTimeStackView)
        // チャットチーム名をStack
        chatTeamNameStackView.addArrangedSubview(chatTeamNameLabel)
        chatTeamNameStackView.addArrangedSubview(chatTeamNameTextField)
        chatTeamNameStackView.axis = .vertical
        chatTeamNameStackView.alignment = .fill
        addSubview(chatTeamNameStackView)
        // GPSセットをStack
        setGPSStackView.addArrangedSubview(setGPSLabel)
        setGPSStackView.addArrangedSubview(setGPSButton)
        setGPSStackView.axis = .vertical
        setGPSStackView.alignment = .fill
        addSubview(setGPSStackView)
        // 市区町村
        addSubview(prefectureAndCityNameLabel)
        
        NSLayoutConstraint.activate([
            //起きる時間
            wakeUpTimeStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: 10),
            // チャットチーム名
            chatTeamNameStackView.topAnchor.constraint(equalTo: wakeUpTimeStackView.bottomAnchor, constant: padding),
            chatTeamNameStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            chatTeamNameStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            chatTeamNameStackView.heightAnchor.constraint(equalToConstant: 10),
            // GPS
            setGPSStackView.topAnchor.constraint(equalTo: chatTeamNameStackView.bottomAnchor, constant: padding),
            setGPSStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            setGPSStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            setGPSStackView.heightAnchor.constraint(equalToConstant: 10),
            // 市区町村
            prefectureAndCityNameLabel.topAnchor.constraint(equalTo: setGPSStackView.bottomAnchor, constant: padding),
            prefectureAndCityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            prefectureAndCityNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            prefectureAndCityNameLabel.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    // セルを装飾
    private func configureDecoration() {
        self.backgroundView?.backgroundColor = .systemGray
        self.backgroundView?.layer.cornerRadius = 16
        self.backgroundView?.layer.shadowOpacity = 0.1
        self.backgroundView?.layer.shadowRadius = 10
        self.backgroundView?.layer.shadowOffset = .init(width: 0, height: 10)
        self.backgroundView?.layer.shouldRasterize = true
    }
}
