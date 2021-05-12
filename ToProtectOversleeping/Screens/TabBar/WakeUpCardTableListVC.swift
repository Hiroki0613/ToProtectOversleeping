//
//  WakeUpCardTableListVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/12.
//

import UIKit

class WakeUpCardTableListVC: UIViewController {
    
    var wakeUpCardTableListCell = WakeUpCardTableListCell()
    var settingLists: [SettingList] = []
    
    // 新しいカードを追加
    var addWakeUpCardButton = WUButton(backgroundColor: .systemOrange, sfSymbolString: "macwindow.badge.plus")
    
    
    override func viewDidLoad() {
        view.backgroundColor = .systemOrange
        configureTableView()
        configureAddCardButton()
    }
    
    func configureTableView() {
//        let tableView = UITableView(frame: view.frame)
        let tableView = UITableView(frame: CGRect(x: 20, y: 0, width: view.frame.size.width - 40, height: view.frame.size.height))
        tableView.backgroundColor = .systemOrange
        
        tableView.register(WakeUpCardTableListCell.self, forCellReuseIdentifier: WakeUpCardTableListCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        self.view.addSubview(tableView)
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
    }
    
    
    @objc func goToWakeUpDetailCardVC() {
        let setAlarmTimeAndNewRegistrationVC = SetAlarmTimeAndNewRegistrationVC()
        setAlarmTimeAndNewRegistrationVC.modalPresentationStyle = .overFullScreen
        setAlarmTimeAndNewRegistrationVC.modalTransitionStyle = .crossDissolve
        self.present(setAlarmTimeAndNewRegistrationVC, animated: true, completion: nil)
    }
}

extension WakeUpCardTableListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップされました: ", indexPath.row)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: WakeUpCardTableListCell.reuseID, for: indexPath) as! WakeUpCardTableListCell
        
        cell.wakeUpChatTeamLabel.text = "チーム"
        cell.wakeUpChatTeamNameLabel.text = "早起き"
        cell.wakeUpTimeLabel.text = "起きる時間"
        cell.wakeUpTimeTextField.text = "空白"
        
        cell.wakeUpChatTeamInvitationButton.addTarget(self, action: #selector(tapChatTeamInvitationButton(_:)), for: .touchUpInside)
        cell.wakeUpChatTeamInvitationButton.tag = indexPath.row
        
        cell.setAlarmButton.addTarget(self, action: #selector(tapSetAlarmButton(_:)), for: .touchUpInside)
        cell.setAlarmButton.tag = indexPath.row
        
        cell.setChatButton.addTarget(self, action: #selector(tapSetChatButton(_:)), for: .touchUpInside)
        cell.setChatButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
    
}

extension WakeUpCardTableListVC {
    @objc func tapChatTeamInvitationButton(_ sender: UIButton) {
        print("招待するボタンがタップされました: ", sender.tag)
    }
    
    @objc func tapSetAlarmButton(_ sender: UIButton) {
        print("アラームボタンがタップされました: ",sender.tag)
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
    }
    
    @objc func tapSetChatButton(_ sender: UIButton) {
        print("チャットボタンがタップされました: ", sender.tag)
        let wakeUpCommunicateChatVC = WakeUpCommunicateChatVC()
        navigationController?.pushViewController(wakeUpCommunicateChatVC, animated: true)
    }
}
