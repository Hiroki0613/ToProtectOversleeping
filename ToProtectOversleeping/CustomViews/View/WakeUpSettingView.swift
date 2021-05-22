//
//  WakeUpSettingView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit
import MapKit

class WakeUpSettingView: UIView {

//    var userInformationCell = UIView()
//    var appInformationCell = UIView()
    
    // ユーザー情報
    var setUserInformationStackView = UIStackView(frame: .zero)
    var setProfileStackView = UIStackView(frame: .zero)
    var getGPSAddressStackView = UIStackView(frame: .zero)
//    var setNotificationStackView = UIStackView(frame: .zero)
    // ユーザー名の設定
    var setUserNameLabel = WUBodyLabel(fontSize: 18)
    var setUserNameButton = WUButton(backgroundColor: .systemOrange, title: "設定")
    // 自宅のGPS情報取得
    var getGPSAddressLabel = WUBodyLabel(fontSize: 18)
    var getGPSAddressButton = WUButton(backgroundColor: .systemOrange, title: "取得")
    // リモート、ローカルのpush通知の設定
//    var setNotificationLabel = WUBodyLabel(fontSize: 18)
//    var setNotificationSwitch = UISwitch()

    
    // アプリ情報
    var setAppInformationStackView = UIStackView(frame: .zero)
    var setOpinionsAndRequestsStackView = UIStackView(frame: .zero)
    var setEvaluationStackView = UIStackView(frame: .zero)
    // バージョン
    var appVersionLabel = WUBodyLabel(fontSize: 18)
    // ライセンス
    var licenseButton = WUButton(backgroundColor: .systemOrange, title: "ライセンス")
    // ご意見・ご要望
    var opinionsAndRequestsLabel = WUBodyLabel(fontSize: 18)
    var opinionsAndRequestsButton = WUButton(backgroundColor: .systemOrange, title: "送る")
    // アプリの評価
    var evaluationLabel = WUBodyLabel(fontSize: 18)
    var evaluationButton = WUButton(backgroundColor: .systemOrange, title: "送る")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUserInformation()
        setAppInformation()
        configureUserView()
        configureAppView()
        configureDecoration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUserInformation() {
        setUserNameLabel.text = "ユーザーネームが未登録です"
        getGPSAddressLabel.text = "自宅の住所が未登録です"
//        setNotificationLabel.text = "通知されます"
    }
    
    private func setAppInformation() {
        appVersionLabel.text = "バージョン　1.0.0"
        opinionsAndRequestsLabel.text = "ご意見・ご要望"
        evaluationLabel.text = "アプリを評価する"
    }
    
