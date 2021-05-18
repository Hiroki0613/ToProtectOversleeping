////
////  WakeUpCardCollectionListVC.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/05/03.
////
//
//import UIKit
//
//class WakeUpCardCollectionListVC: UIViewController {
//    
//    // 参考URL
//    // https://www.hfoasi8fje3.work/entry/2019/02/14/000000
//    // https://qiita.com/Queue0412/items/0984c8d1a757935f140f
//    
//    var wakeUpCardCollectionListCell = WakeUpCardCollectionListCell()
//    var settingLists:[SettingList] = []
//    
//    // 新しいカードを追加
//    var addWakeUpCardButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "macwindow.badge.plus")
//    
//    let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//    let flowLayout = UICollectionViewFlowLayout()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureCollectionView()
//        configureAddCardButton()
//        addWakeUpCardButton.tintColor = .systemBackground
////        wakeUpCardCollectionListCell.goToChatNCDelegate = self
//    }
//    
//    
//    func configureCollectionView() {
//        flowLayout.itemSize = CGSize(width: view.frame.width, height: view.frame.width)
//        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
//        collectionView.backgroundColor = .systemOrange
//        
//        collectionView.register(WakeUpCardCollectionListCell.self, forCellWithReuseIdentifier: WakeUpCardCollectionListCell.reuseID)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        self.view.addSubview(collectionView)
//    }
//    
//    func configureAddCardButton() {
//        addWakeUpCardButton.translatesAutoresizingMaskIntoConstraints = false
//        addWakeUpCardButton.layer.cornerRadius = 40
//        addWakeUpCardButton.layer.borderColor = UIColor.systemBackground.cgColor
//        addWakeUpCardButton.layer.borderWidth = 3.0
//        addWakeUpCardButton.addTarget(self, action: #selector(goToWakeUpDetailCardVC), for: .touchUpInside)
//        view.addSubview(addWakeUpCardButton)
//        
//        NSLayoutConstraint.activate([
//            addWakeUpCardButton.widthAnchor.constraint(equalToConstant: 80),
//            addWakeUpCardButton.heightAnchor.constraint(equalToConstant: 80),
//            addWakeUpCardButton.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant: -30),
//            addWakeUpCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
//        ])
//        
//    }
//    
//    @objc func goToWakeUpDetailCardVC() {
//        let setAlarmTimeAndNewRegistrationVC = SetAlarmTimeAndNewRegistrationVC()
//        setAlarmTimeAndNewRegistrationVC.modalPresentationStyle = .overFullScreen
//        setAlarmTimeAndNewRegistrationVC.modalTransitionStyle = .crossDissolve
//        self.present(setAlarmTimeAndNewRegistrationVC, animated: true, completion: nil)
//    }
//}
//
//
//
//extension WakeUpCardCollectionListVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        print("タップされました: ", indexPath.row)
//
//    }
//}
//
//
//extension WakeUpCardCollectionListVC: UICollectionViewDataSource {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WakeUpCardCollectionListCell.reuseID, for: indexPath) as! WakeUpCardCollectionListCell
////        let settingList = settingLists[indexPath.row]
////        cell.set(settingList: settingList)
//        cell.wakeUpTimeLabel.text = "起きる時間"
//        cell.wakeUpTimeTextField.text = "空白"
//        cell.wakeUpChatTeamLabel.text = "チーム"
//        cell.wakeUpChatTeamNameLabel.text = "早起き"
//        
//        cell.wakeUpChatTeamInvitationButton.addTarget(self, action: #selector(tapChatTeamInvitationButton(_:)), for: .touchUpInside)
//        cell.wakeUpChatTeamInvitationButton.tag = indexPath.row
//        
//        cell.setAlarmButton.addTarget(self, action: #selector(tapSetAlarmButton(_:)), for: .touchUpInside)
//        cell.setAlarmButton.tag = indexPath.row
//        
//        cell.setChatButton.addTarget(self, action: #selector(tapSetChatButton(_:)), for: .touchUpInside)
//        cell.setChatButton.tag = indexPath.row
//        return cell
//    }
//}
//
//extension WakeUpCardCollectionListVC {
//    @objc func tapChatTeamInvitationButton(_ sender: UIButton) {
//        print("collection招待するボタンがタップされました: ", sender.tag)
//        let qRCodeVC = QRCodeVC()
//        navigationController?.pushViewController(qRCodeVC, animated: true)
//    }
//    
//    @objc func tapSetAlarmButton(_ sender: UIButton) {
//        print("collectionアラームボタンがタップされました: ",sender.tag)
//        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
//        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
//    }
//    
//    @objc func tapSetChatButton(_ sender: UIButton) {
//        print("collectionチャットボタンがタップされました: ", sender.tag)
//        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
//        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
//    }
//}
//
//
//extension WakeUpCardCollectionListVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width - 40, height: 280)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//    }
//}
//
////extension WakeUpCardCollectionListVC: GoToChatNCDelegate {
////    func goToChat() {
////        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
////        wakeUpCommunicateChatVC.title = "チャット"
////        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
////    }
////}