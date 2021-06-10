//
//  WakeUpCardTableListVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/12.
//

import UIKit
import Firebase

//protocol SendWakeUpReportToChatDelegate {
//    func sendWakeUpReport()
//}

class WakeUpCardTableListVC: UIViewController {
    
    let tableView = UITableView()
//    var wakeUpCardTableListCell = WakeUpCardTableListCell()
//    var settingLists: [SettingList] = []
//    var chatRoomNameModel:ChatRoomNameModel?
    var userDataModel: UserDataModel?
    var chatRoomNameModelArray = [ChatRoomNameModel]()
    var chatRoomDocumentIdArray = [String]()
    
//    var sendWakeUpReportToChatDelegate: SendWakeUpReportToChatDelegate?
        
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
        
        // UserDefaultの値で最初の画面を分岐させる
        if UserDefaults.standard.bool(forKey: "isFirstOpenApp") == false {
            configureTableView()
            configureAddCardButton()
            
            let loadDBModel = LoadDBModel()
            
            // チャットルームのデータを取得
            loadDBModel.getChatRoomNameDelegate = self
            loadDBModel.loadChatRoomNameData()

            loadDBModel.getUserDataDelegate = self
            loadDBModel.loadProfileData()
            
           getPermissionLocalPushNotification()
            
        } else {
            let newRegistrationUserNameVC = NewRegistrationUserNameVC()
            navigationController?.pushViewController(newRegistrationUserNameVC, animated: true)
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

//        // アプリのローカル通知内容
//        let content: UNMutableNotificationContent = UNMutableNotificationContent()
//        content.title = "WakeUp!"
//        content.body = "チャットに投稿しておきました😁"
//
//        // 毎日正午にアラームを通知する
//        var notificationTime = DateComponents()
//        notificationTime.hour = 23
//        notificationTime.minute = 17
//        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("ローカル通知成功")
//            }
//        }

    }
    
    func configureTableView() {
//        let tableView = UITableView(frame: view.frame)
//        let tableView = UITableView(frame: CGRect(x: 20, y: 0, width: view.frame.size.width - 40, height: view.frame.size.height))
//        let tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
//        tableView.backgroundColor = .systemOrange
        tableView.frame = view.bounds
//        tableView.rowHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.allowsSelection = false
//        tableView.delaysContentTouches = false
        tableView.separatorStyle = .none
        
        tableView.register(WakeUpCardTableListCell.self, forCellReuseIdentifier: WakeUpCardTableListCell.reuseID)
        
    }
    
    func configureAddCardButton() {
        addWakeUpCardButton.translatesAutoresizingMaskIntoConstraints = false
        addWakeUpCardButton.layer.cornerRadius = 40
        addWakeUpCardButton.layer.borderColor = UIColor.systemBackground.cgColor
        addWakeUpCardButton.layer.borderWidth = 3.0
        addWakeUpCardButton.addTarget(self, action: #selector(goToWakeUpDetailCardVC), for: .touchUpInside)
        view.addSubview(addWakeUpCardButton)
        
        NSLayoutConstraint.activate([
            addWakeUpCardButton.widthAnchor.constraint(equalToConstant: 80),
            addWakeUpCardButton.heightAnchor.constraint(equalToConstant: 80),
            addWakeUpCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addWakeUpCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        addWakeUpCardButton.tintColor = .systemBackground
    }
    
    
    @objc func goToWakeUpDetailCardVC() {
        let setAlarmTimeAndNewRegistrationVC = SetAlarmTimeAndNewRegistrationVC()
        setAlarmTimeAndNewRegistrationVC.modalPresentationStyle = .overFullScreen
        setAlarmTimeAndNewRegistrationVC.modalTransitionStyle = .crossDissolve
        self.present(setAlarmTimeAndNewRegistrationVC, animated: true, completion: nil)
    }
}

extension WakeUpCardTableListVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("タップされました: ", indexPath.row)
//    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 編集処理
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            // 編集処理を記述
            print("Editがタップされた")
            let wakeUpQrCodeVC = WakeUpQrCodeMakerVC()
            wakeUpQrCodeVC.invitedDocumentId = self.chatRoomDocumentIdArray[indexPath.row]
            
            self.navigationController?.pushViewController(wakeUpQrCodeVC, animated: true)
            
            // 実行結果に関わらず記述
            completionHandler(true)
        }

           // 削除処理
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
              //削除処理を記述
              print("Deleteがタップされた")

              // 実行結果に関わらず記述
              completionHandler(true)
            }

