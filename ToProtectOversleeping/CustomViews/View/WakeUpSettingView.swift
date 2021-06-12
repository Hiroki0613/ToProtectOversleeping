//
//  WakeUpSettingView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit
import MapKit

class WakeUpSettingView: UIView {

    // ユーザー情報
    var setUserInformationView = UIView(frame: .zero)
    
    // ユーザー名の設定
    var setUserNameLabel = WUBodyLabel(fontSize: 18)
    var setUserNameButton = WUButton(backgroundColor: .systemOrange, title: "設定")
    // 自宅のGPS情報取得
    var getGPSAddressLabel = WUBodyLabel(fontSize: 18)
    var getGPSAddressButton = WUButton(backgroundColor: .systemOrange, title: "取得")
    
    // アプリ情報
    var setAppInformationView = UIView(frame: .zero)
    
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
        setAppInformation()
        configureUserView()
        configureAppView()
        configureDecoration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setAppInformation() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        appVersionLabel.text = "アプリバージョン\n\n\(version)"
        opinionsAndRequestsLabel.text = "ご意見・ご要望"
        evaluationLabel.text = "アプリを評価する"
    }
    
    private func configureUserView() {
        setUserInformationView.translatesAutoresizingMaskIntoConstraints = false
        setUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        setUserNameButton.translatesAutoresizingMaskIntoConstraints = false
        getGPSAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        getGPSAddressButton.translatesAutoresizingMaskIntoConstraints = false
        setUserNameLabel.numberOfLines = 2
        getGPSAddressLabel.numberOfLines = 3
        
        addSubview(setUserInformationView)
        
        setUserInformationView.addSubview(setUserNameLabel)
        setUserInformationView.addSubview(setUserNameButton)
        setUserInformationView.addSubview(getGPSAddressLabel)
        setUserInformationView.addSubview(getGPSAddressButton)
        
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        NSLayoutConstraint.activate([
            setUserInformationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            setUserInformationView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setUserInformationView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setUserInformationView.heightAnchor.constraint(equalToConstant: 200),
            
            setUserNameLabel.topAnchor.constraint(equalTo: setUserInformationView.topAnchor, constant: padding),
            setUserNameLabel.leadingAnchor.constraint(equalTo: setUserInformationView.leadingAnchor, constant: padding),
            setUserNameLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            setUserNameButton.topAnchor.constraint(equalTo: setUserInformationView.topAnchor, constant: padding),
            setUserNameButton.trailingAnchor.constraint(equalTo: setUserInformationView.trailingAnchor, constant: -padding),
            setUserNameButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            getGPSAddressLabel.topAnchor.constraint(equalTo: setUserNameButton.bottomAnchor, constant: spacePadding),
            getGPSAddressLabel.leadingAnchor.constraint(equalTo: setUserInformationView.leadingAnchor, constant: padding),
            getGPSAddressLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            getGPSAddressButton.topAnchor.constraint(equalTo: setUserNameButton.bottomAnchor, constant: spacePadding),
            getGPSAddressButton.trailingAnchor.constraint(equalTo: setUserInformationView.trailingAnchor, constant: -padding),
            getGPSAddressButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
    
    private func configureAppView() {
        setAppInformationView.translatesAutoresizingMaskIntoConstraints = false
        
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        licenseButton.translatesAutoresizingMaskIntoConstraints = false
        opinionsAndRequestsLabel.translatesAutoresizingMaskIntoConstraints = false
        opinionsAndRequestsButton.translatesAutoresizingMaskIntoConstraints = false
        evaluationLabel.translatesAutoresizingMaskIntoConstraints = false
        evaluationButton.translatesAutoresizingMaskIntoConstraints = false
        
        appVersionLabel.numberOfLines = 3
        addSubview(setAppInformationView)
        setAppInformationView.addSubview(appVersionLabel)
        setAppInformationView.addSubview(licenseButton)
        setAppInformationView.addSubview(opinionsAndRequestsLabel)
        setAppInformationView.addSubview(opinionsAndRequestsButton)
        
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60.0
        
        NSLayoutConstraint.activate([
            setAppInformationView.topAnchor.constraint(equalTo: setUserInformationView.bottomAnchor, constant: spacePadding),
            setAppInformationView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setAppInformationView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setAppInformationView.heightAnchor.constraint(equalToConstant: 300),
            
            appVersionLabel.topAnchor.constraint(equalTo: setAppInformationView.topAnchor, constant: padding),
            appVersionLabel.leadingAnchor.constraint(equalTo: setAppInformationView.leadingAnchor, constant: padding),
            appVersionLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            licenseButton.topAnchor.constraint(equalTo: appVersionLabel.bottomAnchor, constant: spacePadding),
            licenseButton.leadingAnchor.constraint(equalTo: setAppInformationView.leadingAnchor, constant: padding),
            licenseButton.trailingAnchor.constraint(equalTo: setAppInformationView.trailingAnchor, constant: -padding),
            licenseButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            opinionsAndRequestsLabel.topAnchor.constraint(equalTo: licenseButton.bottomAnchor, constant: spacePadding),
            opinionsAndRequestsLabel.leadingAnchor.constraint(equalTo: setAppInformationView.leadingAnchor, constant: padding),
            opinionsAndRequestsLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            opinionsAndRequestsButton.topAnchor.constraint(equalTo: licenseButton.bottomAnchor, constant: spacePadding),
            opinionsAndRequestsButton.trailingAnchor.constraint(equalTo: setAppInformationView.trailingAnchor, constant: -padding),
            opinionsAndRequestsButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
    
    private func configureDecoration() {
        setUserInformationView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        setAppInformationView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        setUserInformationView.layer.cornerRadius = 16
        setAppInformationView.layer.cornerRadius = 16
    }
}

