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
    var wakeUpCardTableListHeaderView = WakeUpCardTableListHeaderView()
    
    var userDataModel: UserDataModel?
    var chatRoomNameModelArray = [ChatRoomNameModel]()
    var chatRoomDocumentIdArray = [String]()
    var chatRoomDocumentIdForSwitch = ""
    var indexNumber = 0
    
    var isJoinedTeam: Bool = false
    
    // 新しいカードを追加
//    var addWakeUpCardButton = WUButton(backgroundColor: PrimaryColor.primary, sfSymbolString: "macwindow.badge.plus")
    
    
    
    // 暫定で機械学習
//    var addWakeMachineLearningButton = WUButton(backgroundColor: PrimaryColor.primary, sfSymbolString: "gear")
    
    
    
    
    
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
        
        isJoinedTeam = userDataModel?.homeRoomId != userDataModel?.teamChatRoomId
        
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        //        title = ""
//        navigationController?.navigationBar.barTintColor = PrimaryColor.primary
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
        tableView.backgroundColor = PrimaryColor.primary
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(WakeUpCardTableListCell.self, forCellReuseIdentifier: WakeUpCardTableListCell.reuseID)
        tableView.register(BlankWakeUpCardTableListCell.self, forCellReuseIdentifier: BlankWakeUpCardTableListCell.reuseID)
        tableView.register(GoalSettingWakeUpCardTableListCell.self, forCellReuseIdentifier: GoalSettingWakeUpCardTableListCell.reuseID)
    }
    
    func configureAddCardButton() {
//        addWakeUpCardButton.translatesAutoresizingMaskIntoConstraints = false
//        addWakeUpCardButton.layer.cornerRadius = 32
//        addWakeUpCardButton.layer.borderColor = UIColor.systemBackground.cgColor
//        addWakeUpCardButton.layer.borderWidth = 3.0
//        addWakeUpCardButton.addTarget(self, action: #selector(goToWakeUpDetailCardVC), for: .touchUpInside)
//        view.addSubview(addWakeUpCardButton)
        
//        addWakeMachineLearningButton.translatesAutoresizingMaskIntoConstraints = false
//        addWakeMachineLearningButton.layer.cornerRadius = 32
//        addWakeMachineLearningButton.layer.borderColor = UIColor.systemBackground.cgColor
//        addWakeMachineLearningButton.layer.borderWidth = 3.0
//        addWakeMachineLearningButton.addTarget(self, action: #selector(goToMachineLearning), for: .touchUpInside)
//        view.addSubview(addWakeMachineLearningButton)
        
        NSLayoutConstraint.activate([
//            addWakeUpCardButton.widthAnchor.constraint(equalToConstant: 64),
//            addWakeUpCardButton.heightAnchor.constraint(equalToConstant: 64),
//            addWakeUpCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            addWakeUpCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
//            addWakeMachineLearningButton.widthAnchor.constraint(equalToConstant: 64),
//            addWakeMachineLearningButton.heightAnchor.constraint(equalToConstant: 64),
//            addWakeMachineLearningButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            addWakeMachineLearningButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
            
            
        ])
//        addWakeUpCardButton.tintColor = .systemBackground
        
        
//        addWakeMachineLearningButton.tintColor = .systemBackground
    }
    
//    @objc func goToWakeUpDetailCardVC() {
//        let setAlarmTimeAndNewRegistrationVC = SetAlarmTimeAndNewRegistrationVC()
//        setAlarmTimeAndNewRegistrationVC.userName = self.userDataModel!.name
//        setAlarmTimeAndNewRegistrationVC.modalPresentationStyle = .overFullScreen
//        setAlarmTimeAndNewRegistrationVC.modalTransitionStyle = .crossDissolve
//        self.present(setAlarmTimeAndNewRegistrationVC, animated: true, completion: nil)
//    }
//
//    @objc func goToMachineLearning() {
//                let checkVendingMachineVC = CheckVendingMachineVC()
//                checkVendingMachineVC.modalPresentationStyle = .overFullScreen
//                checkVendingMachineVC.modalTransitionStyle = .crossDissolve
//                self.present(checkVendingMachineVC, animated: true, completion: nil)
//    }
}


