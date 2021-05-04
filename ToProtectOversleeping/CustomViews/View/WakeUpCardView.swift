//
//  WakeUpCardView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit

class WakeUpCardView: UIView {
    
    // 起きる時間
    var wakeUpTimeLabel = UILabel()
//    var wakeUpTimeTextField = UITextField()
//    var wakeUpTimeStackView = UIStackView(frame: .zero)
    // チャットのチーム名、ピッカー式にするか悩む
    var chatTeamNameLabel = UILabel()
//    var chatTeamNameTextField = UITextField()
//    var chatTeamNameStackView = UIStackView(frame: .zero)
    // GPSを設定するボタン
    var setGPSLabel = UILabel()
//    var setGPSButton = UIButton()
//    var setGPSStackView = UIStackView(frame: .zero)
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemRed
        let padding: CGFloat = 8
        // 起きる時間をStack
//        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeLabel)
//        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeTextField)
//        wakeUpTimeStackView.axis = .vertical
//        wakeUpTimeStackView.alignment = .fill
//        addSubview(wakeUpTimeStackView)
        
        addSubview(wakeUpTimeLabel)
        // チャットチーム名をStack
//        chatTeamNameStackView.addArrangedSubview(chatTeamNameLabel)
//        chatTeamNameStackView.addArrangedSubview(chatTeamNameTextField)
//        chatTeamNameStackView.axis = .vertical
//        chatTeamNameStackView.alignment = .fill
//        addSubview(chatTeamNameStackView)
        
        addSubview(chatTeamNameLabel)
        // GPSセットをStack
//        setGPSStackView.addArrangedSubview(setGPSLabel)
//        setGPSStackView.addArrangedSubview(setGPSButton)
//        setGPSStackView.axis = .vertical
//        setGPSStackView.alignment = .fill
//        addSubview(setGPSStackView)
        
        addSubview(setGPSLabel)
        // 市区町村
        addSubview(prefectureAndCityNameLabel)
        
//        NSLayoutConstraint.activate([
//            //起きる時間
//            wakeUpTimeStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
//            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: 10),
//            // チャットチーム名
//            chatTeamNameStackView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: padding),
//            chatTeamNameStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            chatTeamNameStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            chatTeamNameStackView.heightAnchor.constraint(equalToConstant: 10),
//            // GPS
//            setGPSStackView.topAnchor.constraint(equalTo: chatTeamNameStackView.bottomAnchor, constant: padding),
//            setGPSStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            setGPSStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            setGPSStackView.heightAnchor.constraint(equalToConstant: 10),
//            // 市区町村
//            prefectureAndCityNameLabel.topAnchor.constraint(equalTo: setGPSStackView.bottomAnchor, constant: padding),
//            prefectureAndCityNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            prefectureAndCityNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            prefectureAndCityNameLabel.heightAnchor.constraint(equalToConstant: 10)
//        ])
        
        NSLayoutConstraint.activate([
            //起きる時間
            wakeUpTimeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            wakeUpTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            wakeUpTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            wakeUpTimeLabel.heightAnchor.constraint(equalToConstant: 10),
            // チャットチーム名
            chatTeamNameLabel.topAnchor.constraint(equalTo: wakeUpTimeLabel.bottomAnchor, constant: padding),
            chatTeamNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chatTeamNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chatTeamNameLabel.heightAnchor.constraint(equalToConstant: 10),
            // GPS
            setGPSLabel.topAnchor.constraint(equalTo: chatTeamNameLabel.bottomAnchor, constant: padding),
            setGPSLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setGPSLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setGPSLabel.heightAnchor.constraint(equalToConstant: 10),
            // 市区町村
            prefectureAndCityNameLabel.topAnchor.constraint(equalTo: setGPSLabel.bottomAnchor, constant: padding),
            prefectureAndCityNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            prefectureAndCityNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            prefectureAndCityNameLabel.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    // セルを装飾
    private func configureDecoration() {
        self.backgroundColor = .systemGray
        self.layer.cornerRadius = 16
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = .init(width: 0, height: 10)
        self.layer.shouldRasterize = true
    }
}