            // 定義したアクションをセット
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
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
        
//        indexNumber = indexPath.row
//        print("tableviewチャットボタン_cellForRowAt: ", indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = .blue
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
//        view.tintColor = .red
//    }
    
}


// WakeUpCardTableListCellのボタン関係
extension WakeUpCardTableListVC {
//    @objc func tapChatTeamInvitationButton(_ sender: UIButton) {
//        print("tableview招待するボタンがタップされました: ", sender.tag)
//        let wakeUpQrCodeVC = WakeUpQrCodeMakerVC()
//        navigationController?.pushViewController(wakeUpQrCodeVC, animated: true)
//    }
    
    @objc func tapWakeUpSetAlarmSwitch(_ sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        let messageModel = MessageModel()

        
        //chatRoomIDが必要
        let chatRoomDocumentIdForSwitch = chatRoomDocumentIdArray[sender.tag]
        print("chatRoomDocumentIdForSwitch: ", chatRoomDocumentIdForSwitch)
        
        let sendDBModel = SendDBModel()
        sendDBModel.switchedChatRoomWakeUpAlarm(roomNameId: chatRoomDocumentIdForSwitch, isWakeUpBool: onCheck)
        
        
        if onCheck {
            print("スイッチの状態はオンです。値: \(onCheck),sender\(sender.tag)")
            // ここでonにすると、目覚ましセット
            alarmSet(identifierString: chatRoomDocumentIdForSwitch)
            
            // アラームをセットしたことを投稿
            messageModel.sendMessageToChatDeclarationWakeUpEarly(documentID: chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name)
            
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
        print(self.chatRoomNameModelArray[sender.tag].wakeUpTimeDate)
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    @objc func tapSetChatButton(_ sender: UIButton) {
        print("tableviewチャットボタンがタップされました: ", sender.tag)
        print("tableviewチャットボタン sender.tag: ", sender.tag)
        print("tableviewチャットボタン indexNumber: ", indexNumber)
        
//        indexNumber = sender.tag
        
        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
        wakeUpCommunicateChatVC.chatRoomNameModel = self.chatRoomNameModelArray[sender.tag]
//        wakeUpCommunicateChatVC.chatRoomNameModel = self.chatRoomNameModelArray[indexNumber]
        wakeUpCommunicateChatVC.userDataModel = self.userDataModel
        wakeUpCommunicateChatVC.chatRoomDocumentId = self.chatRoomDocumentIdArray[sender.tag]
//        wakeUpCommunicateChatVC.chatRoomDocumentId = self.chatRoomDocumentIdArray[indexNumber]
        wakeUpCommunicateChatVC.chatTableViewIndexPath = sender.tag
//        wakeUpCommunicateChatVC.chatTableViewIndexPath = indexNumber
        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
    }
}

// 目覚まし時計のfunc
extension WakeUpCardTableListVC {
    //アラート設定
    func alarmSet(identifierString: String){
        // identifierは一位にするため、Auth.auth()+roomIdにする
        let identifier = Auth.auth().currentUser!.uid + identifierString
        removeAlarm(identifiers: identifier)

        //通知設定
        let content = UNMutableNotificationContent()
        content.title = "通知です"
        
        content.categoryIdentifier = identifier
        var dateComponents = DateComponents()
        
        //近藤　カレンダー形式で通知
        dateComponents.hour = 1
        dateComponents.minute = 33
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //TODO: identifierは一位にするため、Auth.auth()+roomIdにする。
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
        messageModel.sendMessageToChatWakeUpLate(documentID: self.chatRoomDocumentIdArray[indexNumber], displayName: self.userDataModel!.name)
//        self.sendWakeUpReportToChatDelegate?.sendWakeUpReport()
        completionHandler([.banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("バックグラウンド処理")
        completionHandler()
    }
    
    
}
