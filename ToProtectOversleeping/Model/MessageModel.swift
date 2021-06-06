//
//  MessageModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/30.
//

import Foundation
import MessageKit
import Firebase


struct Sender: SenderType {
    var senderId: String
    var displayName: String
}


struct Message: MessageType {
    // 必須
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}


class MessageModel {
    
    func sendMessageToChat(documentID toID: String,displayName: String) {
        let sendDBModel = SendDBModel()
        sendDBModel.sendMessage(senderId: Auth.auth().currentUser!.uid, toID: toID, text: "\(displayName)は寝坊しました", displayName: displayName)
    }
}
