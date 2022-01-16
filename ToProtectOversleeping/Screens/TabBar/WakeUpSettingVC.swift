//
//  WakeUpSettingVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/15.
//

import UIKit
import KeychainSwift
import Firebase

class WakeUpSettingVC: UIViewController {
    
    //keychainのデフォルトセッティング。見つけやすいように共通のprefixを実装。
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKeychain)
    
    var settingDataModel: SettingDataModel?
    
    let scrollView = UIScrollView()
    var wakeUpSettingView = WakeUpSettingView()
    var wakeUpSettingWithTeamView = WakeUpSettingWithTeamView()
    
    var userDataModel: UserDataModel?
    var chatRoomNameModelArray = [ChatRoomNameModel]()
    var chatRoomDocumentIdArray = [String]()
    
    var isJoinedTeam: Bool = false
    var isLoggedInAtFirebase:Bool = false
    
    var advertiseSpaceFrameView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.addBackground(name: "orange")
        configureAdvertiseView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

//        configureAdvertiseView()
       
        self.tabBarController?.tabBar.isHidden = false
        
        configureUI()
        
        if isLoggedInAtFirebase == UserDefaults.standard.bool(forKey: "isFirstOpenApp") {
    
            // チャットルームのデータを取得
            let loadDBModel = LoadDBModel()
            loadDBModel.getChatRoomNameDelegate = self
            loadDBModel.getSettingDataDelegate = self
            loadDBModel.getUserDataDelegate = self
            loadDBModel.loadProfileData()
            loadDBModel.loadSettingMode()
            loadDBModel.loadChatRoomNameData()
            
            
        }
        
        
