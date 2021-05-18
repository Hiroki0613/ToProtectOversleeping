//
//  WakeUpCommunicateChatModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/18.
//

import Foundation
import MessageKit
import FirebaseFirestore


struct Message: MessageType {
    
    // 必須
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    // 必須では無い
    var userImagePath: String
    var date:TimeInterval
    var messageImageString:String
}
