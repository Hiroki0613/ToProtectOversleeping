//
//  WakeUpCommunicateChatVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView
import Instructions


class WakeUpCommunicateChatVC: MessagesViewController {
    var messages = [Message]()
    
    var wakeUpCardTableListVC = WakeUpCardTableListVC()
    var teamRoomName = ""
    var chatRoomNameModel: ChatRoomNameModel?
    var userDataModel: UserDataModel?
//    var chatTableViewIndexPath: Int?
    var chatRoomDocumentId: String?
    var wakeUpSuccessPersonList = [String]()
    
    // TODO:暫定で強制アンラップ
    var currentUser = Sender(senderId: "", displayName: "")
    var otherUser = Sender(senderId: "", displayName: "")
    
    // 一旦ここでaddSnapをさせる
    let db = Firestore.firestore()
    
    // チームに参加しているかを確認するbool
    var isJoinedTeam: Bool = false
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    //コーチビューコントローラー(イントロダクション)を作成
    let coachMarksController = CoachMarksController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "本日の結果", style: .done, target: self, action: #selector(tapSummaryResults))
        // ここの背景にアプリのロゴを入れる？
        view.backgroundColor = .systemGray
        messagesCollectionView.backgroundColor = PrimaryColor.primary.withAlphaComponent(0.5)

        
//        let sendDBModel = SendDBModel()
        
        // TODO: 一旦強制アンラップ
        // 自分
        currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: userDataModel!.name)
        // 他者
        otherUser = Sender(senderId: userDataModel!.uid, displayName: userDataModel!.name)
        
        configureMessageCollectionView()
        configureMessageInputBar()

        configureChatTitleAndCheckedByTheJoinedTeam()
