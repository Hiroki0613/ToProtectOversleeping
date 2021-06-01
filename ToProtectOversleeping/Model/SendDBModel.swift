//
//  SendDBModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/29.
//

import Foundation
import Firebase

protocol DoneCreateUser {
    func doneCreateUser()
}

protocol DoneCreateChatRoom {
    func doneCreateChatRoom()
}

protocol DoneInvitedChatRoom {
    func doneInvitedChatRoom()
}

class SendDBModel {
    let db = Firestore.firestore()
    
    var loadDBModel = LoadDBModel()
    
    var doneCreateUser: DoneCreateUser?
    var doneCreateChatRoom: DoneCreateChatRoom?
    var doneInvitedChatRoom: DoneInvitedChatRoom?
    
//    var senderID: String = ""
//    var toID: String = ""
//    var text: String = ""
//    var displayName: String = ""
    
    
    // 新規作成の時は、ユーザー登録画面に画面遷移させる。
    /// ユーザー作成
    /// - Parameters:
    ///   - name: ユーザー名
    ///   - uid: FirebaseのAuth.auth()
    ///   - appVersion: アプリのバージョン
    ///   - isWakeUpBool: 起きた時に使われるBool(暫定的に用意)
    func createUser(name: String,uid: String,appVersion: String, isWakeUpBool: Bool) {
        // ここでUserModelを作成。
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
            ["name": name as Any,"uid": uid as Any, "appVersion": appVersion as Any,
             "isWakeUpBool": isWakeUpBool as Any,"date": Date().timeIntervalSince1970]
        )
        self.doneCreateUser?.doneCreateUser()
    }
    
    
    /// チャットルーム作成
    /// - Parameters:
    ///   - roomName: チャットルームの名前
    ///   - wakeUpTime: 起きる時間
    func createChatRoom(roomName: String, wakeUpTimeDate: Date, wakeUpTimeText: String) {
        self.db.collection("Chats").document().setData(
            ["roomName": roomName as Any,
//             "wakeUpTimeDate": wakeUpTimeDate as Any,
             "wakeUpTimeText": wakeUpTimeText as Any,
             "uid": Auth.auth().currentUser!.uid as Any,
             "registerDate": Date().timeIntervalSince1970]
        )
        self.doneCreateChatRoom?.doneCreateChatRoom()
    }
    
    
    /// チャットルーム招待
    /// - Parameters:
    ///   - roomNameID: チャットルームのID
    ///   - wakeUpTime: 起きる時間
    func invitedChatRoom(roomNameId: String, wakeUpTimeDate: Date,
                         wakeUpTimeText: String) {
        let loadDBModel = LoadDBModel()
        self.db.collection("Chats").document(roomNameId).setData(
            ["roomName": loadDBModel.loadChatRoomDocumentID(roomNameId: roomNameId) as Any,
             "wakeUpTimeText": wakeUpTimeText as Any,
             "uid": Auth.auth().currentUser!.uid as Any,
             "registerDate": Date().timeIntervalSince1970]
        )
        self.doneInvitedChatRoom?.doneInvitedChatRoom()
    }
    
    
    func sendMessage(senderId: String, toID: String, text: String, displayName: String) {
        
        self.db.collection("Chats").document(toID).collection("Talk").document().setData(
            ["text":text as Any, "senderId": senderId as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
        )
        
        
//        self.db.collection("Chats").document(senderId).collection("Talk").document(toID).setData(
//            ["text": text as Any, "senderId": senderId as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
//        )
//        self.db.collection("Chats").document(toID).collection("Talk").document(senderId).setData(
//            ["text": text as Any, "senderId": Auth.auth().currentUser!.uid as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
//        )
    }
}
