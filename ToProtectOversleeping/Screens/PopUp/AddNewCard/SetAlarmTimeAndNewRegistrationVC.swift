////
////  SetAlarmTimeAndNewRegistrationVC.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/05/04.
////
//
//import UIKit
//
//class SetAlarmTimeAndNewRegistrationVC: UIViewController {
//
//    var userName = ""
//
//    // 起きる時間のカード
//    var setAlarmTimeAndNewRegistrationView = SetAlarmTimeAndNewRegistrationView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureView()
//        configureAddTarget()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.view.layoutIfNeeded()
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        self.tabBarController?.tabBar.isHidden = false
//    }
//
//    func configureAddTarget() {
//        setAlarmTimeAndNewRegistrationView.wakeUpGoBuckButton.addTarget(self, action: #selector(tapToDismiss), for: .touchUpInside)
//        setAlarmTimeAndNewRegistrationView.chatTeamNewRegisterButton.addTarget(self, action: #selector(registerNewTeam), for: .touchUpInside)
//        setAlarmTimeAndNewRegistrationView.chatTeamNewInvitedButton.addTarget(self, action: #selector(invitedToTeam), for: .touchUpInside)
//    }
//
//
//    // ここで目覚ましをセット
//    @objc func tapToDismiss() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    // 新規登録
//    @objc func registerNewTeam() {
//        print("新規登録します")
//        let setNewTeamMateNameVC = SetNewTeamMateNameVC()
//
//        // 新規登録時にアラームも同時タイミングでセットしたいので、値を渡して画面遷移を行う
////        setNewTeamMateNameVC.wakeUpTimeText = setAlarmTimeAndNewRegistrationView.wakeUpTimeText
////        setNewTeamMateNameVC.wakeUpTimeDate = setAlarmTimeAndNewRegistrationView.wakeUpTimeDate
////        print("setNewTeamMateNameVC.wakeUpTimeText: ",setNewTeamMateNameVC.wakeUpTimeText)
////        print("setNewTeamMateNameVC.wakeUpTimeDate: ",setNewTeamMateNameVC.wakeUpTimeDate)
//
////        if setNewTeamMateNameVC.wakeUpTimeText == "" {
////            return
////        } else {
////            setNewTeamMateNameVC.modalPresentationStyle = .overFullScreen
////            setNewTeamMateNameVC.modalTransitionStyle = .crossDissolve
////            self.present(setNewTeamMateNameVC, animated: true, completion: nil)
////        }
//    }
//
//    // 招待してもらう
//    @objc func invitedToTeam() {
//        print("招待してもらいました")
//        let setInvitedTeamMateVC = SetInvitedTeamMateVC()
//        // 招待時にアラームも同時タイミングでセットしたいので、値を渡して画面遷移を行う
//        setInvitedTeamMateVC.wakeUpTimeText = setAlarmTimeAndNewRegistrationView.wakeUpTimeText
//        setInvitedTeamMateVC.wakeUpTimeDate = setAlarmTimeAndNewRegistrationView.wakeUpTimeDate
//        setInvitedTeamMateVC.userName = self.userName
//        print("setInvitedTeamMateVC.wakeUpTimeText: ",setInvitedTeamMateVC.wakeUpTimeText)
//        print("setInvitedTeamMateVC.wakeUpTimeDate: ", setInvitedTeamMateVC.wakeUpTimeDate)
//        if setInvitedTeamMateVC.wakeUpTimeText == "" {
//            return
//        } else {
//            setInvitedTeamMateVC.modalPresentationStyle = .overFullScreen
//            setInvitedTeamMateVC.modalTransitionStyle = .crossDissolve
//            self.present(setInvitedTeamMateVC, animated: true, completion: nil)
//        }
//
//    }
//
//
//    // チームへ招待する
//    @objc func invitedFromTeam() {
//        print("招待しました")
//        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
//        wakeUpAndCutAlertBySlideVC.mySettingAlarmTime = setAlarmTimeAndNewRegistrationView.datePicker.date
//        navigationController?.pushViewController(wakeUpAndCutAlertBySlideVC, animated: true)
//    }
//
//    func configureView() {
//        configureBlurView()
//        configureCardView()
//    }
//
//    func configureCardView(){
//        setAlarmTimeAndNewRegistrationView.translatesAutoresizingMaskIntoConstraints = false
//        setAlarmTimeAndNewRegistrationView.layer.cornerRadius = 16
//        view.addSubview(setAlarmTimeAndNewRegistrationView)
//
//        NSLayoutConstraint.activate([
//            setAlarmTimeAndNewRegistrationView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
//            setAlarmTimeAndNewRegistrationView.heightAnchor.constraint(equalToConstant: 380),
//            setAlarmTimeAndNewRegistrationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            setAlarmTimeAndNewRegistrationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//
//    func configureBlurView() {
//        let blurEffect = UIBlurEffect(style: .dark)
//        let visualEffectView = UIVisualEffectView(effect: blurEffect)
//        visualEffectView.frame = self.view.frame
//        view.addSubview(visualEffectView)
//    }
//}
//
//extension SetAlarmTimeAndNewRegistrationVC: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        resignFirstResponder()
//    }
//}