//        title = chatRoomNameModel?.roomName
//        title = teamRoomName
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        UserDefaults.standard.set(true, forKey: UserDefaultsString.isFirstAccessToChat)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        loadMessage(toID: chatRoomDocumentId!)
        
        let center = UNUserNotificationCenter.current()
        print("宏輝_通知pending: ", center.getPendingNotificationRequests(completionHandler: { request in
            print("宏輝_通知request: ",request)
        }))
        
        //TODO: 集計結果を出すために12:00を過ぎていたら、FloatingPanelを半分上に出す。
        //本日の12時に移行を集計させる。
        //1日に1回とするため、UserDefaultsに結果を表示したのちに、
        //今日の日付けを入れて、入っていたらスルーすることにする。
        checkIsFirstTimeInTheDayOpenedThisView()
        showResultPage()
        
        //イントロダクションのdataSourceを実装
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        self.coachMarksController.overlay.blurEffectStyle = .regular
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkTheInstructionModeIsNeed()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.set(false, forKey: UserDefaultsString.isFirstAccessToChat)
        self.coachMarksController.stop(immediately: true)
    }
    
    // instruction
    func checkTheInstructionModeIsNeed() {
        if UserDefaults.standard.bool(forKey: UserDefaultsString.isFirstAccessToChat) == true {
            // 最初にアプリをダウンロードした時に出てくるインストラクション
            self.coachMarksController.start(in: .currentWindow(of: self))
        } else {
            print("宏輝_instructionが全て終了しました")
        }
    }
    
    // 集計画面へ画面遷移
    @objc func tapSummaryResults() {
        print("宏輝_summaryResults")
        let resultWakeUpVC = ResultWakeUpVC()
        resultWakeUpVC.chatRoomDocumentId = self.chatRoomDocumentId
        resultWakeUpVC.wakeUpSuccessPersonList = self.wakeUpSuccessPersonList
//        resultWakeUpVC.teamName = chatRoomNameModel!.roomName
        if configureChatTitleAndCheckedByTheJoinedTeam() == true {

            resultWakeUpVC.teamName = teamRoomName
        } else {
            resultWakeUpVC.teamName = userDataModel!.name
        }
//        resultWakeUpVC.teamName = self.teamRoomName
        print("宏輝_resultWakeUpVC.wakeUpSuccessPersonListAtChat: ",resultWakeUpVC.wakeUpSuccessPersonList)
        present(resultWakeUpVC, animated: true, completion: nil)
    }
    
    
    // 今日初めて、このViewを見ているかを判定
    func checkIsFirstTimeInTheDayOpenedThisView() {
        let calender = Calendar(identifier: .gregorian)

        let date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "wakeUpResultDate"))
        
        print("宏輝_date: ",date)
        if calender.isDateInToday(date) {
            print("宏輝_今日は集計をすでに見ました")
        } else {
            if let createTodayNoonTime = createTodayNoonTime() {
                if createTodayNoonTime < Date() {
                    let resultWakeUpVC = ResultWakeUpVC()
                    resultWakeUpVC.chatRoomDocumentId = self.chatRoomDocumentId
                    resultWakeUpVC.wakeUpSuccessPersonList = self.wakeUpSuccessPersonList
                    if configureChatTitleAndCheckedByTheJoinedTeam() == true {
//                        resultWakeUpVC.teamName = chatRoomNameModel!.roomName
                        resultWakeUpVC.teamName = teamRoomName
                    } else {
                        resultWakeUpVC.teamName = userDataModel!.name
                    }

                    print("宏輝_resultWakeUpVC.wakeUpSuccessPersonListAtChat: ",resultWakeUpVC.wakeUpSuccessPersonList)
                    //今日は集計を見たことをUserDefaultsに記録させておく
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "wakeUpResultDate")
                    present(resultWakeUpVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    //正午移行に、集計結果を見せるように設計
    func showResultPage() {
        if let createTodayNoonTime = createTodayNoonTime() {
            if createTodayNoonTime < Date() {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
//                self.navigationItem.rightBarButtonItem?.tintColor = PrimaryColor.primary
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.navigationItem.rightBarButtonItem?.tintColor = .clear
            }
        }
    }
    
    
    //TODO: 現在はベタ打ちで対応している。ここを自動的に今日の日付が入るように設定する
    //結果を表示する時刻のため、今日の正午を生成
    func createTodayNoonTime() -> Date? {
        /// カレンダーを生成
        let calendar = Calendar(identifier: .gregorian)    // 西暦（gregorian）カレンダー
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        // 本日の１２時を生成
        let todayNoonTime = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 12, minute: 0, second: 0))
        return todayNoonTime
    }
    
    func configureChatTitleAndCheckedByTheJoinedTeam() -> Bool {
        isJoinedTeam = userDataModel?.homeRoomId != userDataModel?.teamChatRoomId
        
        if isJoinedTeam == true {
            title = teamRoomName
            return true
        } else {
            title = userDataModel!.name
            return false
        }
    }
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitle("送信", for: .normal)
        messageInputBar.delegate = self
    }
    
    
    func configureMessageInputBar() {
        let newMessageInputBar = InputBarAccessoryView()
        newMessageInputBar.delegate = self
        newMessageInputBar.isHidden = true
        messageInputBar = newMessageInputBar
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.layer.borderWidth = 0.0
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .systemGray
        messageInputBar.sendButton.setTitleColor(.systemGray, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            PrimaryColor.primary.withAlphaComponent(0.3),
            for: .highlighted
        )
        reloadInputViews()
    }
    
    
    //どこかのチャットルームで開かれているトークを日付順で並べている。
    func loadMessage(toID: String) {
        db.collection("Chats").document(toID).collection("Talk").order(by: "date").addSnapshotListener { snapshot, error in
            if error != nil {
                return
            }
            
            // アプリバージョンごとにif letでunlapさせて
            if let snapShotDoc = snapshot?.documents {
                self.messages = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    print("data: ",data)
                    
                    guard let messageAppVersion = data["messageAppVersion"] as? String else { return }
                    
                    if messageAppVersion == "1.0.1" {
                        if let text = data["text"] as? String,
                           let senderID = data["senderId"] as? String,
                           let displayName = data["displayName"] as? String,
                           let date = data["date"] as? Double,
                           let sendWUMessageType = data["sendWUMessageType"] as? String
                           {
                            
                                // senderはどちらが送ったかを検証する場所idでわけて自分と相手のmessageを２つつくる
                                if senderID == Auth.auth().currentUser?.uid {
                                    
                                    // 自分
                                    self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: displayName)
                                    let message = Message(
                                        sender: self.currentUser,
                                        messageId: senderID,
                                        sentDate: Date(timeIntervalSince1970: date),
                                        kind: .text(text))
                                    self.messages.append(message)
                                    
                                } else {
                                    // 他人
                                    self.otherUser = Sender(senderId: senderID, displayName: displayName)
                                    let message = Message(
                                        sender: self.otherUser,
                                        messageId: senderID,
                                        sentDate: Date(timeIntervalSince1970: date),
                                        kind: .text(text))
                                    print("宏輝_起きたmessage: ",message)
                                    self.messages.append(message)
                                }
                            
                            // まず目が覚めた人をリストに上げる
                            print("宏輝_起きた_sendWUMessageType:", sendWUMessageType)
                            
                            if sendWUMessageType == SendWUMessageType.wakeUpSuccessMessage {
                                let calendar = Calendar(identifier: .gregorian)
                                print("宏輝_起きた時間: ", Date(timeIntervalSince1970: date))
                                
                                let date = Date(timeIntervalSince1970: date)
                                
                                // 今日の日付ならappend
                                if calendar.isDateInToday(date) {
                                    print("宏輝_起きた: ",displayName)
                                    self.wakeUpSuccessPersonList.append(displayName)
                                    print("宏輝_起きたリスト: ", self.wakeUpSuccessPersonList)
                                    let resultWakeUpVC = ResultWakeUpVC()
                                    resultWakeUpVC.wakeUpSuccessPersonList = self.wakeUpSuccessPersonList
                                }
                            }
                        }
                    }
                }
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }
        }
    }
}


