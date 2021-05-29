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



