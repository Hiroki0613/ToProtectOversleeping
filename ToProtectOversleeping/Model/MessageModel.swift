//
//  MessageModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/30.
//

import Foundation
import MessageKit


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
