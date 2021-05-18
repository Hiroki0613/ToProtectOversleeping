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


struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class WakeUpCommunicateChatVC: MessagesViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    struct UserdataModel {
        var uid = String()
        var name = String()
    }
    
    var userDataModel: UserdataModel?
    var userData = [String: Any]()

    // TODO:暫定で強制アンラップ
    var currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "")
    var otherUser = Sender(senderId: "", displayName: "")
//    let imageView = UIImageView()
//    let blackView = UIView()
    
    var messages = [Message]()
    
    // 一旦ここでaddSnapをさせる
    let db = Firestore.firestore()
    
    lazy var formatter: DateFormatter = {
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
        view.backgroundColor = .systemOrange

        // TODO: 一旦強制アンラップ
        // 自分
        currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: userData["name"] as! String )
        // 他者
//        otherUser = Sender(senderId: userDataModel!.uid, displayName:userDataModel!.name )
        otherUser = Sender(senderId: "1234567", displayName:"宏輝" )
                
//        let items = [
//            makeButton(image: UIImage(named: "album")!).onTextViewDidChange { button, textView in
//                button.isEnabled = textView.text.isEmpty
//            }]
//        messageInputBar.setLeftStackViewWidthConstant(to: 100, animated: true)
//        messageInputBar.setStackViewItems(items, forStack: .left, animated: true)
        
        configureDelegate()
        reloadInputViews()
    }
    
    func configureDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitle("送信", for: .normal)
        messageInputBar.delegate = self
        
        let newMessageInputBar = InputBarAccessoryView()
        newMessageInputBar.delegate = self
        messageInputBar = newMessageInputBar
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.layer.borderWidth = 0.0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        loadMessage()
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
    
    func loadMessage() {
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("chat").order(by: "date").addSnapshotListener { snapshot, error in
            if error != nil {
                return
            }
            if let snapShotDoc = snapshot?.documents {
                self.messages = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let text = data["text"] as? String, let senderID = data["senderID"] as? String,
                       let imageURLString = data["imageURLString"] as? String,
                       let date = data["date"] as? TimeInterval {
                        
                        // senderはどちらが送ったかを検証する場所idでわけて自分と相手のmessageを２つつくる
                        if senderID == Auth.auth().currentUser?.uid {
                            self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: self.userData["name"] as! String)
                            let message = Message(sender: self.currentUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text), userImagePath: imageURLString, date: date, messageImageString: "")
                            self.messages.append(message)
                        } else {
                            self.otherUser = Sender(senderId: senderID, displayName: self.userData["name"] as! String)
                            let message = Message(sender: self.otherUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text), userImagePath: imageURLString, date: date, messageImageString: "")
                            self.messages.append(message)
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
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        print(message.sentDate.debugDescription)
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    


}

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
    
    
}

extension WakeUpCommunicateChatVC: MessagesLayoutDelegate {
    
}

extension WakeUpCommunicateChatVC: MessagesDisplayDelegate {
//    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        print("画像URL")
//        print(message[indexPath.section].messageImageString)
//    }
    
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView
//    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
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
    
}

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
        
        print("送信ボタンが押されました")
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
