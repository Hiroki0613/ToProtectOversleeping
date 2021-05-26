//
//  WakeUpCommunicateChatModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/18.
//

import Foundation
import MessageKit
import FirebaseFirestore
import FirebaseAuth


struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

//struct MockUser: SenderType, Equatable {
//    var senderId: String
//    var displayName: String
//}

struct RoomNameModel {
    var roomName: String
}

struct Message: MessageType {
    // 必須
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    // 必須では無い
//    var userImagePath: String
//    var date:TimeInterval
//    var messageImageString:String
    
    
//    private init(kind: MessageKind, user: Sender, messageId: String, date: Date) {
//        self.kind = kind
//        self.user = user
//        self.messageId = messageId
//        self.sentDate = date
//    }
//    
//    init(text: String, user: Sender, messageId: String, date: Date) {
//        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
//    }
}

struct UserDataModel {
    var uid = String()
    var name = String()
}


class SendDBModel {
    
    // 一旦ここでaddSnapをさせる
    let db = Firestore.firestore()
    
    var senderID: String = ""
    var toID: String = ""
    var text: String = ""
    var displayName: String = ""
//    var imageUrlString: String = ""
    
//    func sendMessage(senderID:String,text: String, user: String, messageID: String, date: Date) {
//        self.db.collection("Users").document(senderID).collection("chat").document(messageID).setData(["text": text as Any, "user": currentUser,"messageID": messageID ,"date": Date().timeIntervalSince1970]
//        )
//
////        self.db.collection("Users").document("7654321").collection("chat").document(messageID).setData(["text": text as Any, "user": otherUser as Any, "messageID": messageID,"date": Date().timeIntervalSince1970]
////        )
//    }
    
    func sendMessage(senderID: String, toID: String, text: String, displayName: String) {
        self.db.collection("Chats").document(senderID).collection("talk").document(toID).setData([
            "text": text as Any,"senderID": senderID as Any,"displayName": displayName as Any, "date": Date().timeIntervalSince1970]
        )
        self.db.collection("Chats").document(toID).collection("talk").document(senderID).setData(
            ["text": text as Any, "senderID": Auth.auth().currentUser!.uid as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
        )
    }
}
