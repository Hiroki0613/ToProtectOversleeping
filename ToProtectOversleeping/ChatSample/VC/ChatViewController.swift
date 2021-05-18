////
////  ChatViewController.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/05/16.
////
//
//import UIKit
//import Firebase
//import MessageKit
//import FirebaseFirestore
//
//final class ChatViewController: MessagesViewController {
//
//  private let db = Firestore.firestore()
//  private var reference: CollectionReference?
//    
//  private var messages: [Message] = []
//  private var messageListener: ListenerRegistration?
//  
//  private let user: User
//  private let channel: Channel
//  
//  deinit {
//    messageListener?.remove()
//  }
//  
//  init(user: User, channel: Channel) {
//    self.user = user
//    self.channel = channel
//    super.init(nibName: nil, bundle: nil)
//
//    title = channel.name
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    print("chat_viewDidRoad")
//
//    // もしユーザーデータが無かったら(ログインしていなかったら)
//    guard let id = channel.id else {
//      navigationController?.popViewController(animated: true)
//      return
//    }
//    
//    reference = db.collection(["channels", id, "thread"].joined(separator: "/"))
//    
//    //TODO: fireStoreに関しての質問
//    // なぜViewDidRoadのaddSnapshotListinerが呼ばれるのか？通常はviewDidRoadは一度しか呼ばれないはず
//    messageListener = reference?.addSnapshotListener({ (querySnapshot, error) in
//      print("chat_addSnapShotListiener")
//      guard let snapshot = querySnapshot else {
//        print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
//        return
//      }
//
//      snapshot.documentChanges.forEach { (change) in
////        self.handleDocumentChange(change)
//        print("chat_HandleDocumentChange")
//      }
//    })
//    
//
//
//    
//    
//    navigationItem.largeTitleDisplayMode = .never
//    
//    
//    //TODO: ここを変えることでキーボードが上がったり下がったりする？
//    maintainPositionOnKeyboardFrameChanged = true
//    
//    
//    // MessageKitのプロパティの設定
//    messageInputBar.inputTextView.tintColor = .primary
//    messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
//    
//    messageInputBar.delegate = self
//    messagesCollectionView.messagesDataSource = self
//    messagesCollectionView.messagesLayoutDelegate = self
//    messagesCollectionView.messagesDisplayDelegate = self
//  }
//    
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        let testMessage = Message(user: "user", content:"I love pizza, what is your favorite kind?")
////        insertNewMessage(testMessage)
//    }
//
//  
//  
//  // MARK: - Helpers
//  
//  // メッセージをFireStoreに保存して、一番下にスクロール
//  private func save(_ message: Message) {
//    reference?.addDocument(data: message.representation, completion: { (error) in
//      if let error = error {
//        print("Error sending message: \(error.localizedDescription)")
//        return
//      }
//      self.messagesCollectionView.scrollToBottom()
//    })
//  }
//
//  // 新しいメッセージを追加
//  private func insertNewMessage(_ message: Message) {
//    guard !messages.contains(message) else {
//      return
//    }
//
//    messages.append(message)
//    messages.sort()
//
//    let isLatestMessage = messages.index(of: message) == (messages.count - 1)
//    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
//
//    messagesCollectionView.reloadData()
//
//    if shouldScrollToBottom {
//      DispatchQueue.main.async {
//        self.messagesCollectionView.scrollToBottom(animated: true)
//      }
//    }
//  }
//
//  
//  private func handleDocumentChange(_ change: DocumentChange) {
//    guard let message = Message(document: change.document) else {
//      return
//    }
//
//    switch change.type {
//    case .added:
//      insertNewMessage(message)
//
//    default:
//      break
//    }
//  }
//}
//
//// MARK: - MessagesDisplayDelegate
//
//extension ChatViewController: MessagesDisplayDelegate {
//  
//  // 本人、他人で色を変えている
//  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//    // 1
//    return isFromCurrentSender(message: message) ? .primary : .incomingMessage
//  }
//  
//  // 送信時間がで出るようになる
//  func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
//    // 2
//    return true
//  }
//  
//  // メッセージが本人か、そうでは無いかで方向を決めて、さらに尻尾も変更している
//  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//    
//    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//    
//    // 3
//    return .bubbleTail(corner, .curved)
//  }
//  
//  
//}
//
//
//
//
//// MARK: - MessagesLayoutDelegate
//extension ChatViewController: MessagesLayoutDelegate {
//  
//  
//  // アバターの写真を入れる。もし用意するならば、messageViewとは違うところから取ってくるようにしないと、過去の画像が見れなさそう。
//  func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//    // 1
//    return .zero
//  }
//  
//  
//  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//    // 2
//    return CGSize(width: 0, height: 8)
//  }
//  
//  func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//    // 3
//    return 0
//  }
//}
//
//
//
//// MARK: - MessagesDataSource
//
//extension ChatViewController: MessagesDataSource {
//  // 1
//  // 現在の送信者の名前とIDを送信
//  func currentSender() -> Sender {
//    return Sender(id: user.uid, displayName: AppSettings.displayName)
//  }
//  
//  // 2
//  // メッセージの数
//  func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
//    return messages.count
//  }
//  
//  // 3
//  // メッセージセルを形成
//  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//    return messages[indexPath.section]
//  }
//  
//  // ユーザーネームのフォント
//  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//    
//    let name = message.sender.displayName
//    return NSAttributedString(string: name,
//                              attributes: [
//                                .font: UIFont.preferredFont(forTextStyle: .caption1),
//                                .foregroundColor: UIColor(white: 0.3, alpha: 1)
//                              ]
//    )
//  }
//}
//
//
//// MARK: - MessageInputBarDelegate
//
//extension ChatViewController: MessageInputBarDelegate {
//  
//  // チャット文字を入力する場所
//  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//    // 1
//    let message = Message(user: user, content: text)
//    
//    // 2
//    save(message)
//    
//    // 3
//    inputBar.inputTextView.text = ""
//  }
//}
//
//
//// MARK: - UIImagePickerControllerDelegate
//
//// 画像を投稿する時に必要になるデリゲート
//extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//  
//}
