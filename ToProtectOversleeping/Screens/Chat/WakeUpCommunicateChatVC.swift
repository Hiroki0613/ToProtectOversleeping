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

//class WakeUpCommunicateChatVC: MessagesViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
class WakeUpCommunicateChatVC: MessagesViewController {
    
    var messages = [Message]()
    
    var userDataModel: UserDataModel?
    var sendDBModel = SendDBModel()
    var userData = [String: Any]()

    // TODO:暫定で強制アンラップ
    var currentUser = Sender(senderId: "", displayName: "")
    var otherUser = Sender(senderId: "", displayName: "")
//    let imageView = UIImageView()
//    let blackView = UIView()
    

    
    // 一旦ここでaddSnapをさせる
    let db = Firestore.firestore()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    
//    var attachImage: UIImage?
//    var attachImageString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ここの背景にアプリのロゴを入れる？
        view.backgroundColor = .systemGray
        messagesCollectionView.backgroundColor = .systemOrange.withAlphaComponent(0.5)

        // TODO: 一旦強制アンラップ
        // 自分
//        currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: userData["name"] as! String )
        currentUser = Sender(senderId: "1234567", displayName: "近藤" )
        
        // 他者
//        otherUser = Sender(senderId: userDataModel!.uid, displayName:userDataModel!.name )
        otherUser = Sender(senderId: "7654321", displayName:"宏輝" )
                
//        let items = [
//            makeButton(image: UIImage(named: "album")!).onTextViewDidChange { button, textView in
//                button.isEnabled = textView.text.isEmpty
//            }]
//        messageInputBar.setLeftStackViewWidthConstant(to: 100, animated: true)
//        messageInputBar.setStackViewItems(items, forStack: .left, animated: true)
        
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
//        let newMessageInputBar = InputBarAccessoryView()
//        newMessageInputBar.delegate = self
//        messageInputBar = newMessageInputBar
//        messageInputBar.separatorLine.isHidden = true
//        messageInputBar.inputTextView.layer.borderWidth = 0.0
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
//        loadMessage()
        
        
//        self.currentUser = Sender(senderId: "1234", displayName: "hiroki")
//        let message1 = Message(sender: self.currentUser, messageId: "1234", sentDate: Date(timeIntervalSince1970: 1.0), kind: .text("日本語を話す"), userImagePath: "", date: 1.0, messageImageString: "")
//        self.currentUser = Sender(senderId: "1234", displayName: "hiroki")
//        let message2 = Message(sender: self.currentUser, messageId: "1234", sentDate: Date(timeIntervalSince1970: 1.0), kind: .text("日本語を話す"), userImagePath: "", date: 1.0, messageImageString: "")
//        self.currentUser = Sender(senderId: "1234", displayName: "hiroki")
//        let message3 = Message(sender: self.currentUser, messageId: "1234", sentDate: Date(timeIntervalSince1970: 1.0), kind: .text("日本語を話す"), userImagePath: "", date: 1.0, messageImageString: "")
//        self.currentUser = Sender(senderId: "1234", displayName: "hiroki")
//        let message4 = Message(sender: self.currentUser, messageId: "1234", sentDate: Date(timeIntervalSince1970: 1.0), kind: .text("日本語を話す"), userImagePath: "", date: 1.0, messageImageString: "")
        
        
//        let message1 = Message(text: "文章を入力しています。", user: currentUser, messageId: UUID().uuidString, date: Date())
//        let message2 = Message(text: "文章文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。", user: currentUser, messageId: UUID().uuidString, date: Date())
//        let message3 = Message(text: "文章文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。", user: otherUser, messageId: UUID().uuidString, date: Date())
//        let message4 = Message(text: "文章文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。", user: currentUser, messageId: UUID().uuidString, date: Date())
//        let message5 = Message(text: "文章文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。", user: currentUser, messageId: UUID().uuidString, date: Date())
//        let message6 = Message(text: "文章文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。", user: otherUser, messageId: UUID().uuidString, date: Date())
//        let message7 = Message(text: "文章文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。文章を入力しています。", user: currentUser, messageId: UUID().uuidString, date: Date())
//        self.messages.append(message1)
//        self.messages.append(message2)
//        self.messages.append(message3)
//        self.messages.append(message4)
//        self.messages.append(message5)
//        self.messages.append(message6)
//        self.messages.append(message7)
//
//
        
        
//        self.messages = []
//        message = Message(sender: "1234567", messageId: "56790", sentDate: Date(timeIntervalSince1970: date), kind: .text("日本語"), userImagePath: "", date: date, messageImageString: "")
    }
    
