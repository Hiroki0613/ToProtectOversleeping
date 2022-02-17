//
//  WakeUpSettingView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit
import MapKit

class WakeUpSettingView: UIView {
    var userDataModel: UserDataModel?
    //チームへの招待ボタン。チームに参加しているときのみ表示
    var setTeamInformationView = UIView(frame: .zero)
//    var inviteButton = WUButton(backgroundColor: PrimaryColor.primary, title: "チームへ招待する")
    var goToChatButton = WUButton(backgroundColor: .clear, title: "チャット画面へ移動")
//    var leaveTeamButton = WUButton(backgroundColor: PrimaryColor.primary, title: "チームから退室する")

    // ユーザー情報
    var setUserInformationView = UIView(frame: .zero)
    
    // ユーザー名の設定
    var setUserNameLabel = WUBodyLabel(fontSize: 18)
    var setUserNameButton = WUButton(backgroundColor: .clear, title: "設定")
    // 自宅のGPS情報取得
    var getGPSAddressLabel = WUBodyLabel(fontSize: 14)
    var getGPSAddressButton = WUButton(backgroundColor: .clear, title: "取得")
    
    // アプリ情報
    var setAppInformationView = UIView(frame: .zero)
    
    // バージョン
    var appVersionLabel = WUBodyLabel(fontSize: 18)
    // ライセンス
    var licenseButton = WUButton(backgroundColor: .clear, title: "ライセンス")
    // ご意見・ご要望
    var opinionsAndRequestsLabel = WUBodyLabel(fontSize: 18)
    var opinionsAndRequestsButton = WUButton(backgroundColor: .clear, title: "送る")
    // アプリの評価
    var evaluationLabel = WUBodyLabel(fontSize: 18)
    var evaluationButton = WUButton(backgroundColor: .clear, title: "送る")
    
//    var isJoinedTeam = false
//    var setTeamInformationViewConstraintHight: CGFloat = 300
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
              
//        let loadDBModel = LoadDBModel()
//        loadDBModel.getUserDataDelegate = self
//        loadDBModel.loadProfileData()
        setAppInformation()
        configureUIView()
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
    
    func configureUIView() {
        configureTeamInformationView()
        configureUserView()
        configureAppView()
        configureDecoration()
    }
    
