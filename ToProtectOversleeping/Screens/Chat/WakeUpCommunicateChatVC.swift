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
import FloatingPanel



class WakeUpCommunicateChatVC: MessagesViewController {
    var messages = [Message]()
    
    var wakeUpCardTableListVC = WakeUpCardTableListVC()
    
    var chatRoomNameModel: ChatRoomNameModel?
    var userDataModel: UserDataModel?
    var chatTableViewIndexPath: Int?
    var chatRoomDocumentId: String?
    
    var wakeUpSuccessPersonList = [String]()
    
    var fpc: FloatingPanelController!
    
    var resultWakeUpVC = ResultWakeUpVC()
    
    // TODO:暫定で強制アンラップ
    var currentUser = Sender(senderId: "", displayName: "")
    var otherUser = Sender(senderId: "", displayName: "")
    
    // 一旦ここでaddSnapをさせる
    let db = Firestore.firestore()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        wakeUpCardTableListVC.loadMessageDelegate = self
        // ここの背景にアプリのロゴを入れる？
        view.backgroundColor = .systemGray
        messagesCollectionView.backgroundColor = .systemOrange.withAlphaComponent(0.5)

        print("chatRoomNameModel: ",chatRoomNameModel)
        print("userDataModel: ",userDataModel)
        print("chatTableViewIndexPath: ", chatTableViewIndexPath)
        print("chatRoomDocumentId: ", chatRoomDocumentId)
        
        let sendDBModel = SendDBModel()
        
        resultWakeUpVC.getArrayOFWakeUpSuccessPersonListDelegate = self
        // TODO: 一旦強制アンラップ
        // 自分
        currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: userDataModel!.name)

        // 他者
        otherUser = Sender(senderId: userDataModel!.uid, displayName: userDataModel!.name)
        
        configureMessageCollectionView()
        configureMessageInputBar()
//        title = "トーク"
        title = chatRoomNameModel?.roomName
        
        configureFloatingPanel()
        
        //TODO: 集計結果を出すために12:00を過ぎていたら、FloatingPanelを半分上に出す。
        //本日の12時に移行を集計させる。
        
        
        reloadInputViews()
    }
    
    
    func configureMessageCollectionView() {
//        wakeUpCardTableListVC.sendWakeUpReportToChatDelegate = self
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
        messageInputBar = newMessageInputBar
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.layer.borderWidth = 0.0
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .systemGray
        messageInputBar.sendButton.setTitleColor(.systemGray, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.systemOrange.withAlphaComponent(0.3),
            for: .highlighted
        )
        reloadInputViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        loadMessage(toID: chatRoomDocumentId!)
        
        let center = UNUserNotificationCenter.current()
        print("宏輝_通知pending: ", center.getPendingNotificationRequests(completionHandler: { request in
            print("宏輝_通知request: ",request)
        }))
        
        let resultWakeUpVC = ResultWakeUpVC()
        resultWakeUpVC.wakeUpSuccessPersonList = self.wakeUpSuccessPersonList
    }
    
    
    
    
    
    // 部屋の名前を習得
