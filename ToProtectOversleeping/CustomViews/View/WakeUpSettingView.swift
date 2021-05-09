//
//  WakeUpSettingView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit
import MapKit

class WakeUpSettingView: UIView {
    
    // 起きる時間
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
//    let wakeUpSetAlarmSwitch = UISwitch() //目覚ましのセット
//    var wakeUpTimeTextFieldAndSwitchStackView = UIStackView(frame: .zero)
//    var wakeUpTimeStackView = UIStackView(frame: .zero)
    
    // チャットのチーム名、ワンタイムトークンにて招待制
//    var chatTeamNameLabel = WUBodyLabel(fontSize: 20)
//    var chatTeamNameTextField = WUTextFields()
//    var chatTeamRegistrationButton = WUButton(backgroundColor: .systemOrange, title: "登録")
//    var chatTeamNameAndRegstrationStackView = UIStackView(frame: .zero)
//    var chatTeamNameStackView = UIStackView(frame: .zero)
    
    
    // GPSを設定するボタン
    var setGPSLabel = WUBodyLabel(fontSize: 20)
    var setGPSButton = WUButton(backgroundColor: .systemOrange, title: "タップして取得")
    var setGPSStackView = UIStackView(frame: .zero)
    // 地図の表示は要望があったら
    

    // アドレスを格納
    var addressString = ""
    // 住所の表示、プライバシーの保護のために市区町村まで
    var prefectureAndCityNameLabel = WUBodyLabel(fontSize: 18)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .systemRed
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
//        wakeUpTimeTextField.text = "\(formatter.string(from: datePicker.date))"
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
//        wakeUpTimeLabel.text = "起きる時間"
//        chatTeamNameLabel.text = "チーム名"
        setGPSLabel.text = "住所"
        prefectureAndCityNameLabel.text = "GPSを取得すると、\nここに表示されます"
        
//        wakeUpTimeTextField.inputView = datePicker
//        wakeUpTimeTextField.delegate = self
    }
    
    // ここでGPSを取得
//    @objc func tapSetGPSButton() {
//        wakeUpTimeTextField.resignFirstResponder()
//        chatTeamNameTextField.resignFirstResponder()
//        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
//        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
//    }
    
    
    private func configure() {
        //        translatesAutoresizingMaskIntoConstraints = false
//        wakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpTimeTextField.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpSetAlarmSwitch.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpTimeTextFieldAndSwitchStackView.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpTimeStackView.translatesAutoresizingMaskIntoConstraints = false
//        wakeUpSetAlarmSwitch.isOn = false
        
//        chatTeamNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        chatTeamNameTextField.translatesAutoresizingMaskIntoConstraints = false
//        chatTeamRegistrationButton.translatesAutoresizingMaskIntoConstraints = false
//        chatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
//        chatTeamNameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setGPSStackView.translatesAutoresizingMaskIntoConstraints = false
        prefectureAndCityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        prefectureAndCityNameLabel.numberOfLines = 0
        
        backgroundColor = .systemBackground.withAlphaComponent(0.8)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 20.0
        let labelButtonHightPadding: CGFloat = 70
        
        // 起きる時間をStack
//        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpTimeTextField)
//        wakeUpTimeTextFieldAndSwitchStackView.addArrangedSubview(wakeUpSetAlarmSwitch)
//        wakeUpTimeTextFieldAndSwitchStackView.axis = .horizontal
//        wakeUpTimeTextFieldAndSwitchStackView.alignment = .fill
//        wakeUpTimeTextFieldAndSwitchStackView.spacing = 20
//        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeLabel)
//        wakeUpTimeStackView.addArrangedSubview(wakeUpTimeTextFieldAndSwitchStackView)
//        wakeUpTimeStackView.axis = .vertical
//        wakeUpTimeStackView.alignment = .fill
//        wakeUpTimeStackView.spacing = 10
//        addSubview(wakeUpTimeStackView)
        
        // チャットチーム名をStack
//        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNameTextField)
//        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamRegistrationButton)
//        chatTeamNameAndRegstrationStackView.axis = .horizontal
//        chatTeamNameAndRegstrationStackView.alignment = .fill
//        chatTeamNameAndRegstrationStackView.distribution = .fill
//        chatTeamNameAndRegstrationStackView.spacing = 20
//        chatTeamNameStackView.addArrangedSubview(chatTeamNameLabel)
//        chatTeamNameStackView.addArrangedSubview(chatTeamNameAndRegstrationStackView)
//        chatTeamNameStackView.axis = .vertical
//        chatTeamNameStackView.alignment = .fill
//        chatTeamNameStackView.spacing = 10
//        addSubview(chatTeamNameStackView)
        
        // GPSセットをStack
        setGPSStackView.addArrangedSubview(setGPSLabel)
        setGPSStackView.addArrangedSubview(setGPSButton)
        setGPSStackView.axis = .vertical
        setGPSStackView.alignment = .fill
        setGPSStackView.spacing = 10
        addSubview(setGPSStackView)
        
        // 市区町村
        addSubview(prefectureAndCityNameLabel)
        
        NSLayoutConstraint.activate([
            //起きる時間
//            wakeUpTimeStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
//            wakeUpTimeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            wakeUpTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            wakeUpTimeStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
//            // チャットチーム名
//            chatTeamNameStackView.topAnchor.constraint(equalTo: wakeUpTimeTextFieldAndSwitchStackView.bottomAnchor, constant:  spacePadding),
//            chatTeamNameStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
//            chatTeamNameStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
//            chatTeamNameStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            // GPS
            setGPSStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            setGPSStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setGPSStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setGPSStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            // 市区町村
            prefectureAndCityNameLabel.topAnchor.constraint(equalTo: setGPSButton.bottomAnchor, constant: spacePadding),
            prefectureAndCityNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            prefectureAndCityNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            prefectureAndCityNameLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
}

extension WakeUpSettingView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // キーボード入力や、カット/ペースによる変更を防ぐ
             return false
    }
    
//    override func resignFirstResponder() -> Bool {
//        return true
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
