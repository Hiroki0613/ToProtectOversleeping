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

struct RoomNameModel {
    var roomName: String
}

struct Message: MessageType {
    // 必須
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct UserDataModel {
    var uid = String()
    var name = String()
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }
}


class SendDBModel {
    // 一旦ここでaddSnapをさせる
    let db = Firestore.firestore()
    
    var senderID: String = ""
    var toID: String = ""
    var text: String = ""
    var displayName: String = ""
    
    func sendMessage(senderID: String, toID: String, text: String, displayName: String) {
        self.db.collection("Chats").document(senderID).collection("talk").document(toID).setData([
            "text": text as Any,"senderID": senderID as Any,"displayName": displayName as Any, "date": Date().timeIntervalSince1970]
        )
        self.db.collection("Chats").document(toID).collection("talk").document(senderID).setData(
            ["text": text as Any, "senderID": Auth.auth().currentUser!.uid as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
        )
    }
}
