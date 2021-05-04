//
//  WakeUpCardView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/04.
//

import UIKit
import MapKit

class WakeUpCardView: UIView {
    
    // 起きる時間
    var wakeUpTimeLabel = UILabel()
    var wakeUpTimeTextField = UITextField()
    var wakeUpTimeStackView = UIStackView(frame: .zero)
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.preferredDatePickerStyle = .wheels
        dp.timeZone = NSTimeZone.local
        dp.locale = Locale.current
        dp.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        return dp
    }()
    
    // チャットのチーム名、ピッカー式にするか悩む
    var chatTeamNameLabel = UILabel()
    var chatTeamNameTextField = UITextField()
    var chatTeamNameStackView = UIStackView(frame: .zero)
    
    // GPSを設定するボタン
    var setGPSLabel = UILabel()
    var setGPSButton = UIButton()
    var setGPSStackView = UIStackView(frame: .zero)
    // 地図の表示は要望があったら
    

    // アドレスを格納
    var addressString = ""
    // 住所の表示、プライバシーの保護のために市区町村まで
    var prefectureAndCityNameLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemRed
        settingInformation()
        configure()
        //        configureDecoration()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dateChange() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        wakeUpTimeTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    // 位置から住所を取得
    func convert(latitude:CLLocationDegrees, longitude: CLLocationDegrees) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemark, error in
            
            if placemark != nil {
                if let pm = placemark?.first {
                    
                    if pm.administrativeArea != nil || pm.locality != nil {
                        
                        self.addressString = pm.name! + pm.administrativeArea! + pm.locality!
                    } else {
                        self.addressString = pm.name!
                    }
                    
                    self.prefectureAndCityNameLabel.text = self.addressString
                }
            }
        }
    }
    
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        wakeUpTimeLabel.text = "起きる時間"
        chatTeamNameLabel.text = "チャットチーム名"
        setGPSLabel.text = "住所"
        prefectureAndCityNameLabel.text = "GPSを取得すると、ここに表示されます"
        
        wakeUpTimeTextField.inputView = datePicker
        wakeUpTimeTextField.delegate = self
    }
    
    
    private func configure() {
        //        translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameStackView.translatesAutoresizingMaskIntoConstraints = false
        setGPSStackView.translatesAutoresizingMaskIntoConstraints = false
        prefectureAndCityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 50.0
        // 起きる時間をStack
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeLabel)
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeTextField)
        wakeUpTimeStackView.axis = .vertical
        wakeUpTimeStackView.alignment = .fill
        addSubview(wakeUpTimeStackView)
        
        //        addSubview(wakeUpTimeLabel)
        // チャットチーム名をStack
        chatTeamNameStackView.addArrangedSubview(chatTeamNameLabel)
        chatTeamNameStackView.addArrangedSubview(chatTeamNameTextField)
        chatTeamNameStackView.axis = .vertical
        chatTeamNameStackView.alignment = .fill
        addSubview(chatTeamNameStackView)
        
        //        addSubview(chatTeamNameLabel)
        // GPSセットをStack
        setGPSStackView.addArrangedSubview(setGPSLabel)
        setGPSStackView.addArrangedSubview(setGPSButton)
        setGPSStackView.axis = .vertical
        setGPSStackView.alignment = .fill
        addSubview(setGPSStackView)
        
        //        addSubview(setGPSLabel)
        // 市区町村
        addSubview(prefectureAndCityNameLabel)
        
        NSLayoutConstraint.activate([
            //起きる時間
            wakeUpTimeStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: spacePadding),
            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: spacePadding),
            // チャットチーム名
            chatTeamNameStackView.topAnchor.constraint(equalTo: wakeUpTimeLabel.bottomAnchor, constant:  spacePadding),
            chatTeamNameStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chatTeamNameStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chatTeamNameStackView.heightAnchor.constraint(equalToConstant: spacePadding),
            // GPS
            setGPSStackView.topAnchor.constraint(equalTo: chatTeamNameLabel.bottomAnchor, constant: spacePadding),
            setGPSStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setGPSStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setGPSStackView.heightAnchor.constraint(equalToConstant: spacePadding),
            // 市区町村
            prefectureAndCityNameLabel.topAnchor.constraint(equalTo: setGPSLabel.bottomAnchor, constant: spacePadding),
            prefectureAndCityNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            prefectureAndCityNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            prefectureAndCityNameLabel.heightAnchor.constraint(equalToConstant: spacePadding)
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

extension WakeUpCardView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // キーボード入力や、カット/ペースによる変更を防ぐ
             return false
    }
}