// MARK: - MessagesDataSource
extension WakeUpCommunicateChatVC: MessagesDataSource {
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = dateFormatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}


extension WakeUpCommunicateChatVC: MessagesLayoutDelegate {
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 17
    }
    
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension WakeUpCommunicateChatVC: MessagesDisplayDelegate {
    // 送信時間がで出るようになる
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
      return true
    }
    
    
    // 本人、他人で色を変えている
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? PrimaryColor.primary : .systemGray
    }
    
    
    // メッセージが本人か、そうでは無いかで方向を決めて、さらに尻尾も変更している
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
      let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
      
      return .bubbleTail(corner, .curved)
    }
  
    
    // Avaterの画像を入れられる。
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = Avatar(image: UIImage(systemName: "person.fill"), initials: "A")
        avatarView.set(avatar: avatar)
    }
}
// MARK: -InputBarAccessoryViewDelegate
extension WakeUpCommunicateChatVC: InputBarAccessoryViewDelegate {
    
    // 送信ボタンが押されたときに呼ばれる箇所
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.sendButton.startAnimating()
        let sendDBModel = SendDBModel()
        inputBar.inputTextView.text = ""
        print("送信ボタンが押されました")
        
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: chatRoomDocumentId!,
            text: text,
            displayName: userDataModel!.name,
            messageAppVersion: version,
            sendWUMessageType: SendWUMessageType.sendChatMessage
        )

        inputBar.sendButton.stopAnimating()
        
    }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        print("didChangeIntrinsicContentTo")
    }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        print("didSwipeTextViewWith")
    }
}

extension WakeUpCommunicateChatVC: MessageCellDelegate {
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
}

extension WakeUpCommunicateChatVC: CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            var coachMark = coachMarksController.helper.makeCoachMark(for: messagesCollectionView)
            coachMark.isDisplayedOverCutoutPath = true
            return coachMark
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        //吹き出しのビューを作成します
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,    //三角の矢印をつけるか
            arrowOrientation: coachMark.arrowOrientation    //矢印の向き(吹き出しの位置)
        )
        
        if UserDefaults.standard.bool(forKey: UserDefaultsString.isFirstAccessToChat) == true {
            switch index {
            case 0:
                coachViews.bodyView.hintLabel.text = "チャット画面です。\nトーク機能はありません。\n\n起床宣言\n起床したことの通知\nアラーム時間の変更\n\nが表示されます。"
                coachViews.bodyView.nextLabel.text = "OK!"
            default:
                break
            }
        } else {
            switch index {
            default:
                break
            }
        }
        //その他の設定が終わったら吹き出しを返します
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