extension WakeUpCardTableListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        // 目標はeditのみ
        if indexPath.row == 0 {
            
            let editGoalSetting = UIContextualAction(style: .normal, title: "目標\nの編集") { action, view, completionHandler in
                print("Editがタップされた")
                print("宏輝__edit")
                
                let editTheGoalSettingVC = EditTheGoalSettingVC()
                self.navigationController?.pushViewController(editTheGoalSettingVC, animated: true)
                completionHandler(true)
            }
            editGoalSetting.backgroundColor = .systemBlue
            // 定義したアクションをセット
            return UISwipeActionsConfiguration(actions: [ editGoalSetting])
            
            
            
            // アラームの編集を定義
        } else {
            
            isJoinedTeam = userDataModel?.homeRoomId != userDataModel?.teamChatRoomId
            
            let editAction = UIContextualAction(style: .normal, title: "アラーム\n修正") { action, view, completionHandler in
                print("Editがタップされた")
                print("宏輝__edit")
                
                let editWakeUpAlarmTimeVC = EditWakeUpAlarmTimeVC()
                editWakeUpAlarmTimeVC.chatRoomDocumentID = self.chatRoomDocumentIdArray[indexPath.row - 1]
                editWakeUpAlarmTimeVC.userName = self.userDataModel!.name
                editWakeUpAlarmTimeVC.teamChatRoomId = self.userDataModel!.teamChatRoomId
                editWakeUpAlarmTimeVC.dayOfTheWeek = self.chatRoomNameModelArray[indexPath.row - 1].dayOfTheWeek
                self.navigationController?.pushViewController(editWakeUpAlarmTimeVC, animated: true)
                
                completionHandler(true)
            }
            
            
            // QRコード作成
            let qrAction = UIContextualAction(style: .normal, title: "招待\nする") { (action, view, completionHandler) in
                print("QRがタップされた")
                
                let wakeUpQrCodeVC = WakeUpQrCodeMakerVC()
//                wakeUpQrCodeVC.invitedDocumentId = self.chatRoomDocumentIdArray[indexPath.row - 1]
                wakeUpQrCodeVC.invitedDocumentId = self.userDataModel!.teamChatRoomId
                self.navigationController?.pushViewController(wakeUpQrCodeVC, animated: true)
                // 実行結果に関わらず記述
                completionHandler(true)
            }
            
            let makeNewTeamAction = UIContextualAction(style: .normal, title: "チーム\n作成") { action, view, completionHandler in
                
                let setNewTeamMateNameVC = SetNewTeamMateNameVC()
                self.navigationController?.pushViewController(setNewTeamMateNameVC, animated: true)
                // 実行結果に関わらず記述
                completionHandler(true)
            }
            
            
            editAction.backgroundColor = .systemBlue
            makeNewTeamAction.backgroundColor = .systemGreen
            qrAction.backgroundColor = .systemGreen
            
            
            if isJoinedTeam == true {
                // 定義したアクションをセット
                return UISwipeActionsConfiguration(actions: [ editAction,qrAction])
            } else {
                // 定義したアクションをセット
                return UISwipeActionsConfiguration(actions: [ editAction,makeNewTeamAction])
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.row == 0 {
            return nil
        } else {
            
            
            
            // 招待されるコードを書く
            
            let makeNewTeamAction = UIContextualAction(style: .normal, title: "招待される") { action, view, completionHandler in
                let setInvitedTeamMateVC = SetInvitedTeamMateVC()
                setInvitedTeamMateVC.userName = self.userDataModel!.name
                self.present(setInvitedTeamMateVC, animated: true, completion: nil)
                // 実行結果に関わらず記述
                completionHandler(true)
            }
            
            
            let leaveTeamAction = UIContextualAction(style: .destructive, title: "退室") { action, view, completionHandler in
                
                let db = Firestore.firestore()
                db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                    "teamChatRoomId": self.userDataModel!.homeRoomId,
                    "teamChatName": self.userDataModel!.name
                ])
                UserDefaults.standard.set(self.userDataModel!.name,forKey: "teamChatName")
                completionHandler(true)
            }
            
            
            makeNewTeamAction.backgroundColor = .systemGreen

            
            if isJoinedTeam == true {
                // 定義したアクションをセット
                return UISwipeActionsConfiguration(actions: [leaveTeamAction])
            } else {
                // 定義したアクションをセット
                return UISwipeActionsConfiguration(actions: [makeNewTeamAction])
            }
        }
    }
}