    private func configureUserView() {
//        userInformationCell.translatesAutoresizingMaskIntoConstraints = false
        setUserInformationStackView.translatesAutoresizingMaskIntoConstraints = false
        setProfileStackView.translatesAutoresizingMaskIntoConstraints = false
        getGPSAddressStackView.translatesAutoresizingMaskIntoConstraints = false
//        setNotificationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        setUserNameButton.translatesAutoresizingMaskIntoConstraints = false
        getGPSAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        getGPSAddressButton.translatesAutoresizingMaskIntoConstraints = false
//        setNotificationLabel.translatesAutoresizingMaskIntoConstraints = false
//        setNotificationSwitch.translatesAutoresizingMaskIntoConstraints = false
//
//        setNotificationSwitch.isOn = false
        
//        userInformationCell.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        
//        addSubview(userInformationCell)
        
        setUserInformationStackView.axis = .vertical
        setUserInformationStackView.alignment = .center
        setUserInformationStackView.spacing = 20
        addSubview(setUserInformationStackView)
        
        setProfileStackView.addArrangedSubview(setUserNameLabel)
        setProfileStackView.addArrangedSubview(setUserNameButton)
        setProfileStackView.axis = .horizontal
        setProfileStackView.alignment = .center
        setProfileStackView.spacing = 20
        setUserInformationStackView.addArrangedSubview(setProfileStackView)
        
        getGPSAddressStackView.addArrangedSubview(getGPSAddressLabel)
        getGPSAddressStackView.addArrangedSubview(getGPSAddressButton)
        getGPSAddressStackView.axis = .horizontal
        getGPSAddressStackView.alignment = .center
        getGPSAddressStackView.spacing = 20
        setUserInformationStackView.addArrangedSubview(getGPSAddressStackView)
        
//        setNotificationStackView.addArrangedSubview(setNotificationLabel)
//        setNotificationStackView.addArrangedSubview(setNotificationSwitch)
//        setNotificationStackView.axis = .horizontal
//        setNotificationStackView.alignment = .center
//        setNotificationStackView.spacing = 20
//        setUserInformationStackView.addArrangedSubview(setNotificationStackView)
        
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        NSLayoutConstraint.activate([
            setUserInformationStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: spacePadding),
            setUserInformationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setUserInformationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setUserInformationStackView.heightAnchor.constraint(equalToConstant: 270),
            
            setProfileStackView.topAnchor.constraint(equalTo: setUserInformationStackView.topAnchor, constant: padding),
            setProfileStackView.leadingAnchor.constraint(equalTo: setUserInformationStackView.leadingAnchor, constant: padding),
            setProfileStackView.trailingAnchor.constraint(equalTo: setUserInformationStackView.trailingAnchor, constant: -padding),
            setProfileStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            getGPSAddressStackView.topAnchor.constraint(equalTo: setProfileStackView.bottomAnchor, constant: spacePadding),
            getGPSAddressStackView.leadingAnchor.constraint(equalTo: setUserInformationStackView.leadingAnchor, constant: padding),
            getGPSAddressStackView.trailingAnchor.constraint(equalTo: setUserInformationStackView.trailingAnchor, constant: -padding),
            getGPSAddressStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
//            setNotificationStackView.topAnchor.constraint(equalTo: getGPSAddressStackView.bottomAnchor, constant: spacePadding),
//            setNotificationStackView.leadingAnchor.constraint(equalTo: setUserInformationStackView.leadingAnchor, constant: padding),
//            setNotificationStackView.trailingAnchor.constraint(equalTo: setUserInformationStackView.trailingAnchor, constant: -padding),
//            setNotificationStackView.bottomAnchor.constraint(equalTo: setUserInformationStackView.bottomAnchor, constant: -padding)
        ])
        
    }
    
    private func configureAppView() {
//        appInformationCell.translatesAutoresizingMaskIntoConstraints = false
        setAppInformationStackView.translatesAutoresizingMaskIntoConstraints = false
        setOpinionsAndRequestsStackView.translatesAutoresizingMaskIntoConstraints = false
        setEvaluationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        licenseButton.translatesAutoresizingMaskIntoConstraints = false
        opinionsAndRequestsLabel.translatesAutoresizingMaskIntoConstraints = false
        opinionsAndRequestsButton.translatesAutoresizingMaskIntoConstraints = false
        evaluationLabel.translatesAutoresizingMaskIntoConstraints = false
        evaluationButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(setAppInformationStackView)
        setAppInformationStackView.axis = .vertical
        setAppInformationStackView.alignment = .center
        setAppInformationStackView.spacing = 20

        setAppInformationStackView.addArrangedSubview(appVersionLabel)
        
        setAppInformationStackView.addArrangedSubview(licenseButton)
        
        setOpinionsAndRequestsStackView.addArrangedSubview(opinionsAndRequestsLabel)
        setOpinionsAndRequestsStackView.addArrangedSubview(opinionsAndRequestsButton)
        setOpinionsAndRequestsStackView.axis = .horizontal
        setOpinionsAndRequestsStackView.alignment = .center
        setOpinionsAndRequestsStackView.spacing = 20
        setAppInformationStackView.addArrangedSubview(setOpinionsAndRequestsStackView)
        
        setEvaluationStackView.addArrangedSubview(evaluationLabel)
        setEvaluationStackView.addArrangedSubview(evaluationButton)
        setEvaluationStackView.axis = .horizontal
        setEvaluationStackView.alignment = .center
        setEvaluationStackView.spacing = 20
        setAppInformationStackView.addArrangedSubview(setEvaluationStackView)
        
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        NSLayoutConstraint.activate([
            setAppInformationStackView.topAnchor.constraint(equalTo: setUserInformationStackView.bottomAnchor, constant: spacePadding),
            setAppInformationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setAppInformationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setAppInformationStackView.heightAnchor.constraint(equalToConstant: 400),
            
            appVersionLabel.topAnchor.constraint(equalTo: setAppInformationStackView.topAnchor, constant: padding),
            appVersionLabel.leadingAnchor.constraint(equalTo: setAppInformationStackView.leadingAnchor, constant: padding),
            appVersionLabel.trailingAnchor.constraint(equalTo: setAppInformationStackView.trailingAnchor, constant: -padding),
            appVersionLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            licenseButton.topAnchor.constraint(equalTo: appVersionLabel.bottomAnchor, constant: spacePadding),
            licenseButton.leadingAnchor.constraint(equalTo: setAppInformationStackView.leadingAnchor, constant: padding),
            licenseButton.trailingAnchor.constraint(equalTo: setAppInformationStackView.trailingAnchor, constant: -padding),
            licenseButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            setOpinionsAndRequestsStackView.topAnchor.constraint(equalTo: licenseButton.bottomAnchor, constant: spacePadding),
            setOpinionsAndRequestsStackView.leadingAnchor.constraint(equalTo: setAppInformationStackView.leadingAnchor, constant: padding),
            setOpinionsAndRequestsStackView.trailingAnchor.constraint(equalTo: setAppInformationStackView.trailingAnchor, constant: -padding),
            setOpinionsAndRequestsStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            setEvaluationStackView.topAnchor.constraint(equalTo: setOpinionsAndRequestsStackView.bottomAnchor, constant: spacePadding),
            setEvaluationStackView.leadingAnchor.constraint(equalTo: setAppInformationStackView.leadingAnchor, constant: padding),
            setEvaluationStackView.trailingAnchor.constraint(equalTo: setAppInformationStackView.trailingAnchor, constant: -padding),
//            setEvaluationStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
            setEvaluationStackView.bottomAnchor.constraint(equalTo: setAppInformationStackView.bottomAnchor, constant: -padding)
        ])
        
    }
    
    private func configureDecoration() {
        setUserInformationStackView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        setAppInformationStackView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        setUserInformationStackView.layer.cornerRadius = 16
        setAppInformationStackView.layer.cornerRadius = 16
    }
    
}

