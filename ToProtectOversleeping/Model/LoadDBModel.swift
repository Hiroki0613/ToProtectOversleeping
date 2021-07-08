//
//  LoadDBModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/30.
//

import Foundation
import Firebase

protocol GetChatRoomNameDelegate {
    func getChatRoomName(chatRoomNameModel:[ChatRoomNameModel])
    func getChatDocumentId(chatRoomDocumentId:[String])
}

protocol GetUserDataDelegate {
    func getUserData(userDataModel: UserDataModel)
}

protocol GetSettingDataDelegate {
    func getSettingData(settingDataModel: SettingDataModel)
}

class LoadDBModel {
    var db = Firestore.firestore()
    var getChatRoomNameDelegate: GetChatRoomNameDelegate?
    var getUserDataDelegate: GetUserDataDelegate?
    var getSettingDataDelegate: GetSettingDataDelegate?
    var chatRoomNameArray = [ChatRoomNameModel]()
    var chatDocumentIdArray = [""]
    
    // プロフィールの呼び出し
    func loadProfileData() {
        db.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let data = snapShot?.data() {
                if let name = data["name"] as? String,
                    let uid = data["uid"] as? String,
                    let appVersion = data["appVersion"] as? String,
                    let isWakeUpBool = data["isWakeUpBool"] as? Bool,
                    let date = data["date"] as? Double,
                    let _ = data["displayAdvertise"] as? Bool,
                    let _ = data["developerMode"] as? Bool
                {
                    let userDataModel = UserDataModel(name: name, uid: uid, appVersion: appVersion, isWakeUpBool: isWakeUpBool, date: date)
                    self.getUserDataDelegate?.getUserData(userDataModel: userDataModel)
                }
            }
        }
    }
    

    
    // セッティングの呼び出し
    func loadSettingMode() {
        db.collection("Setting").document("setting").addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let data = snapShot?.data() {
                if let contact = data["contact"] as? String
                {
                    let settingDataModel = SettingDataModel(contact: contact)
                    self.getSettingDataDelegate?.getSettingData(settingDataModel: settingDataModel)
                }
            }
        }
    }
    
    
    // チャットルームの呼び出し
    func loadChatRoomNameData() {
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").order(by: "dayOfTheWeek",descending: true).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents {
                self.chatRoomNameArray = []
                self.chatDocumentIdArray = []
                for doc in snapShotDoc {
                    
                    // chatRoomNameArray
                    let data = doc.data()
                    print("dataだぜ: ",data)
                    if let roomName = data["roomName"] as? String,
                       let wakeUpTimeText = data["wakeUpTimeText"] as? String,
                       let uid = data["uid"] as? String,
                       let registerDate = data["registerDate"] as? Double,
                       let wakeUpTimeDate = data["wakeUpTimeDate"] as? Double,
                       let isWakeUpBool = data["isWakeUpBool"] as? Bool,
                       let dayOfTheWeek = data["dayOfTheWeek"] as? String,
                       let appVersion = data["appVersion"] as? String
                       {
                        let chatRoomNameModel = ChatRoomNameModel(
                            roomName: roomName,
                            wakeUpTimeDate:wakeUpTimeDate,
                            wakeUpTimeText: wakeUpTimeText,
                            uid: uid,
                            registerDate: registerDate,
                            isWakeUpBool: isWakeUpBool,
                            dayOfTheWeek: dayOfTheWeek,
                            appVersion: appVersion)
                        
                        self.chatRoomNameArray.append(chatRoomNameModel)
                    }
                    
                    // chatDocumentIDArray
                    self.chatDocumentIdArray.append(doc.documentID)
                }
                print(self.chatRoomNameArray)
                self.getChatRoomNameDelegate?.getChatRoomName(chatRoomNameModel: self.chatRoomNameArray)
                self.getChatRoomNameDelegate?.getChatDocumentId(chatRoomDocumentId: self.chatDocumentIdArray)
            }
        }
    }
    
    
    func loadChatRoomDocumentId(roomNameId: String, complition:(@escaping(String) -> Void)) {
        var roomNameString = "空白"
        db.collection("Chats").document(roomNameId).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let data = snapShot?.data() {
                roomNameString = data["roomName"] as! String
                print("data.roomName: ", roomNameString)
            }
            complition(roomNameString)
        }
    }
}