extension WakeUpCardTableListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = WakeUpCardTableListHeaderView()
        
        if isJoinedTeam {
            wakeUpCardTableListHeaderView.leftSwipeLabel.text = "左スワイプで「目標の変更」、「アラームの編集」、「チームの招待」"
            wakeUpCardTableListHeaderView.rightSwipeLabel.text = "右スワイプで「チーム退会」"
        } else {
            wakeUpCardTableListHeaderView.leftSwipeLabel.text = "左スワイプで「目標の変更」、「アラームの編集」、「チームの作成」"
            wakeUpCardTableListHeaderView.rightSwipeLabel.text = "右スワイプで「チームへの参加」"
        }
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        if isJoinedTeam {
//            return "左スワイプで\nアラームの編集、チームの招待\n右スワイプでチーム退会\nが出来ます"
//        } else {
//            return
//                "左スワイプで\nアラームの編集、チームの作成\n右スワイプでチームへの参加\nが出来ます"
//        }
//
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // セルの数を3つにする。１つ目を平日、２つ目を休日、３つ目を目標メモに変更する。
        //        return self.chatRoomNameModelArray.count
        //        return 2
        print("スイッチの: ", chatRoomNameModelArray.count)
        return self.chatRoomNameModelArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 最初にプレースホルダーを用意する
        // 平日のアラーム
        if  indexPath.row == 0 {
            
            let theGoalSettingText = userDataModel?.theGoalSetting
            
            if theGoalSettingText == "" {
                // 目標
                let cell = tableView.dequeueReusableCell(withIdentifier: BlankWakeUpCardTableListCell.reuseID) as! BlankWakeUpCardTableListCell
                cell.blankCellLabel.text = " 達成したい目標を書いてください\n左スワイプして記入"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: GoalSettingWakeUpCardTableListCell.reuseID) as! GoalSettingWakeUpCardTableListCell
                cell.goalSettingMainLabel.text = theGoalSettingText
                return cell
            }
        } else {
            // 平日、休日、曜日
            if chatRoomNameModelArray.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: BlankWakeUpCardTableListCell.reuseID) as! BlankWakeUpCardTableListCell
                cell.blankCellLabel.text = "平日のアラームをセットしてください\n左スワイプして記入"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WakeUpCardTableListCell.reuseID) as! WakeUpCardTableListCell
                cell.wakeUpSetAlarmSwitch.addTarget(self, action: #selector(tapWakeUpSetAlarmSwitch), for: .touchUpInside)
                cell.wakeUpSetAlarmSwitch.tag = indexPath.row
                cell.setAlarmButton.addTarget(self, action: #selector(tapSetAlarmButton(_:)), for: .touchUpInside)
                cell.setAlarmButton.tag = indexPath.row
                cell.setChatButton.addTarget(self, action: #selector(tapSetChatButton(_:)), for: .touchUpInside)
                cell.setChatButton.tag = indexPath.row
                cell.set(chatRoomNameModel: self.chatRoomNameModelArray[indexPath.row - 1])
                return cell
            }
        }
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
        chatRoomDocumentIdForSwitch = chatRoomDocumentIdArray[sender.tag - 1]
        print("chatRoomDocumentIdForSwitch: ", chatRoomDocumentIdForSwitch)
        print("chatRoomDocumentIdForSwitchArray: ", chatRoomDocumentIdArray)
        
        let sendDBModel = SendDBModel()
        sendDBModel.switchedChatRoomWakeUpAlarm(roomNameId: chatRoomDocumentIdForSwitch, isWakeUpBool: onCheck)
        
        if onCheck {
            print("スイッチの状態はオンです。値: \(onCheck),sender\(sender.tag - 1)")
            // ここでonにすると、目覚ましセット
            alarmSet(identifierString: chatRoomDocumentIdForSwitch)
            // アラームをセットしたことを投稿
//            messageModel.sendMessageToChatDeclarationWakeUpEarly(documentID: chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name, wakeUpTimeText: self.chatRoomNameModelArray[sender.tag - 1].wakeUpTimeText)
            messageModel.sendMessageToChatDeclarationWakeUpEarly(
                documentID: userDataModel!.teamChatRoomId,
                displayName: self.userDataModel!.name,
                dayOfTheWeek: self.chatRoomNameModelArray[sender.tag - 1].dayOfTheWeek,
                wakeUpTimeText: self.chatRoomNameModelArray[sender.tag - 1].wakeUpTimeText)
        } else {
            print("スイッチの状態はオフです。値: \(onCheck),sender\(sender.tag - 1)")
            // ここでoffにすると、目覚まし解除
            clearAlarm(identifiers: chatRoomDocumentIdForSwitch)
//            messageModel.sendMessageToChatAlarmCut(documentID: chatRoomDocumentIdForSwitch, displayName: self.userDataModel!.name)
            
            messageModel.sendMessageToChatAlarmCut(documentID: userDataModel!.teamChatRoomId, displayName: self.userDataModel!.name, dayOfTheWeek: chatRoomNameModelArray[sender.tag - 1].dayOfTheWeek)

        }
    }
    
    @objc func tapSetAlarmButton(_ sender: UIButton) {
        print("tableviewアラームボタンがタップされました: ",sender.tag - 1)
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        
        guard let remakeAlarmTime = remakeAlarmTime(wakeUpTime: Date(timeIntervalSince1970: self.chatRoomNameModelArray[sender.tag - 1].wakeUpTimeDate)) else { return }
        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = remakeAlarmTime
        wakeUpAndCutAlertBySlideVC.authId = Auth.auth().currentUser!.uid
//        wakeUpAndCutAlertBySlideVC.chatRoomDocumentId = chatRoomDocumentIdArray[sender.tag - 1]
        wakeUpAndCutAlertBySlideVC.chatRoomDocumentId = self.userDataModel!.teamChatRoomId
        wakeUpAndCutAlertBySlideVC.userName =  self.userDataModel!.name
        wakeUpAndCutAlertBySlideVC.wakeUpTimeText = self.chatRoomNameModelArray[sender.tag - 1].wakeUpTimeText
        wakeUpAndCutAlertBySlideVC.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
        present(wakeUpAndCutAlertBySlideVC, animated: true, completion: nil)
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
        wakeUpCommunicateChatVC.teamRoomName = UserDefaults.standard.object(forKey: "teamChatName") as! String
        wakeUpCommunicateChatVC.chatRoomNameModel = self.chatRoomNameModelArray[sender.tag - 1]
        wakeUpCommunicateChatVC.userDataModel = self.userDataModel
//        wakeUpCommunicateChatVC.chatRoomDocumentId = self.chatRoomDocumentIdArray[sender.tag - 1]
        wakeUpCommunicateChatVC.chatRoomDocumentId = self.userDataModel!.teamChatRoomId
//        wakeUpCommunicateChatVC.chatTableViewIndexPath = sender.tag - 1
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
        tableView.reloadData()
    }
}


// プロフィール情報を取得
extension WakeUpCardTableListVC: GetUserDataDelegate {
    func getUserData(userDataModel: UserDataModel) {
        self.userDataModel = userDataModel
        tableView.reloadData()
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
