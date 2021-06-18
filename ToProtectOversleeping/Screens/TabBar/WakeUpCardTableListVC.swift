//
//  WakeUpCardTableListVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/12.
//

import UIKit
import Firebase

class WakeUpCardTableListVC: UIViewController {
    
    let tableView = UITableView()
    var userDataModel: UserDataModel?
    var chatRoomNameModelArray = [ChatRoomNameModel]()
    var chatRoomDocumentIdArray = [String]()
    var chatRoomDocumentIdForSwitch = ""
    var indexNumber = 0
    
    // 新しいカードを追加
    var addWakeUpCardButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "macwindow.badge.plus")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        NotificationCenter.default.addObserver(
        //                    self,
        //                    selector: #selector(viewWillEnterForeground(_:)),
        //                    name: UIApplication.willEnterForegroundNotification,
        //                    object: nil)
        //
        //                NotificationCenter.default.addObserver(
        //                    self,
        //                    selector: #selector(viewDidEnterBackground(_:)),
        //                    name: UIApplication.didEnterBackgroundNotification,
        //                    object: nil)
        //
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 無理矢理ログインしています
        Auth.auth().signInAnonymously { result, error in
            guard let _ = error else { return }
        }
        
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        configureTableView()
        configureAddCardButton()
        
        let loadDBModel = LoadDBModel()
        
        // チャットルームのデータを取得
        loadDBModel.getChatRoomNameDelegate = self
        loadDBModel.loadChatRoomNameData()
        
        loadDBModel.getUserDataDelegate = self
        loadDBModel.loadProfileData()
        
        getPermissionLocalPushNotification()
        
        // UserDefaultの値で最初の画面を分岐させる
        if UserDefaults.standard.bool(forKey: "isFirstOpenApp") == true {
            let newRegistrationUserNameVC = NewRegistrationUserNameVC()
//            navigationController?.pushViewController(newRegistrationUserNameVC, animated: true)
            self.present(newRegistrationUserNameVC, animated: true, completion: nil)

        } else {
            print("すでに新規登録しています")
        }
    }
    
    func getPermissionLocalPushNotification() {
        // アプリの通知を許可
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("ローカル通知が許可されました")
                let center = UNUserNotificationCenter.current()
                center.delegate = self
            } else {
                print("ローカル通知が許可されませんでした")
            }
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(WakeUpCardTableListCell.self, forCellReuseIdentifier: WakeUpCardTableListCell.reuseID)
    }
    
    func configureAddCardButton() {
        addWakeUpCardButton.translatesAutoresizingMaskIntoConstraints = false
        addWakeUpCardButton.layer.cornerRadius = 32
        addWakeUpCardButton.layer.borderColor = UIColor.systemBackground.cgColor
        addWakeUpCardButton.layer.borderWidth = 3.0
        addWakeUpCardButton.addTarget(self, action: #selector(goToWakeUpDetailCardVC), for: .touchUpInside)
        view.addSubview(addWakeUpCardButton)
        
        NSLayoutConstraint.activate([
            addWakeUpCardButton.widthAnchor.constraint(equalToConstant: 64),
            addWakeUpCardButton.heightAnchor.constraint(equalToConstant: 64),
            addWakeUpCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addWakeUpCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
        addWakeUpCardButton.tintColor = .systemBackground
    }
    
    @objc func goToWakeUpDetailCardVC() {
        let setAlarmTimeAndNewRegistrationVC = SetAlarmTimeAndNewRegistrationVC()
        setAlarmTimeAndNewRegistrationVC.userName = self.userDataModel!.name
        setAlarmTimeAndNewRegistrationVC.modalPresentationStyle = .overFullScreen
        setAlarmTimeAndNewRegistrationVC.modalTransitionStyle = .crossDissolve
        self.present(setAlarmTimeAndNewRegistrationVC, animated: true, completion: nil)
    }
}


extension WakeUpCardTableListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completionHandler in
            print("Editがタップされた")
            
            let editWakeUpAlarmTimeVC = EditWakeUpAlarmTimeVC()
            editWakeUpAlarmTimeVC.chatRoomDocumentID = self.chatRoomDocumentIdArray[indexPath.row]
            editWakeUpAlarmTimeVC.userName = self.userDataModel!.name
            self.navigationController?.pushViewController(editWakeUpAlarmTimeVC, animated: true)
            
            completionHandler(true)
        }
        
        let qrAction = UIContextualAction(style: .normal, title: "QR") { (action, view, completionHandler) in
            // 編集処理を記述
            print("QRがタップされた")
            let wakeUpQrCodeVC = WakeUpQrCodeMakerVC()
            wakeUpQrCodeVC.invitedDocumentId = self.chatRoomDocumentIdArray[indexPath.row]
            
            self.navigationController?.pushViewController(wakeUpQrCodeVC, animated: true)
            
            // 実行結果に関わらず記述
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        qrAction.backgroundColor = .systemGreen
        
        // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [ editAction,qrAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 削除処理
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            //削除処理を記述
            print("Deleteがタップされた")
            let messageModel = MessageModel()
            messageModel.sendMessageToChatLeaveTheRoom(documentID: self.chatRoomDocumentIdArray[indexPath.row], displayName: self.userDataModel!.name)
            let deleteDBModel = DeleteDBModel()
            self.clearAlarm(identifiers: self.chatRoomDocumentIdArray[indexPath.row])
            deleteDBModel.deleteChatRoomDocumentId(roomNameId: self.chatRoomDocumentIdArray[indexPath.row])
            tableView.reloadData()
            // 実行結果に関わらず記述
            completionHandler(true)
        }
        // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
//    //フッターの色を透明に
//     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//         let footerView: UIView = UIView()
//        footerView.backgroundColor = .systemOrange
//         return footerView
//     }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 200
//    }
}


