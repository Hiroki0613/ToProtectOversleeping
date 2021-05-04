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
    var wakeUpTimeLabel = WUBodyLabel(fontSize: 24)
    var wakeUpTimeTextField = WUTextFields()
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
    var chatTeamNameLabel = WUBodyLabel(fontSize: 24)
    var chatTeamNameTextField = WUTextFields()
    var chatTeamNameStackView = UIStackView(frame: .zero)
    
    // GPSを設定するボタン
    var setGPSLabel = WUBodyLabel(fontSize: 24)
    var setGPSButton = WUButton(backgroundColor: .systemOrange, title: "タップして取得")
    var setGPSStackView = UIStackView(frame: .zero)
    // 地図の表示は要望があったら
    

    // アドレスを格納
    var addressString = ""
    // 住所の表示、プライバシーの保護のために市区町村まで
    var prefectureAndCityNameLabel = WUBodyLabel(fontSize: 20)
    
    
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
        chatTeamNameLabel.text = "チーム名"
        setGPSLabel.text = "住所"
        prefectureAndCityNameLabel.text = "GPSを取得すると、\nここに表示されます"
        
        wakeUpTimeTextField.inputView = datePicker
        wakeUpTimeTextField.delegate = self
    }
    
    
    private func configure() {
        //        translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameStackView.translatesAutoresizingMaskIntoConstraints = false
        setGPSStackView.translatesAutoresizingMaskIntoConstraints = false
        prefectureAndCityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        prefectureAndCityNameLabel.numberOfLines = 0
        
        backgroundColor = .systemBackground
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 60.0
        // 起きる時間をStack
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeLabel)
        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeTextField)
        wakeUpTimeStackView.axis = .vertical
        wakeUpTimeStackView.alignment = .fill
        wakeUpTimeStackView.spacing = 10
        addSubview(wakeUpTimeStackView)
        
        //        addSubview(wakeUpTimeLabel)
        // チャットチーム名をStack
        chatTeamNameStackView.addArrangedSubview(chatTeamNameLabel)
        chatTeamNameStackView.addArrangedSubview(chatTeamNameTextField)
        chatTeamNameStackView.axis = .vertical
        chatTeamNameStackView.alignment = .fill
        chatTeamNameStackView.spacing = 10
        addSubview(chatTeamNameStackView)
        
        //        addSubview(chatTeamNameLabel)
        // GPSセットをStack
        setGPSStackView.addArrangedSubview(setGPSLabel)
        setGPSStackView.addArrangedSubview(setGPSButton)
        setGPSStackView.axis = .vertical
        setGPSStackView.alignment = .fill
//        setGPSStackView.spacing = 10
        addSubview(setGPSStackView)
        
        //        addSubview(setGPSLabel)
        // 市区町村
        addSubview(prefectureAndCityNameLabel)
        
        NSLayoutConstraint.activate([
            //起きる時間
            wakeUpTimeStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
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
}

extension WakeUpCardView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // キーボード入力や、カット/ペースによる変更を防ぐ
             return false
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
}
