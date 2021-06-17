//
//  ResultWakeUpVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/16.
//

import UIKit
import Firebase

class ResultWakeUpVC: UIViewController {
    
    // 一旦ここでaddSnapをさせる
    let db = Firestore.firestore()
    
//    var labelArray: [UILabel] = []
    
    var chatRoomDocumentId: String?
    
    var wakeUpSuccessPersonList: [String] = []
    var wakeUpRainyDayPersonList: [String] = []
//    var wakeUpSuccessPersonList777 = ["うにうに","うにょうにょ","うろうろ"]
    
    var titleLabel = WUBodyLabel(fontSize: 30)
    var resultLabel = WUBodyLabel(fontSize: 20)
    var resultStackView = UIStackView(frame: .zero)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemOrange
        
        guard let chatRoomDocumentId = chatRoomDocumentId else { return }
        loadMessage(toID: chatRoomDocumentId)
        print("宏輝_chatRoomDocumentId: ",chatRoomDocumentId)
        print("宏輝_wakeUpSuccessPersonListAtChat: ",wakeUpSuccessPersonList)
        configureUI()
        self.view.layoutIfNeeded()
    }
    
    
    //どこかのチャットルームで開かれているトークを日付順で並べている。
    func loadMessage(toID: String) {
        db.collection("Chats").document(toID).collection("Talk").order(by: "date").addSnapshotListener { snapshot, error in
            if error != nil {
                return
            }
            
            // アプリバージョンごとにif letでunlapさせて
            if let snapShotDoc = snapshot?.documents {
                
                
                
                for doc in snapShotDoc {
                    let data = doc.data()
                    print("data: ",data)
                    
                    guard let messageAppVersion = data["messageAppVersion"] as? String else { return }
                    
                    if messageAppVersion == "1.0.0" {
                        if let _ = data["text"] as? String,
                           let _ = data["senderId"] as? String,
                           let displayName = data["displayName"] as? String,
                           let date = data["date"] as? Double,
                           let sendWUMessageType = data["sendWUMessageType"] as? String
                           {
                            // まず目が覚めた人をリストに上げる
                            if sendWUMessageType == SendWUMessageType.wakeUpSuccessMessage {
                                let calendar = Calendar(identifier: .gregorian)
                                print("宏輝_起きた時間: ", Date(timeIntervalSince1970: date))
                                
                                let date = Date(timeIntervalSince1970: date)
                                
                                // 今日の日付ならappend
                                if calendar.isDateInToday(date) {
                                    print("宏輝_起きたresult: ",displayName)
                                    self.wakeUpSuccessPersonList.append(displayName)
//                                    let label = UILabel()
//                                    label.translatesAutoresizingMaskIntoConstraints = false
//                                    self.labelArray.append(label)
                                    print("宏輝_起きたリストresult: ", self.wakeUpSuccessPersonList)
                                }
                                
                                if calendar.isDateInToday(date) {
                                    print("宏輝_雨の日リストresult: ", self.wakeUpRainyDayPersonList)
                                    self.wakeUpRainyDayPersonList.append(displayName)
                                }
                            }
                            
                            // まず目が覚めた人をリストに上げる
                            if sendWUMessageType == SendWUMessageType.rainyDay {
                                let calendar = Calendar(identifier: .gregorian)
                                print("宏輝_起きた時間: ", Date(timeIntervalSince1970: date))
                                
                                let date = Date(timeIntervalSince1970: date)
                                
                                // 今日の日付ならappend
                                if calendar.isDateInToday(date) {
                                    print("宏輝_雨の日リストresult: ", self.wakeUpRainyDayPersonList)
                                    self.wakeUpRainyDayPersonList.append(displayName)
                                }
                            }
                        }
                    }
                }
                let orderedSetSuccess: NSOrderedSet = NSOrderedSet(array:  self.wakeUpSuccessPersonList)
                self.wakeUpSuccessPersonList = orderedSetSuccess.array as! [String]
                    let text1 = self.wakeUpSuccessPersonList.joined(separator: "\n")
                let orderedSetRainyDay: NSOrderedSet = NSOrderedSet(array: self.wakeUpRainyDayPersonList)
                self.wakeUpRainyDayPersonList = orderedSetRainyDay.array as! [String]
                let text2 = self.wakeUpRainyDayPersonList.joined(separator: "\n")
                    self.resultLabel.text = "\(text1)\n\n☔️雨の日☔️\n\(text2)"
            }
        }
    }
        
    
    
    
    func configureUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        resultStackView.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        
        titleLabel.text = "早起きができた人"
        
//        resultLabel.text = wakeUpSuccessPersonList.joined(separator: "\n")


//        for wakeUpSuccessPerson in wakeUpSuccessPersonList777 {
//            resultLabel.text = wakeUpSuccessPerson + "\n"
//        }
        
        
        view.addSubview(titleLabel)
        view.addSubview(resultLabel)
//        view.addSubview(resultStackView)
        
//        for i in 0...(wakeUpSuccessPersonList.count - 1) {
//            let resultLabelArray = [WUBodyLabel(fontSize: 16)]
//            resultLabelArray[i].text = wakeUpSuccessPersonList[i]
//            resultStackView.addArrangedSubview(resultLabelArray[i])
//        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
  
            resultLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
            
//            resultStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
//            resultStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
//            resultStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
////            resultStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            resultStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            
        ])
    }

    

}
