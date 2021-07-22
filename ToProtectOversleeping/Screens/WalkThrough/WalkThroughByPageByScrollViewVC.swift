//
//  WalkThroughByPageByScrollViewVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/22.
//

import UIKit
import Lottie

class WalkThroughByPageByScrollViewVC: UIViewController {
    
    //説明文を入れた配列
    var onboardStringArray = ["私達はみんな繋がっています。","どこからでも届けよう！","ショッピングモールにも","箱には楽しみが詰まっています！","待っている人に最高の喜びを！"]
    //ファイル名
    var animationArray = [Lottie.alarmClock, Lottie.forestMorning, Lottie.chatBubblesInsidePhone, Lottie.vaporwaveVendingMachine, Lottie.alarmClock]
    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemOrange
        configureUI()
        setUpScroll()

    }
    
    func configureUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        navigationController?.isNavigationBarHidden = true
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
        
        //アニメーション
        
        for i in 0...4 {
            let animationView = AnimationView()
            let animation = Animation.named(animationArray[i])
            animationView.frame = CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            scrollView.addSubview(animationView)
        }
        
    }
    
    func setUpScroll() {
        
        //スクロールビューを貼り付ける
        
        scrollView.contentSize = CGSize(width: view.frame.size.width * 5, height: view.frame.size.height - 80)
        
        
        for i in 0...4 {
            
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height/3, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            
            onboardLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            onboardLabel.textAlignment = .center
            onboardLabel.text = onboardStringArray[i]
            scrollView.addSubview(onboardLabel)
        }
    }
    

 

}