extension WakeUpCardTableListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatRoomNameModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WakeUpCardTableListCell.reuseID) as! WakeUpCardTableListCell
        cell.wakeUpSetAlarmSwitch.addTarget(self, action: #selector(tapWakeUpSetAlarmSwitch), for: .touchUpInside)
        cell.wakeUpSetAlarmSwitch.tag = indexPath.row
        cell.setAlarmButton.addTarget(self, action: #selector(tapSetAlarmButton(_:)), for: .touchUpInside)
        cell.setAlarmButton.tag = indexPath.row
        cell.setChatButton.addTarget(self, action: #selector(tapSetChatButton(_:)), for: .touchUpInside)
        cell.setChatButton.tag = indexPath.row
        cell.set(chatRoomNameModel: self.chatRoomNameModelArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}


// WakeUpCardTableListCellのボタン関係
extension WakeUpCardTableListVC {
    
    @objc func tapWakeUpSetAlarmSwitch(_ sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        let messageModel = MessageModel()
        
        //chatRoomIDが必要
        chatRoomDocumentIdForSwitch = chatRoomDocumentIdArray[sender.tag]
        print("chatRoomDocumentIdForSwitch: ", chatRoomDocumentIdForSwitch)
        
        let sendDBModel = SendDBModel()
        sendDBModel.switchedChatRoomWakeUpAlarm(roomNameId: chatRoomDocumentIdForSwitch, isWakeUpBool: onCheck)
        
        if onCheck {
            print("スイッチの状態はオンです。値: \(onCheck),sender\(sender.tag)")
            // ここでonにすると、目覚ましセット
            alarmSet(identifierString: chatRoomDocumentIdForSwitch)
            // アラームをセットしたことを投稿
            //            messageModel.sendMessageToChatDeclarationWakeUpEarly(documentID: chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name)
            messageModel.sendMessageToChatDeclarationWakeUpEarly(documentID: chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name, wakeUpTimeText: self.chatRoomNameModelArray[sender.tag].wakeUpTimeText)
        } else {
            print("スイッチの状態はオフです。値: \(onCheck),sender\(sender.tag)")
            // ここでoffにすると、目覚まし解除
            clearAlarm(identifiers: chatRoomDocumentIdForSwitch)
            messageModel.sendMessageToChatAlarmCut(documentID: chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name)
        }
    }
    
    @objc func tapSetAlarmButton(_ sender: UIButton) {
        print("tableviewアラームボタンがタップされました: ",sender.tag)
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = Date(timeIntervalSince1970: self.chatRoomNameModelArray[sender.tag].wakeUpTimeDate)
        wakeUpAndCutAlertBySlideVC.authId = Auth.auth().currentUser!.uid
        wakeUpAndCutAlertBySlideVC.chatRoomDocumentId = chatRoomDocumentIdArray[sender.tag]
        wakeUpAndCutAlertBySlideVC.userName =  self.userDataModel!.name
        wakeUpAndCutAlertBySlideVC.wakeUpTimeText = self.chatRoomNameModelArray[sender.tag].wakeUpTimeText
        print(self.chatRoomNameModelArray[sender.tag].wakeUpTimeDate)
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    @objc func tapSetChatButton(_ sender: UIButton) {
        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
//        let resultWakeUpFloatingVC = ResultWakeUpFloatingVC()
        wakeUpCommunicateChatVC.chatRoomNameModel = self.chatRoomNameModelArray[sender.tag]
        wakeUpCommunicateChatVC.userDataModel = self.userDataModel
        wakeUpCommunicateChatVC.chatRoomDocumentId = self.chatRoomDocumentIdArray[sender.tag]
//        resultWakeUpFloatingVC.chatRoomDocumentId = self.chatRoomDocumentIdArray[sender.tag]
        
        wakeUpCommunicateChatVC.chatTableViewIndexPath = sender.tag
        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
    }
}


// 目覚まし時計のfunc
extension WakeUpCardTableListVC {
    //アラート設定
    func alarmSet(identifierString: String){
        // identifierは一意にするため、Auth.auth()+roomIdにする
        let identifier = Auth.auth().currentUser!.uid + identifierString
        removeAlarm(identifiers: identifier)
        //通知設定
        let content = UNMutableNotificationContent()
        content.title = "通知です"
        content.categoryIdentifier = identifier
        var dateComponents = DateComponents()
        //カレンダー形式で通知
        dateComponents.hour = 12
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //identifierは一意にするため、Auth.auth()+roomIdにする。
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    //アラート設定削除
    func removeAlarm(identifiers:String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifiers])
    }
    
    //アラームを削除
    func clearAlarm(identifiers: String){
        let identifier = Auth.auth().currentUser!.uid + identifiers
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}


// チャット情報を取得して、tableViewをreloadData
extension WakeUpCardTableListVC: GetChatRoomNameDelegate {
    func getChatRoomName(chatRoomNameModel: [ChatRoomNameModel]) {
        self.chatRoomNameModelArray = chatRoomNameModel
        tableView.reloadData()
    }
    
    func getChatDocumentId(chatRoomDocumentId: [String]) {
        self.chatRoomDocumentIdArray = chatRoomDocumentId
    }
}


// プロフィール情報を取得
extension WakeUpCardTableListVC: GetUserDataDelegate {
    func getUserData(userDataModel: UserDataModel) {
        self.userDataModel = userDataModel
    }
}


extension WakeUpCardTableListVC: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //TODO: ここにチャットの投稿文を書く
        let messageModel = MessageModel()
        let sendDBModel = SendDBModel()
        messageModel.sendMessageToChatWakeUpLate(documentID: self.chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name)
        
        // アラームの削除
        clearAlarm(identifiers: chatRoomDocumentIdForSwitch)
        // ここでswitchをoffに変更する。
        sendDBModel.switchedChatRoomWakeUpAlarm(roomNameId: chatRoomDocumentIdForSwitch, isWakeUpBool: false)
        tableView.reloadData()
        completionHandler([.banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //TODO: ここにチャットの投稿文を書く
        let messageModel = MessageModel()
        let sendDBModel = SendDBModel()
        messageModel.sendMessageToChatWakeUpLate(documentID: self.chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name)
        
        // アラームの削除
        clearAlarm(identifiers: chatRoomDocumentIdForSwitch)
        // ここでswitchをoffに変更する。
        sendDBModel.switchedChatRoomWakeUpAlarm(roomNameId: chatRoomDocumentIdForSwitch, isWakeUpBool: false)
        tableView.reloadData()
        print("バックグラウンド処理")
        completionHandler()
    }
}
