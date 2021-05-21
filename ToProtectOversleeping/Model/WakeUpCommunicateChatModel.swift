//
//  WakeUpCommunicateChatModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/18.
//

import Foundation
import MessageKit
import FirebaseFirestore


struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

//struct MockUser: SenderType, Equatable {
//    var senderId: String
//    var displayName: String
//}

struct Message: MessageType {
    // 必須
    var sender: SenderType {
        return user
    }
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    var user: Sender
    
    // 必須では無い
//    var userImagePath: String
//    var date:TimeInterval
//    var messageImageString:String
    
    
    private init(kind: MessageKind, user: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, user: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }
}

struct UserdataModel {
    var uid = String()
    var name = String()
}


class SendDBModel {
    var senderID: String = ""
    var toID: String = ""
    var text: String = ""
    var displayName: String = ""
    var imageUrlString: String = ""
}