//    func makeButton(image: UIImage) -> InputBarButtonItem {
//        return InputBarButtonItem()
//            .configure{
//                $0.spacing = .fixed(10)
//                $0.image = image.withRenderingMode(.alwaysTemplate)
//
//                $0.setSize(CGSize(width: 30, height: 30), animated: true)
//            }.onSelected {
//                $0.tintColor = .systemOrange
//                print("チャットの送信ボタンをタップしました")
//                self.openCamera()
//            }.onDeselected {
//                $0.tintColor = .systemGray
//            }
//    }
    
//    func openCamera() {
//        let sourceType: UIImagePickerController.SourceType = .photoLibrary
//
//        // カメラが利用可能かチェック
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//            // インスタンスの作成
//            let cameraPicker = UIImagePickerController()
//            cameraPicker.sourceType = sourceType
//            cameraPicker.delegate = self
//            cameraPicker.allowsEditing = true
//            present(cameraPicker, animated: true, completion: nil)
//        } else {
//
//        }
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[.editedImage] {
//            attachImage = pickedImage
//            let sendDBModel = SendDBModel()
//            sendDBModel.getAttachProtocol = self
//
//            if attachImage != nil {
//                sendDBModel.sendImageData()
//            }
//        }
//    }
    
//    func loadMessage() {
//        db.collection("Users").document("hirokiChat").collection("chat").order(by: "date").addSnapshotListener { snapshot, error in
//            if error != nil {
//                return
//            }
//            if let snapShotDoc = snapshot?.documents {
//                self.messages = []
//                for doc in snapShotDoc {
//                    let data = doc.data()
//                    //                    if let text = data["text"] as? String, let senderID = data["senderID"] as? String,
//                    //                       let imageURLString = data["imageURLString"] as? String,
//                    //                       let date = data["date"] as? TimeInterval {
//
//                    if let text = data["text"] as? String, let senderID = data["senderID"] as? String,
//                       let date = data["date"] as? TimeInterval {
//                        // senderはどちらが送ったかを検証する場所idでわけて自分と相手のmessageを２つつくる
//                        if senderID == Auth.auth().currentUser?.uid {
//                            self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: self.userData["name"] as! String)
//                            //                            let message = Message(sender: self.currentUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text), userImagePath: imageURLString, date: date, messageImageString: "")
//                            let message = Message(sender: self.currentUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text))
//                            self.messages.append(message)
//                        } else {
//                            self.otherUser = Sender(senderId: senderID, displayName: self.userData["name"] as! String)
//                            //                            let message = Message(sender: self.otherUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text), userImagePath: imageURLString, date: date, messageImageString: "")
//                            let message = Message(sender: self.otherUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text))
//                            self.messages.append(message)
//                        }
//                    }
//                }
//                self.messagesCollectionView.reloadData()
//                self.messagesCollectionView.scrollToLastItem()
//            }
//
//        }
//    }
    
    // ここで部屋のdocumentIDが揃う
    func loadRoomName() {
        db.collection("Chats").addSnapshotListener { snapshot, error in
            guard let error = error else { return }
            if let snapshotDoc = snapshot?.documents {
                for doc in snapshotDoc {
                    print(doc.documentID)
                    var docIDArray = [String]()
                    docIDArray.append(doc.documentID)
                }
            }
        }
    }
    
    
    
    func loadMessage(indexPath: Int) {
        db.collection("Chats").document().collection("chat").order(by: "date").addSnapshotListener { snapshot, error in
            if error != nil {
                return
            }
            if let snapShotDoc = snapshot?.documents {
                self.messages = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let text = data["text"] as? String, let senderID = data["senderID"] as? String
                       {

                        // senderはどちらが送ったかを検証する場所idでわけて自分と相手のmessageを２つつくる
                        if senderID == Auth.auth().currentUser?.uid {
                            self.currentUser = Sender(senderId: senderID, displayName: self.userData["name"] as! String)
//                            let message = Message(text: text, messageId: UUID().uuidString, date: Date())
//                            self.messages.append(message)
                        } else {
                            self.otherUser = Sender(senderId: senderID, displayName: self.userData["name"] as! String)
//                            let message = Message(text: text, messageId: UUID().uuidString, date: Date())
//                            self.messages.append(message)
                        }
                    }
                }
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }

        }
    }

    
    
