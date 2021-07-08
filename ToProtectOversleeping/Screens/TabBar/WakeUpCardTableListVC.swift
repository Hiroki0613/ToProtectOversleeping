//
//  WakeUpCardTableListVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/12.
//

import UIKit
import Firebase

class WakeUpCardTableListVC: UIViewController,AuthLoginDelegate {
   
    var newRegistrationGpsVC = NewRegistrationGpsVC()
    var isLoggedInAtFirebase:Bool = false
    
    let tableView = UITableView()
    var userDataModel: UserDataModel?
    var chatRoomNameModelArray = [ChatRoomNameModel]()
    var chatRoomDocumentIdArray = [String]()
    var chatRoomDocumentIdForSwitch = ""
    var indexNumber = 0
    
    // 新しいカードを追加
    var addWakeUpCardButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "macwindow.badge.plus")
    
    //TODO: デッドコードなので削除
    func authLogin(isLoggedIn: Bool) {
        print("呼ばれた")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaultの値で最初の画面を分岐させる
        if UserDefaults.standard.bool(forKey: "isFirstOpenApp") == true {
            let newRegistrationUserNameVC = NewRegistrationUserNameVC()
            navigationController?.pushViewController(newRegistrationUserNameVC, animated: true)
        } else {
            print("すでに新規登録しています")
        }
 
        
        // FirebaseCrashlyticsでの意図的なクラッシュ手法
//        _ = [0, 1][2]
        
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
        
        let newRegistrationGpsVC = NewRegistrationGpsVC()
        newRegistrationGpsVC.authLoginDelegate = self

        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
//        title = ""
        navigationController?.navigationBar.barTintColor = .systemOrange
//        navigationController?.navigationBar.titleTextAttributes = [
//            // 文字の色
//                .foregroundColor: UIColor.systemBackground
//            ]
        configureTableView()
        configureAddCardButton()
        
        if isLoggedInAtFirebase == UserDefaults.standard.bool(forKey: "isFirstOpenApp") {
            let loadDBModel = LoadDBModel()

            // チャットルームのデータを取得
            loadDBModel.getChatRoomNameDelegate = self
            loadDBModel.loadChatRoomNameData()

            loadDBModel.getUserDataDelegate = self
            loadDBModel.loadProfileData()

            getPermissionLocalPushNotification()
            
            
            //Todo: FirestoreのTimeStamp型を入れること
//            let dateTime = Date()
//            print("宏輝_firedenanai_Date: ",dateTime)
//
//            let nowFireStoreTimeStamp = Timestamp()
//            print("宏輝_fireStoreTimeStamp: ",nowFireStoreTimeStamp)
//               // 2. 日付を取得
//               let dateValue = nowFireStoreTimeStamp.dateValue()
//               print("宏輝_fire_dateValue: \(dateValue)")
//
//               // > dateValue: 2019-06-06 05:17:11 +0000
//
//               // 3. 日付フォーマットも変更
//               let f = DateFormatter()
//               f.locale = Locale(identifier: "ja_JP")
//               f.dateStyle = .long
//               f.timeStyle = .none
//               let date = f.string(from: dateValue)
//               print("宏輝_fire_date: \(date)")
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
        tableView.register(BlankWakeUpCardTableListCell.self, forCellReuseIdentifier: BlankWakeUpCardTableListCell.reuseID)
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
        
//        let checkVendingMachineVC = CheckVendingMachineVC()
//        checkVendingMachineVC.modalPresentationStyle = .overFullScreen
//        checkVendingMachineVC.modalTransitionStyle = .crossDissolve
//        self.present(checkVendingMachineVC, animated: true, completion: nil)
        
        
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
        
        //TODO: editは、indexPathの0,1,2で使う。
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completionHandler in
            print("Editがタップされた")
            
            let editWakeUpAlarmTimeVC = EditWakeUpAlarmTimeVC()
            editWakeUpAlarmTimeVC.chatRoomDocumentID = self.chatRoomDocumentIdArray[indexPath.row]
            editWakeUpAlarmTimeVC.userName = self.userDataModel!.name
            self.navigationController?.pushViewController(editWakeUpAlarmTimeVC, animated: true)
            
            completionHandler(true)
        }

        //TODO: qrは、indexPathの0,1で使う。
        
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
            
            
            //TODO: indexPathが1,2の時のみ、deleteをする。
            
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
        
        // セルの数を3つにする。１つ目を平日、２つ目を休日、３つ目を目標メモに変更する。
//        return self.chatRoomNameModelArray.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 最初にプレースホルダーを用意する
        // 平日のアラーム
        if  indexPath.row == 0 {
            
            if chatRoomNameModelArray.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: BlankWakeUpCardTableListCell.reuseID) as! BlankWakeUpCardTableListCell
                cell.blankCellLabel.text = "平日のアラームをセットしてください\nタップして記入"
                return cell
            } else {
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
            
        }

        // 休日
