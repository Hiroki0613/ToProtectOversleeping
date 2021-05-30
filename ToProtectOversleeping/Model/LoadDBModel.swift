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
}

protocol GetUserDataDelegate {
    func getUserData(userDataModel: UserDataModel)
}

class LoadDBModel {
    var db = Firestore.firestore()
    var getChatRoomNameDelegate:GetChatRoomNameDelegate?
    var getUserDataDelegate:GetUserDataDelegate?
    var chatRoomNameArray = [ChatRoomNameModel]()
    
    
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
                    let date = data["date"] as? Double {
                    
                    let userDataModel = UserDataModel(name: name, uid: uid, appVersion: appVersion, isWakeUpBool: isWakeUpBool, date: date)
                    self.getUserDataDelegate?.getUserData(userDataModel: userDataModel)
                }
            }
        }
    }
    
    
    
    func loadChatRoomNameData() {
        db.collection("Chats").addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents {
                self.chatRoomNameArray = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    print("data: ",data)
                    if let roomName = data["roomName"] as? String,
                       //                       let wakeUpTimeDate = data["wakeUpTimeDate"] as? Double,
                       let wakeUpTimeText = data["wakeUpTimeText"] as? String,
                       let uid = data["uid"] as? String,
                       let registerDate = data["registerDate"] as? Double {
                        let chatRoomNameModel = ChatRoomNameModel(
                            roomName: roomName,
                            //                            wakeUpTimeDate:wakeUpTimeDate,
                            wakeUpTimeText: wakeUpTimeText,
                            uid: uid,
                            registerDate: registerDate)
                        self.chatRoomNameArray.append(chatRoomNameModel)
                    }
                }
                print(self.chatRoomNameArray)
                self.getChatRoomNameDelegate?.getChatRoomName(chatRoomNameModel: self.chatRoomNameArray)
            }
        }
    }
    
}

