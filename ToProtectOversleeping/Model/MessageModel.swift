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
    
    func sendMessageToChatDeclarationWakeUpEarly(documentID toID: String,displayName: String,wakeUpTimeText: String) {
        let sendDBModel = SendDBModel()
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//        sendDBModel.sendMessage(senderId: Auth.auth().currentUser!.uid, toID: toID, text: "\(displayName)は寝坊しました", displayName: displayName)
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "\(displayName)は\(wakeUpTimeText)に起きます！",
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
    
    func sendMessageToChatEditAlarmTime(documentID toID: String,displayName: String,wakeUpTimeText: String) {
        let sendDBModel = SendDBModel()
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "\(displayName)のアラーム時間が\(wakeUpTimeText)に変更されました",
            displayName: displayName,
            messageAppVersion: version
        )
    }
    
    func sendMessageToChatWakeUpBeforeSettingAlarmTime(documentID toID: String,displayName: String,wakeUpTimeText: String) {
        let sendDBModel = SendDBModel()
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "\(displayName)は設定した\(wakeUpTimeText)より前におきました",
            displayName: displayName,
            messageAppVersion: version
        )
    }
    
    func sendMessageToChatLeaveTheRoom(documentID toID: String,displayName: String) {
        let sendDBModel = SendDBModel()
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "\(displayName)は退室しました。",
            displayName: displayName,
            messageAppVersion: version
        )
    }
    
    func newInvitedToTeam(documentID toID: String,displayName: String,wakeUpTimeText: String) {
        let sendDBModel = SendDBModel()
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        sendDBModel.sendMessage(
            senderId: Auth.auth().currentUser!.uid,
            toID: toID,
            text: "\(displayName)は招待されました！",
            displayName: displayName,
            messageAppVersion: version
        )
        
        //TODO: 現時点では、エラーが出るので招待時のアラームのデフォルトのセットはやめておく。
//        sendDBModel.sendMessage(
//            senderId: Auth.auth().currentUser!.uid,
//            toID: toID,
//            text: "さっそく、\(displayName)のアラームが\(wakeUpTimeText)にセットされました！",
//            displayName: displayName,
//            messageAppVersion: version
//        )
    }
}