//        let loadDBModel = LoadDBModel()
//        loadDBModel.getSettingDataDelegate = self
//        loadDBModel.loadSettingMode()
//        loadDBModel.getUserDataDelegate = self
//        loadDBModel.loadProfileData()
//        loadDBModel.getChatRoomNameDelegate = self
//        loadDBModel.loadChatRoomNameData()
    }
    
    private func setUserSinglePersonInformation() {
        
        let checkUserNameLabel = UserDefaults.standard.object(forKey: "userName") as! String
        
        if checkUserNameLabel == "NoName777" {
            wakeUpSettingView.setUserNameLabel.text = "ユーザーネームが未登録です"
        } else {
            wakeUpSettingView.setUserNameLabel.text = "ユーザネーム\n\(checkUserNameLabel)"
        }
        
        let checkAddress = keychain.get(Keys.myAddress) ?? "未登録"
        
        if checkAddress == "未登録" {
            wakeUpSettingView.getGPSAddressLabel.text = "自宅の住所が未登録です"
        } else {
            wakeUpSettingView.getGPSAddressLabel.text = "住所\n\(checkAddress)"
        }
        
        print("宏輝_wakeUpSettingViewSingle_住所: ", wakeUpSettingView.getGPSAddressLabel.text)
    }
    
    
    private func setUserInformationWithTeam() {
        
        let checkUserNameLabel = UserDefaults.standard.object(forKey: "userName") as! String
        
        if checkUserNameLabel == "NoName777" {
            wakeUpSettingWithTeamView.setUserNameLabel.text = "ユーザーネームが未登録です"
        } else {
            wakeUpSettingWithTeamView.setUserNameLabel.text = "ユーザネーム\n\(checkUserNameLabel)"
        }
        
        let checkAddress = keychain.get(Keys.myAddress) ?? "未登録"
        
        if checkAddress == "未登録" {
            wakeUpSettingWithTeamView.getGPSAddressLabel.text = "自宅の住所が未登録です"
        } else {
            wakeUpSettingWithTeamView.getGPSAddressLabel.text = "住所\n\(checkAddress)"
        }
        
        print("宏輝_wakeUpSettingViewTeam_住所: ", wakeUpSettingWithTeamView.getGPSAddressLabel.text)
    }
    
    // 個人の時のView
    func configureSinglePersonAddTarget() {
//        wakeUpSettingView.inviteButton.addTarget(self, action: #selector(tapInviteButton), for: .touchUpInside)
        wakeUpSettingView.goToChatButton.addTarget(self, action: #selector(tapGoToChatButton), for: .touchUpInside)
//        wakeUpSettingView.leaveTeamButton.addTarget(self, action: #selector(tapLeaveTeamButton), for: .touchUpInside)
        wakeUpSettingView.setUserNameButton.addTarget(self, action: #selector(tapSetUserNameButton), for: .touchUpInside)
        wakeUpSettingView.getGPSAddressButton.addTarget(self, action: #selector(tapGetGPSAddressButton), for: .touchUpInside)
        wakeUpSettingView.licenseButton.addTarget(self, action: #selector(tapLicenseButton), for: .touchUpInside)
        wakeUpSettingView.opinionsAndRequestsButton.addTarget(self, action: #selector(tapOpinionsAndRequestsButton), for: .touchUpInside)
        wakeUpSettingView.evaluationButton.addTarget(self, action: #selector(tapEvaluationButton), for: .touchUpInside)
    }
    
    // チームの時のView
    func configureAddTargetWithTeam() {
        wakeUpSettingWithTeamView.inviteButton.addTarget(self, action: #selector(tapInviteButton), for: .touchUpInside)
        wakeUpSettingWithTeamView.goToChatButton.addTarget(self, action: #selector(tapGoToChatButton), for: .touchUpInside)
        wakeUpSettingWithTeamView.leaveTeamButton.addTarget(self, action: #selector(tapLeaveTeamButton), for: .touchUpInside)
        wakeUpSettingWithTeamView.setUserNameButton.addTarget(self, action: #selector(tapSetUserNameButton), for: .touchUpInside)
        wakeUpSettingWithTeamView.getGPSAddressButton.addTarget(self, action: #selector(tapGetGPSAddressButton), for: .touchUpInside)
        wakeUpSettingWithTeamView.licenseButton.addTarget(self, action: #selector(tapLicenseButton), for: .touchUpInside)
        wakeUpSettingWithTeamView.opinionsAndRequestsButton.addTarget(self, action: #selector(tapOpinionsAndRequestsButton), for: .touchUpInside)
        wakeUpSettingWithTeamView.evaluationButton.addTarget(self, action: #selector(tapEvaluationButton), for: .touchUpInside)
    }
    
    @objc func tapInviteButton() {
        //TODO: チームに入っている時だけ表示
        print("inviteButtonが押されました")
        let wakeUpQrCodeVC = WakeUpQrCodeMakerVC()
        wakeUpQrCodeVC.invitedDocumentId = self.userDataModel!.teamChatRoomId
        self.navigationController?.pushViewController(wakeUpQrCodeVC, animated: true)
    }
    
    @objc func tapGoToChatButton() {
        print("goToChatButtonが押されました")
        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
        wakeUpCommunicateChatVC.teamRoomName = UserDefaults.standard.object(forKey: "teamChatName") as! String
        wakeUpCommunicateChatVC.userDataModel = self.userDataModel
        wakeUpCommunicateChatVC.chatRoomDocumentId = self.userDataModel!.teamChatRoomId
        
        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
    }
    
    @objc func tapLeaveTeamButton() {
        //TODO: チームに入っている時だけ表示
        //TODO: アラートで退室しても良いかを確認すること
        print("leaveTeamButtonが押されました")
        let db = Firestore.firestore()
        db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
            "teamChatRoomId": self.userDataModel!.homeRoomId,
            "teamChatName": self.userDataModel!.name
        ])
        UserDefaults.standard.set(self.userDataModel!.name, forKey: "teamChatName")
        
        //TODO: アラートで退室したことを伝えること
    }
    
    
    @objc func tapSetUserNameButton() {
        print("setUserNameButtonが押されました")
        let registerNameVC = RegisterNameVC()
        navigationController?.pushViewController(registerNameVC, animated: true)
    }
    
    @objc func tapGetGPSAddressButton() {
        print("getGPSAddressButtonが押されました")
        let getGpsAddressVC = GetGpsAddressVC()
        navigationController?.pushViewController(getGpsAddressVC, animated: true)
    }
    
    // 設定画面へ遷移
    @objc func tapLicenseButton() {
        print("licenseButtonが押されました")
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
          return
        }
        if UIApplication.shared.canOpenURL(settingsUrl)  {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            })
          }
          else  {
            UIApplication.shared.openURL(settingsUrl)
          }
        }
    }
    
    @objc func tapOpinionsAndRequestsButton() {
        
        guard let urlString = settingDataModel?.contact else { return }
        guard let url = URL(string: urlString) else { return }
        self.presentSafariVC(with: url)
    }
    
    @objc func tapEvaluationButton() {
        print("evaluationButtonが押されました")
    }
    
    
    
    private func configureUI() {
        
        if isJoinedTeam == false {
            //一人の時のView
            configureSinglePersonView()
            configureSinglePersonAddTarget()
            setUserSinglePersonInformation()
//            configureAdvertiseView()
            wakeUpSettingView.isHidden = false
            wakeUpSettingWithTeamView.isHidden = true
            wakeUpSettingWithTeamView.removeFromSuperview()
        } else {
            //チームの時のView
            configureViewWithTeam()
            configureAddTargetWithTeam()
            setUserInformationWithTeam()
//            configureAdvertiseView()
            wakeUpSettingView.isHidden = true
            wakeUpSettingWithTeamView.isHidden = false
            wakeUpSettingView.removeFromSuperview()
        }
    }
    
    private func configureHiddenView() {
        if isJoinedTeam == false {
            //一人の時のView
            configureSinglePersonView()
            configureSinglePersonAddTarget()
            setUserSinglePersonInformation()
//            configureAdvertiseView()
            wakeUpSettingView.isHidden = false
            wakeUpSettingWithTeamView.isHidden = true
            wakeUpSettingWithTeamView.removeFromSuperview()
        } else {
            //チームの時のView
            configureViewWithTeam()
            configureAddTargetWithTeam()
            setUserInformationWithTeam()
//            configureAdvertiseView()
            wakeUpSettingView.isHidden = true
            wakeUpSettingWithTeamView.isHidden = false
            wakeUpSettingView.removeFromSuperview()
        }
    }
    
    
    //個人の時のView
    private func configureSinglePersonView() {
        view.addSubview(scrollView)
        wakeUpSettingView.frame = view.bounds
        scrollView.addSubview(wakeUpSettingView)
        wakeUpSettingView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            wakeUpSettingView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            wakeUpSettingView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            wakeUpSettingView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            wakeUpSettingView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            wakeUpSettingView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            //TODO: チームに入っている時だけ枠を大きく取ること
            wakeUpSettingView.heightAnchor.constraint(equalToConstant: 950)
        ])
    }
    
   
    
    private func configureViewWithTeam() {
        view.addSubview(scrollView)
        wakeUpSettingWithTeamView.frame = view.bounds
        scrollView.addSubview(wakeUpSettingWithTeamView)
        wakeUpSettingWithTeamView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            wakeUpSettingWithTeamView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            wakeUpSettingWithTeamView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            wakeUpSettingWithTeamView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            wakeUpSettingWithTeamView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            wakeUpSettingWithTeamView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            //TODO: チームに入っている時だけ枠を大きく取ること
            wakeUpSettingWithTeamView.heightAnchor.constraint(equalToConstant: 950)
        ])
    }
    
    private func configureAdvertiseView() {
        advertiseSpaceFrameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(advertiseSpaceFrameView)
        advertiseSpaceFrameView.addBlurToView(alpha: 0.5)
        
        NSLayoutConstraint.activate([
            advertiseSpaceFrameView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            advertiseSpaceFrameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            advertiseSpaceFrameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            advertiseSpaceFrameView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension WakeUpSettingVC: GetSettingDataDelegate {
    func getSettingData(settingDataModel: SettingDataModel) {
        self.settingDataModel = settingDataModel
    }
}

extension WakeUpSettingVC: GetUserDataDelegate {
    func getUserData(userDataModel: UserDataModel) {
        self.userDataModel = userDataModel
        
        isJoinedTeam = self.userDataModel?.homeRoomId != self.userDataModel?.teamChatRoomId
        
        print("宏輝_isJoinedTeamAtSettingData: ", isJoinedTeam)

        wakeUpSettingWithTeamView.removeFromSuperview()
        wakeUpSettingView.removeFromSuperview()
        
        if isJoinedTeam == false {
            //一人の時のView
            configureSinglePersonView()
            configureSinglePersonAddTarget()
            setUserSinglePersonInformation()
//            configureAdvertiseView()
            wakeUpSettingView.isHidden = false
            wakeUpSettingWithTeamView.isHidden = true
            wakeUpSettingWithTeamView.removeFromSuperview()
        } else {
            //チームの時のView
            configureViewWithTeam()
            configureAddTargetWithTeam()
            setUserInformationWithTeam()
//            configureAdvertiseView()
            wakeUpSettingView.isHidden = true
            wakeUpSettingWithTeamView.isHidden = false
            wakeUpSettingView.removeFromSuperview()
        }
        
//        loadView()
//        self.viewDidLoad()
    }
}

extension WakeUpSettingVC: GetChatRoomNameDelegate {
    func getChatRoomName(chatRoomNameModel: [ChatRoomNameModel]) {
        self.chatRoomNameModelArray = chatRoomNameModel
        print("宏輝_chatRoomNameModelArray: ", chatRoomNameModelArray)
    }
    
    func getChatDocumentId(chatRoomDocumentId: [String]) {
        self.chatRoomDocumentIdArray = chatRoomDocumentId
        print("宏輝_chatRoomDocumentIdArray: ", chatRoomDocumentIdArray)
    }
}
