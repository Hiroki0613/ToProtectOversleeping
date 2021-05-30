//
//  WakeUpCardTableListVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/12.
//

import UIKit

class WakeUpCardTableListVC: UIViewController {
    
    let tableView = UITableView()
//    var wakeUpCardTableListCell = WakeUpCardTableListCell()
    var settingLists: [SettingList] = []
    var chatRoomNameModel:ChatRoomNameModel?
    var chatRoomNameModelArray = [ChatRoomNameModel]()
    
    // 新しいカードを追加
    var addWakeUpCardButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "macwindow.badge.plus")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        // UserDefaultの値で最初の画面を分岐させる
        if UserDefaults.standard.bool(forKey: "isFirstOpenApp") == false {
            configureTableView()
            configureAddCardButton()
        } else {
            let newRegistrationUserNameVC = NewRegistrationUserNameVC()
            navigationController?.pushViewController(newRegistrationUserNameVC, animated: true)
        }
    }
    
    func configureTableView() {
//        let tableView = UITableView(frame: view.frame)
//        let tableView = UITableView(frame: CGRect(x: 20, y: 0, width: view.frame.size.width - 40, height: view.frame.size.height))
//        let tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
//        tableView.backgroundColor = .systemOrange
        tableView.frame = view.bounds
//        tableView.rowHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.allowsSelection = false
//        tableView.delaysContentTouches = false
        tableView.separatorStyle = .none
        
        tableView.register(WakeUpCardTableListCell.self, forCellReuseIdentifier: WakeUpCardTableListCell.reuseID)
        
    }
    
    func configureAddCardButton() {
        addWakeUpCardButton.translatesAutoresizingMaskIntoConstraints = false
        addWakeUpCardButton.layer.cornerRadius = 40
        addWakeUpCardButton.layer.borderColor = UIColor.systemBackground.cgColor
        addWakeUpCardButton.layer.borderWidth = 3.0
        addWakeUpCardButton.addTarget(self, action: #selector(goToWakeUpDetailCardVC), for: .touchUpInside)
        view.addSubview(addWakeUpCardButton)
        
        NSLayoutConstraint.activate([
            addWakeUpCardButton.widthAnchor.constraint(equalToConstant: 80),
            addWakeUpCardButton.heightAnchor.constraint(equalToConstant: 80),
            addWakeUpCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addWakeUpCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        addWakeUpCardButton.tintColor = .systemBackground
    }
    
    
    @objc func goToWakeUpDetailCardVC() {
        let setAlarmTimeAndNewRegistrationVC = SetAlarmTimeAndNewRegistrationVC()
        setAlarmTimeAndNewRegistrationVC.modalPresentationStyle = .overFullScreen
        setAlarmTimeAndNewRegistrationVC.modalTransitionStyle = .crossDissolve
        self.present(setAlarmTimeAndNewRegistrationVC, animated: true, completion: nil)
    }
}

extension WakeUpCardTableListVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("タップされました: ", indexPath.row)
//    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 編集処理
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            // 編集処理を記述
            print("Editがタップされた")
            let wakeUpQrCodeVC = WakeUpQrCodeMakerVC()
            self.navigationController?.pushViewController(wakeUpQrCodeVC, animated: true)
            
            // 実行結果に関わらず記述
            completionHandler(true)
        }

           // 削除処理
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
              //削除処理を記述
              print("Deleteがタップされた")

              // 実行結果に関わらず記述
              completionHandler(true)
            }

            // 定義したアクションをセット
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

extension WakeUpCardTableListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WakeUpCardTableListCell.reuseID) as! WakeUpCardTableListCell
        
        cell.set(chatRoomNameModel: chatRoomNameModel)
//        cell.wakeUpChatTeamLabel.text = "チーム"
//        cell.wakeUpChatTeamNameLabel.text = "早起き"
//        cell.wakeUpLabel.text = "起きる時間"
//        cell.wakeUpTimeTextField.text = "空白"
        
//        cell.wakeUpChatTeamInvitationButton.addTarget(self, action: #selector(tapChatTeamInvitationButton(_:)), for: .touchUpInside)
//        cell.wakeUpChatTeamInvitationButton.tag = indexPath.row
        
        cell.setAlarmButton.addTarget(self, action: #selector(tapSetAlarmButton(_:)), for: .touchUpInside)
        cell.setAlarmButton.tag = indexPath.row
        
        cell.setChatButton.addTarget(self, action: #selector(tapSetChatButton(_:)), for: .touchUpInside)
        cell.setChatButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = .blue
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
//        view.tintColor = .red
//    }
    
}

extension WakeUpCardTableListVC {
//    @objc func tapChatTeamInvitationButton(_ sender: UIButton) {
//        print("tableview招待するボタンがタップされました: ", sender.tag)
//        let wakeUpQrCodeVC = WakeUpQrCodeMakerVC()
//        navigationController?.pushViewController(wakeUpQrCodeVC, animated: true)
//    }
    
    @objc func tapSetAlarmButton(_ sender: UIButton) {
        print("tableviewアラームボタンがタップされました: ",sender.tag)
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    @objc func tapSetChatButton(_ sender: UIButton) {
        print("tableviewチャットボタンがタップされました: ", sender.tag)
        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
    }
}
