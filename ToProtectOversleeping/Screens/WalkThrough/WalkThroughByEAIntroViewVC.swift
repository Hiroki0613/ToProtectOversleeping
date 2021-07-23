//
//  WalkThroughByEAIntroViewVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/23.
//

import UIKit
import EAIntroView

class WalkThroughByEAIntroViewVC: UIViewController {
    
    let page1 = EAIntroPage()
    let page2 = EAIntroPage()
    let page3 = EAIntroPage()
    let page4 = EAIntroPage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        configureUI()
        
        let introView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3, page4])
        //スキップボタン
        introView?.skipButton.setTitle("スキップ", for: UIControl.State.normal)
        introView?.show(in: self.view, animateDuration: 0.3)
        introView?.delegate = self
    }
    
    func configureUI() {
        // page1
        configureIntroPage(
            page: page1,
            titleString: "インストールありがとうございます！!",
            descString: "\n目指したい目標達成に向かって、\n朝の時間を有意義に使ってもらいたい\nと思い開発しました。\n\nアプリがあなたの目標達成の\n手助けになれば幸いです。",
            titleIconImageNameString: WalkThrough.thanksIcon)
        // page2
        configureIntroPage(
            page: page2,
            titleString: "アラームは鳴りません",
            descString: "\nGPS、チャット機能を活用した\n報告型アプリです。\n\nチームの👀がアラーム代りです",
            titleIconImageNameString: WalkThrough.notAlarmIcon)
        // page3
        configureIntroPage(
            page: page3,
            titleString: "簡単な使いかた",
            descString: "\n起きたい時間をセット\n↓\n設定した時間の２時間以内に\n自宅から20m離れた自販機を撮影(スキャン)！\n↓\nチームのチャットへ起床を通知\n\nさらには正午には起きた人一覧が表示されます",
            titleIconImageNameString: WalkThrough.hotToUseIcon)
        // page4
        configureIntroPage(
            page: page4,
            titleString: "☔️モードも用意",
            descString: "\nもちろん☔️の日も考慮\n\n ただしチームのチャットへは\n「雨モードで起床」と通知されます。\n\n晴れた日は、ぜひ朝の太陽を浴び\n体内時計をリセットして、\n　有意義な1日をお過ごしください！",
            titleIconImageNameString: WalkThrough.rainyDayIcon)
    }
    
    
    func configureIntroPage(page: EAIntroPage,titleString: String, descString: String, titleIconImageNameString: String) {
        // バックグランドカラー
        page.bgColor = PrimaryColor.primary
        // タイトル
        page.title = titleString
        page.titleColor = .systemBackground
        page.titleFont = UIFont(name: WalkThrough.titleFont, size: 24)
        page.titlePositionY = 340
        // ディスクリプション
        page.desc = descString
        page.descColor = .systemBackground
        page.descFont = UIFont(name: WalkThrough.descFont, size: 16)
        page.descPositionY = 320
        // アイコンイメージ
        page.titleIconView = UIImageView.init(image:UIImage(named: titleIconImageNameString)! )
//        page.titleIconView = UIImageView.init(image: UIImage(systemName: "figure.wave")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)))
        page.titleIconPositionY = 100
    }
    
    func presentToNewRegistrationUserNameVC() {
        let newRegistrationUserNameVC = NewRegistrationUserNameVC()
        navigationController?.pushViewController(newRegistrationUserNameVC, animated: true)
    }
}

extension WalkThroughByEAIntroViewVC: EAIntroDelegate {
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        
        if wasSkipped {
            presentToNewRegistrationUserNameVC()
            print("宏輝＿チュートリアルスキップ")
        } else {
            presentToNewRegistrationUserNameVC()
            print("宏輝_チュートリアル終了")
        }
    }
}
