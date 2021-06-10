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
    
    func sendMessageToChatWakeUpLate(documentID toID: String,displayName: String) {
        let sendDBModel = SendDBModel()
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//        sendDBModel.sendMessage(senderId: Auth.auth().currentUser!.uid, toID: toID, text: "\(displayName)は寝坊しました", displayName: displayName)
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "\(displayName)は寝坊しました",
            displayName: displayName,
            messageAppVersion: version
        )
    }
    
    func sendMessageToChatDeclarationWakeUpEarly(documentID toID: String,displayName: String) {
        let sendDBModel = SendDBModel()
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//        sendDBModel.sendMessage(senderId: Auth.auth().currentUser!.uid, toID: toID, text: "\(displayName)は寝坊しました", displayName: displayName)
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "\(displayName)は早起きします！",
            displayName: displayName,
            messageAppVersion: version
        )
    }
    
    func sendMessageToChatAlarmCut(documentID toID: String,displayName: String) {
        let sendDBModel = SendDBModel()
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//        sendDBModel.sendMessage(senderId: Auth.auth().currentUser!.uid, toID: toID, text: "\(displayName)は寝坊しました", displayName: displayName)
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "\(displayName)のアラームはカットされました！",
            displayName: displayName,
            messageAppVersion: version
        )
    }
    
    func newInvitedToTeam(documentID toID: String,displayName: String) {
        let sendDBModel = SendDBModel()
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//        sendDBModel.sendMessage(senderId: Auth.auth().currentUser!.uid, toID: toID, text: "\(displayName)は寝坊しました", displayName: displayName)
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "\(displayName)は招待されました！",
            displayName: displayName,
            messageAppVersion: version
        )
        
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "さっそく、\(displayName)のアラームがセットされました！",
            displayName: displayName,
            messageAppVersion: version
        )
    }
}