//    func loadRoomName(indexPath: Int) {
//        var roomNameModelArray = [ChatRoomNameModel]()
//        db.collection("Chats").addSnapshotListener { snapshot, error in
//            if let snapShotDoc = snapshot?.documents {
//                for doc in snapShotDoc {
//                    let data = doc.data()
//                    let roomNameModel = ChatRoomNameModel(roomName: data["roomName"] as! String)
//                    roomNameModelArray.append(roomNameModel)
//                }
//            }
//        }
//    }
    
    
//    //どこかのチャットルームで開かれているトークを日付順で並べている。
//    func loadMessage(toID: String) {
//        db.collection("Chats").document(toID).collection("Talk").order(by: "date").addSnapshotListener { snapshot, error in
//            if error != nil {
//                return
//            }
//
//            // アプリバージョンごとにif letでunlapさせて
//            if let snapShotDoc = snapshot?.documents {
//                self.messages = []
//                for doc in snapShotDoc {
//                    let data = doc.data()
//                    print("data: ",data)
//
//                    guard let messageAppVersion = data["messageAppVersion"] as? String else { return }
//
//                    if messageAppVersion == "1.0.0" {
//                        if let text = data["text"] as? String,
//                           let senderID = data["senderId"] as? String,
//                           let displayName = data["displayName"] as? String,
//                           let date = data["date"] as? Double,
//                           let sendWUMessageType = data["sendWUMessageType"] as? String
//                           {
//
//                                // senderはどちらが送ったかを検証する場所idでわけて自分と相手のmessageを２つつくる
//                                if senderID == Auth.auth().currentUser?.uid {
//
//                                    // 自分
//                                    self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: displayName)
//                                    let message = Message(
//                                        sender: self.currentUser,
//                                        messageId: senderID,
//                                        sentDate: Date(timeIntervalSince1970: date),
//                                        kind: .text(text))
//                                    self.messages.append(message)
//
//                                } else {
//                                    // 他人
//                                    self.otherUser = Sender(senderId: senderID, displayName: displayName)
//                                    let message = Message(
//                                        sender: self.otherUser,
//                                        messageId: senderID,
//                                        sentDate: Date(timeIntervalSince1970: date),
//                                        kind: .text(text))
//                                    self.messages.append(message)
//                                }
//
//                            // まず目が覚めた人をリストに上げる
//                            if sendWUMessageType == SendWUMessageType.wakeUpSuccessMessage {
//                                let calendar = Calendar(identifier: .gregorian)
//                                print("宏輝_起きた時間: ", Date(timeIntervalSince1970: date))
//
//                                let date = Date(timeIntervalSince1970: date)
////                                let yesterday = date.addingTimeInterval(-60 * 60 * 24)
//
//                                // 今日の日付ならappend
//                                if calendar.isDateInToday(date) {
//                                    print("宏輝_起きた: ",displayName)
//                                    self.wakeUpSuccessPersonList.append(displayName)
//                                    print("宏輝_起きたリスト: ", self.wakeUpSuccessPersonList)
//                                    let resultWakeUpVC = ResultWakeUpVC()
//                                    resultWakeUpVC.wakeUpSuccessPersonList = self.wakeUpSuccessPersonList
//
//
//                                }
//                            }
//                        }
//                    }
//                }
//                self.messagesCollectionView.reloadData()
//                self.messagesCollectionView.scrollToLastItem()
//            }
//        }
//    }
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
        return isFromCurrentSender(message: message) ? .systemOrange : .systemGray
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


extension WakeUpCommunicateChatVC: FloatingPanelControllerDelegate {
    
    func configureFloatingPanel() {
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.layout = CustomFloatingPanelLayout()
        fpc.surfaceView.backgroundColor = .clear
        fpc.surfaceView.layer.cornerRadius = 16
        
        let contentVC = ResultWakeUpVC()
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
    }
}

extension WakeUpCommunicateChatVC: GetArrayOFWakeUpSuccessPersonListDelegate {
    func getArrayOfWakeUpSuccessPersonList() -> [String] {
        let resultWakeUpVC = ResultWakeUpVC()
        resultWakeUpVC.wakeUpSuccessPersonList = self.wakeUpSuccessPersonList
        return self.wakeUpSuccessPersonList
    }
}

extension WakeUpCommunicateChatVC: LoadMessageDelegate {
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
    
                        if messageAppVersion == "1.0.0" {
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
                                        self.messages.append(message)
                                    }
    
                                // まず目が覚めた人をリストに上げる
                                if sendWUMessageType == SendWUMessageType.wakeUpSuccessMessage {
                                    let calendar = Calendar(identifier: .gregorian)
                                    print("宏輝_起きた時間: ", Date(timeIntervalSince1970: date))
    
                                    let date = Date(timeIntervalSince1970: date)
    //                                let yesterday = date.addingTimeInterval(-60 * 60 * 24)
    
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
