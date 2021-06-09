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
    ///   - isWakeUpBool: 起きた時に使われるBool
    func createUser(name: String,uid: String,appVersion: String, isWakeUpBool: Bool) {
        // ここでUserModelを作成。
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
            ["name": name as Any,
             "uid": uid as Any,
             "appVersion": appVersion as Any,
             "isWakeUpBool": isWakeUpBool as Any,
             "date": Date().timeIntervalSince1970 as Any
            ]
        )
        self.doneCreateUser?.doneCreateUser()
    }
    
    
    // ランダムStringを作成
    func randomString(length: Int) -> String {
      let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    
    /// チャットルーム作成
    /// - Parameters:
    ///   - roomName: チャットルームの名前
    ///   - wakeUpTime: 起きる時間
    ///   - isWakeUpBool: 起きた時に使われるBool
    ///   - isWakeUpRoop: 繰り返しループの設定(暫定的に用意)
    func createChatRoom(roomName: String, wakeUpTimeDate: Date, wakeUpTimeText: String, isWakeUpBool: Bool, isWakeUpRoop: Bool, appVersion: String) {
        //"Chats"のdocumentIDのために、ランダムStringを作成
        let generatedRandomString = "WU\(randomString(length: 18))"
        print("SendDB_generatedRandomString: ", generatedRandomString)
        
        // Userでチャットルームを作成。こちらでカード一覧を表示
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").document(generatedRandomString).setData(
            [
                "roomName": roomName as Any,
                "uid": Auth.auth().currentUser!.uid as Any,
                "wakeUpTimeText": wakeUpTimeText as Any,
                "wakeUpTimeDate": Double( wakeUpTimeDate.timeIntervalSince1970) as Any,
                "registerDate": Date().timeIntervalSince1970 as
                Any,
                "isWakeUpBool": isWakeUpBool as Any,
                "isWakeUpRoop": isWakeUpRoop as Any,
                "appVersion": appVersion as Any
            ]
        )
        
        // Chatルームは別に作成
        self.db.collection("Chats").document(generatedRandomString).setData(
            [
                "roomName": roomName as Any,
//                "chatRoomId": generatedRandomString,
                "uid": Auth.auth().currentUser!.uid as Any,
                "wakeUpTimeText": wakeUpTimeText as Any,
                "wakeUpTimeDate": Double( wakeUpTimeDate.timeIntervalSince1970) as Any,
                "registerDate": Date().timeIntervalSince1970 as
                Any,
                "chatRoomId": generatedRandomString as Any,
                "appVersion": appVersion as
                Any
            ]
        )
//         同時にUNNotificationCenterにも通知登録identifier付きで行う。
        alarmSet(identifierString: generatedRandomString)
        self.doneCreateChatRoom?.doneCreateChatRoom()
    }
    
    
//    func createChatRoom(roomName: String, wakeUpTimeDate: Date, wakeUpTimeText: String) {
//        self.db.collection("Chats").document().setData(
//            ["roomName": roomName as Any,
////             "wakeUpTimeDate": wakeUpTimeDate as Any,
//             "wakeUpTimeText": wakeUpTimeText as Any,
//             "uid": Auth.auth().currentUser!.uid as Any,
//             "registerDate": Date().timeIntervalSince1970]
//        )
//        self.doneCreateChatRoom?.doneCreateChatRoom()
//    }
    
    
    
    
    /// チャットルーム招待
    /// - Parameters:
    ///   - roomNameID: チャットルームのID
    ///   - wakeUpTime: 起きる時間
//    func invitedChatRoom(roomNameId: String, wakeUpTimeDate: Date,
//                         wakeUpTimeText: String) {
//        let loadDBModel = LoadDBModel()
//        let roomName = loadDBModel.loadChatRoomDocumentID(roomNameId: roomNameId)
//
//        print("SendDBModel_roomName: ", roomName)
//
//        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").document(roomNameId).setData(
//            ["roomName": roomName as Any,
//             "uid": Auth.auth().currentUser!.uid as Any,
//             "wakeUpTimeText": wakeUpTimeText as Any,
//             "registerDate": Date().timeIntervalSince1970]
//        )
//        self.doneInvitedChatRoom?.doneInvitedChatRoom()
//    }
    
    func invitedChatRoom(roomNameId: String, wakeUpTimeDate: Date, wakeUpTimeText: String, isWakeUpBool: Bool, isWakeUpRoop: Bool, appVersion: String) {
        
        let loadDBModel = LoadDBModel()
        loadDBModel.loadChatRoomDocumentId(roomNameId: roomNameId) { roomNameString in
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").document(roomNameId).setData(
                ["roomName": roomNameString as Any,
                 "uid": Auth.auth().currentUser!.uid as Any,
                 "wakeUpTimeDate": Double( wakeUpTimeDate.timeIntervalSince1970) as Any,
                 "wakeUpTimeText": wakeUpTimeText as Any,
                 "registerDate": Date().timeIntervalSince1970,
                "isWakeUpBool": isWakeUpBool as Any,
                "isWakeUpRoop": isWakeUpRoop as Any,
                "appVersion": appVersion as Any
                ]
            )
            
            self.alarmSet(identifierString: roomNameId)
        }
    }
    
    
    
    func sendMessage(senderId: String, toID: String, text: String, displayName: String, messageAppVersion: String) {
        
        self.db.collection("Chats").document(toID).collection("Talk").document().setData(
            [
                "text":text as Any,
                "senderId": senderId as Any,
                "displayName": displayName as Any,
                "date": Date().timeIntervalSince1970,
                "messageAppVersion": messageAppVersion as Any
            ]
        )
        
        
//        self.db.collection("Chats").document(senderId).collection("Talk").document(toID).setData(
//            ["text": text as Any, "senderId": senderId as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
//        )
//        self.db.collection("Chats").document(toID).collection("Talk").document(senderId).setData(
//            ["text": text as Any, "senderId": Auth.auth().currentUser!.uid as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
//        )
    }
    
    
    //アラート設定
    func alarmSet(identifierString: String){
        // identifierは一位にするため、Auth.auth()+roomIdにする
        let identifier = Auth.auth().currentUser!.uid + identifierString
        removeAlarm(identifiers: identifier)

        //通知設定
        let content = UNMutableNotificationContent()
        content.title = "通知です"
        
        content.categoryIdentifier = identifier
        var dateComponents = DateComponents()
        
        //近藤　カレンダー形式で通知
        dateComponents.hour = 1
        dateComponents.minute = 15
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //TODO: identifierは一位にするため、Auth.auth()+roomIdにする。
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    //アラート設定削除
    func removeAlarm(identifiers:String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifiers])
    }
   
    
    
    
}
