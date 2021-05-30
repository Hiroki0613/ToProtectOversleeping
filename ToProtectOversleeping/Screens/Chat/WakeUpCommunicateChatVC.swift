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


class WakeUpCommunicateChatVC: MessagesViewController {
    var messages = [Message]()
    
//    var userDataModel = UserDataModel(name: <#String#>, uid: <#String#>, appVersion: <#String#>, isWakeUpBool: <#Bool#>)
//    var userDataModel = UserDataModel(uid: "55555", name: "渋谷")
    var sendDBModel = SendDBModel()
//    var userData = [String: Any]()
    var userData = ["name": "六本木"]

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
        // ここの背景にアプリのロゴを入れる？
        view.backgroundColor = .systemGray
        messagesCollectionView.backgroundColor = .systemOrange.withAlphaComponent(0.5)

        // TODO: 一旦強制アンラップ
        // 自分
        //TODO: userData["name"] as! Stringが繋がっていない。 ここはユーザー名を別のFireStore or UserDefaultsから取ってくる必要がある。
//        currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: userData["name"] as! String )
        currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "宏輝")

        
        // 他者
        //TODO: userDataModelが繋がっていない。 ここはFireStoreの一覧リストからとる感じ? 構造がわかっていなかった・・・。
//        otherUser = Sender(senderId: userDataModel.uid, displayName:userDataModel.name )
        
        
        
//        otherUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "近藤")
//        otherUser = Sender(senderId: "777", displayName: "宏輝2")
        
        configureMessageCollectionView()
        configureMessageInputBar()
        title = "トーク"
        reloadInputViews()
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        loadMessage(indexPath: 0)
    }
    
    
    // ここで部屋のdocumentIDが揃う
    func loadRoomDocumentID(indexPath: Int) {
        
        db.collection("Chats").addSnapshotListener { snapshot, error in
            guard let _ = error else { return }
            if let snapshotDoc = snapshot?.documents {
                for doc in snapshotDoc {
                    print("doc.documentID: ", doc.documentID)
                    var docIDArray = [String]()
                    docIDArray.append(doc.documentID)
                }
            }
        }
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
    
    
    //どこかのチャットルームで開かれているトークを日付順で並べている。
    func loadMessage(indexPath: Int) {
        db.collection("Chats").document().collection("talk").order(by: "date").addSnapshotListener { snapshot, error in
            if error != nil {
                return
            }
            if let snapShotDoc = snapshot?.documents {
                self.messages = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let text = data["text"] as? String, let senderID = data["senderID"] as? String,let date = data["date"] as? TimeInterval
                       {
                        // senderはどちらが送ったかを検証する場所idでわけて自分と相手のmessageを２つつくる
                        if senderID == Auth.auth().currentUser?.uid {
                            self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: self.userData["name"] as! String)
//                            let message = Message(text: , messageId: UUID().uuidString, date: Date())
                            let message = Message(sender: self.currentUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text))
                            self.messages.append(message)
                        } else {
                            self.otherUser = Sender(senderId: senderID, displayName: self.userData["name"] as! String)
//                            let message = Message(text: text, messageId: UUID().uuidString, date: Date())
                            let message = Message(sender: self.otherUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text))
                            self.messages.append(message)
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
        
        
        //TODO: toIDのuserDataModel、displayNameのuserData["name"]が繋がっていない。
//        sendDBModel.sendMessage(senderID: Auth.auth().currentUser!.uid, toID: userDataModel.name, text: text, displayName: userData["name"] as! String)
        
        
        
//        sendDBModel.sendMessage(senderID: Auth.auth().currentUser!.uid, toID: "1234567", text: text, displayName: "宏輝だよ")
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