//        if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: BlankWakeUpCardTableListCell.reuseID) as! BlankWakeUpCardTableListCell
//            cell.blankCellLabel.text = "休日のアラーム\nverUp時に対応します"
//            return cell
//        }

        // 目標
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BlankWakeUpCardTableListCell.reuseID) as! BlankWakeUpCardTableListCell
            cell.blankCellLabel.text = " 達成したい目標を書いてください\nタップして記入"
            return cell
        }
        
        
        
//        if indexPath.row == 1 {
//
//            if chatRoomNameModelArray[indexPath.row] == nil {
//
//            } else {
//
//            }
//
//        }
        
        
        
        
        
        // セルの数を3つにする。１つ目を平日、２つ目を休日、３つ目を目標メモに変更する。
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: WakeUpCardTableListCell.reuseID) as! WakeUpCardTableListCell
//        cell.wakeUpSetAlarmSwitch.addTarget(self, action: #selector(tapWakeUpSetAlarmSwitch), for: .touchUpInside)
//        cell.wakeUpSetAlarmSwitch.tag = indexPath.row
//        cell.setAlarmButton.addTarget(self, action: #selector(tapSetAlarmButton(_:)), for: .touchUpInside)
//        cell.setAlarmButton.tag = indexPath.row
//        cell.setChatButton.addTarget(self, action: #selector(tapSetChatButton(_:)), for: .touchUpInside)
//        cell.setChatButton.tag = indexPath.row
//        cell.set(chatRoomNameModel: self.chatRoomNameModelArray[indexPath.row])
//        return cell
        
        return UITableViewCell()
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
        
        guard let remakeAlarmTime = remakeAlarmTime(wakeUpTime: Date(timeIntervalSince1970: self.chatRoomNameModelArray[sender.tag].wakeUpTimeDate)) else { return }
        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = remakeAlarmTime
        wakeUpAndCutAlertBySlideVC.authId = Auth.auth().currentUser!.uid
        wakeUpAndCutAlertBySlideVC.chatRoomDocumentId = chatRoomDocumentIdArray[sender.tag]
        wakeUpAndCutAlertBySlideVC.userName =  self.userDataModel!.name
        wakeUpAndCutAlertBySlideVC.wakeUpTimeText = self.chatRoomNameModelArray[sender.tag].wakeUpTimeText
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    
    //アラーム時間を当時に変更する
    func remakeAlarmTime(wakeUpTime: Date) -> Date? {
        // 現在時刻を取得
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let alarmHour = calendar.component(.hour, from: wakeUpTime)
        let alarmMinute = calendar.component(.minute, from: wakeUpTime)
        let alarmSecond = calendar.component(.second, from: wakeUpTime)
        
        let remake = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: alarmHour, minute: alarmMinute, second: alarmSecond))
        return remake
    }
    
    @objc func tapSetChatButton(_ sender: UIButton) {
        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
        wakeUpCommunicateChatVC.chatRoomNameModel = self.chatRoomNameModelArray[sender.tag]
        wakeUpCommunicateChatVC.userDataModel = self.userDataModel
        wakeUpCommunicateChatVC.chatRoomDocumentId = self.chatRoomDocumentIdArray[sender.tag]
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
        content.title = "みんなの結果を見てみよう♪"
        content.categoryIdentifier = identifier
        var dateComponents = DateComponents()
        //カレンダー形式で通知
        dateComponents.hour = 12
        dateComponents.minute = 00
        //TODO: 現在はアラームをつけると、繰り返し表示されるように設定した
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
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
//        let messageModel = MessageModel()
//        let sendDBModel = SendDBModel()
//        messageModel.sendMessageToChatWakeUpLate(documentID: self.chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name)
        
        // アラームの削除
//        clearAlarm(identifiers: chatRoomDocumentIdForSwitch)
        // ここでswitchをoffに変更する。
//        sendDBModel.switchedChatRoomWakeUpAlarm(roomNameId: chatRoomDocumentIdForSwitch, isWakeUpBool: false)
//        tableView.reloadData()
        completionHandler([.banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //TODO: ここにチャットの投稿文を書く
//        let messageModel = MessageModel()
//        let sendDBModel = SendDBModel()
//        messageModel.sendMessageToChatWakeUpLate(documentID: self.chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name)
        
        // アラームの削除
//        clearAlarm(identifiers: chatRoomDocumentIdForSwitch)
        // ここでswitchをoffに変更する。
//        sendDBModel.switchedChatRoomWakeUpAlarm(roomNameId: chatRoomDocumentIdForSwitch, isWakeUpBool: false)
//        tableView.reloadData()
        print("バックグラウンド処理")
        completionHandler()
    }
}
