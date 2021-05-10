//
//  WakeUpSettingView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit
import MapKit

class WakeUpSettingView: UIView {
    
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
        settingInformation()
        configure()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dateChange() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
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
        setGPSLabel.text = "住所"
        prefectureAndCityNameLabel.text = "GPSを取得すると、\nここに表示されます"
    }
    
    private func configure() {
        setGPSStackView.translatesAutoresizingMaskIntoConstraints = false
        prefectureAndCityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        prefectureAndCityNameLabel.numberOfLines = 0
        
        backgroundColor = .systemBackground.withAlphaComponent(0.8)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 20.0
        let labelButtonHightPadding: CGFloat = 70
        
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