    func configureTeamInformationView() {
        setTeamInformationView.translatesAutoresizingMaskIntoConstraints = false
//        inviteButton.translatesAutoresizingMaskIntoConstraints = false
        goToChatButton.translatesAutoresizingMaskIntoConstraints = false
//        leaveTeamButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(setTeamInformationView)
        
//        setTeamInformationView.addSubview(inviteButton)
        setTeamInformationView.addSubview(goToChatButton)
//        setTeamInformationView.addSubview(leaveTeamButton)
        
        setTeamInformationView.layer.borderWidth = 2.0
        setTeamInformationView.layer.borderColor = PrimaryColor.primary.cgColor
        
        goToChatButton.layer.borderWidth = 2.0
        goToChatButton.layer.borderColor = PrimaryColor.primary.cgColor
        
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
//        print("宏輝setTeamInformationViewConstraintHight:", setTeamInformationViewConstraintHight)
        
        NSLayoutConstraint.activate([
            setTeamInformationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            setTeamInformationView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setTeamInformationView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            //TODO: チームに入っている時だけ大きく枠をとること
            setTeamInformationView.heightAnchor.constraint(equalToConstant: 100),
            goToChatButton.topAnchor.constraint(equalTo: setTeamInformationView.topAnchor, constant: padding),
            goToChatButton.leadingAnchor.constraint(equalTo: setTeamInformationView.leadingAnchor, constant: padding),
            goToChatButton.trailingAnchor.constraint(equalTo: setTeamInformationView.trailingAnchor, constant: -padding),
            goToChatButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
//            inviteButton.topAnchor.constraint(equalTo: goToChatButton.bottomAnchor, constant: spacePadding),
//            inviteButton.leadingAnchor.constraint(equalTo: setTeamInformationView.leadingAnchor, constant: padding),
//            inviteButton.trailingAnchor.constraint(equalTo: setTeamInformationView.trailingAnchor, constant: -padding),
//            inviteButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
//            leaveTeamButton.topAnchor.constraint(equalTo: inviteButton.bottomAnchor, constant: spacePadding),
//            leaveTeamButton.leadingAnchor.constraint(equalTo: setTeamInformationView.leadingAnchor, constant: padding),
//            leaveTeamButton.trailingAnchor.constraint(equalTo: setTeamInformationView.trailingAnchor, constant: -padding),
//            leaveTeamButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
    
    func configureUserView() {
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
        
        setUserInformationView.layer.borderWidth = 2.0
        setUserInformationView.layer.borderColor = PrimaryColor.primary.cgColor
        
        setUserNameButton.layer.borderWidth = 2.0
        setUserNameButton.layer.borderColor = PrimaryColor.primary.cgColor
        
        getGPSAddressButton.layer.borderWidth = 2.0
        getGPSAddressButton.layer.borderColor = PrimaryColor.primary.cgColor
        
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        NSLayoutConstraint.activate([
            setUserInformationView.topAnchor.constraint(equalTo: self.setTeamInformationView.bottomAnchor, constant: spacePadding),
            setUserInformationView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            setUserInformationView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            setUserInformationView.heightAnchor.constraint(equalToConstant: 200),
            
            setUserNameLabel.topAnchor.constraint(equalTo: setUserInformationView.topAnchor, constant: padding),
            setUserNameLabel.leadingAnchor.constraint(equalTo: setUserInformationView.leadingAnchor, constant: padding),
            setUserNameLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            setUserNameButton.topAnchor.constraint(equalTo: setUserInformationView.topAnchor, constant: padding),
            setUserNameButton.trailingAnchor.constraint(equalTo: setUserInformationView.trailingAnchor, constant: -padding),
            setUserNameButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            setUserNameButton.widthAnchor.constraint(equalToConstant: 80),
            
            getGPSAddressLabel.topAnchor.constraint(equalTo: setUserNameButton.bottomAnchor, constant: spacePadding),
            getGPSAddressLabel.leadingAnchor.constraint(equalTo: setUserInformationView.leadingAnchor, constant: padding),
            getGPSAddressLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            getGPSAddressButton.topAnchor.constraint(equalTo: setUserNameButton.bottomAnchor, constant: spacePadding),
            getGPSAddressButton.trailingAnchor.constraint(equalTo: setUserInformationView.trailingAnchor, constant: -padding),
            getGPSAddressButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            getGPSAddressButton.widthAnchor.constraint(equalToConstant: 80)
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
        
        setAppInformationView.layer.borderWidth = 2.0
        setAppInformationView.layer.borderColor = PrimaryColor.primary.cgColor
        
        opinionsAndRequestsButton.layer.borderWidth = 2.0
        opinionsAndRequestsButton.layer.borderColor = PrimaryColor.primary.cgColor
        
        licenseButton.layer.borderWidth = 2.0
        licenseButton.layer.borderColor = PrimaryColor.primary.cgColor
        
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
            opinionsAndRequestsButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            opinionsAndRequestsButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureDecoration() {
//        setTeamInformationView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
//        setUserInformationView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
//        setAppInformationView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        setTeamInformationView.layer.cornerRadius = 16
        setUserInformationView.layer.cornerRadius = 16
        setAppInformationView.layer.cornerRadius = 16
    }
}

//extension WakeUpSettingView: GetUserDataDelegate {
//    func getUserData(userDataModel: UserDataModel) {
//        self.userDataModel = userDataModel
//
//        isJoinedTeam = self.userDataModel?.homeRoomId != self.userDataModel?.teamChatRoomId
//    }
//}