//    func getImageByUrl(url: String) -> UIImage {
//        let url = URL(string: url)
//        do {
//            let data = try Data(contentsOf: url!)
//            return UIImage(data: data)!
//        } catch let err {
//            print("Error:", err.localizedDescription)
//        }
//        return UIImage()
//    }
    
    // メッセージの下に文字を表示(日付)
//    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        print(message.sentDate.debugDescription)
//        let dateString = formatter.string(from: message.sentDate)
//        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
//    }
        
    func sendMessage(senderID:String,text: String, user: String, messageID: String, date: Date) {
        self.db.collection("Users").document(senderID).collection("chat").document(messageID).setData(["text": text as Any, "user": currentUser,"messageID": messageID ,"date": Date().timeIntervalSince1970]
        )
        
//        self.db.collection("Users").document("7654321").collection("chat").document(messageID).setData(["text": text as Any, "user": otherUser as Any, "messageID": messageID,"date": Date().timeIntervalSince1970]
//        )
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
    
//    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        return NSAttributedString(string: "既読", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),NSAttributedString.Key.foregroundColor: UIColor.darkGray])
//    }
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
    
    
    
//    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//      return .zero
//    }
    
//    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//        return CGSize(width: 0, height: 8)
//    }
//
//    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//      return 0
//    }
    
}

extension WakeUpCommunicateChatVC: MessagesDisplayDelegate {
//    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        print("画像URL")
//        print(message[indexPath.section].messageImageString)
//    }
    
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView
//    }
    
//    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 16
//    }
//
//    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 16
//    }
    
    // 送信時間がで出るようになる
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
      return true
    }
    
    // 本人、他人で色を変えている
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
      // 1
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
//        inputBar.sendButton.startAnimating()
//        let sendDBModel = SendDBModel()
//        sendDBModel.getAttachProtocol = self
//        inputBar.inputTextView.text = ""
//
//        // 画像がなかったとき場合の処理
//        sendDBModel.sendMessage(senderID: Auth.auth().currentUser!.uid, toID:(userDataModel?.uid)!, text:text, displayName: userData["name"] as! String, imageURLString: userData["profileImageString"] as! String)
//        inputBar.sendButton.stopAnimating()
//        sendDBModel.sendMessage()
        print("送信ボタンが押されました")
        inputBar.sendButton.startAnimating()
//        var sendDBModel = SendDBModel(senderID: "", toID: "", text: "", displayName: "", imageUrlString: "")
        
        sendMessage(senderID: Auth.auth().currentUser!.uid, text: text, user: "currentuser", messageID: "1234567", date: Date())
        inputBar.inputTextView.text = ""
//        sendDBModel.sendMessage(senderID: Auth.auth().currentUser!.uid,toID:(userDataModel?.uid)!, text: text, displayName: userData["name"] as! String, imageUrlString: userData["profileImageString"] as! String)
        
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
