//
//  WakeUpCardCollectionListVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/03.
//

import UIKit

class WakeUpCardCollectionListVC: UIViewController {
    
    // 参考URL
    // https://www.hfoasi8fje3.work/entry/2019/02/14/000000
    // https://qiita.com/Queue0412/items/0984c8d1a757935f140f

    
    let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

//    let collectionView = UICollectionView()
    let flowLayout = UICollectionViewFlowLayout()

//    let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    
    func configureCollectionView() {
        flowLayout.itemSize = CGSize(width: view.frame.width, height: view.frame.width)
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .systemOrange
        
        collectionView.register(WakeUpCardCollectionListCell.self, forCellWithReuseIdentifier: WakeUpCardCollectionListCell.reuseID)
        
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height),collectionViewLayout: UICollectionViewLayout())
        
//        let collectionView: UICollectionView = {
//                //セルのレイアウト設計
//                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//
//                //各々の設計に合わせて調整
//                layout.scrollDirection = .vertical
//                layout.minimumInteritemSpacing = 0
//                layout.minimumLineSpacing = 0
//
//                let collectionView = UICollectionView( frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height ), collectionViewLayout: layout)
//                collectionView.backgroundColor = UIColor.white
//
//
//                //セルの登録
//            collectionView.register(WakeUpCardCollectionListCell.self, forCellWithReuseIdentifier: WakeUpCardCollectionListCell.reuseID)
//                return collectionView
//            }()
        
        
//        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        collectionView.backgroundColor = .systemGreen
//        collectionView.register(WakeUpCardCollectionListCell.self, forCellWithReuseIdentifier: WakeUpCardCollectionListCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
}


extension WakeUpCardCollectionListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("タップされました: ", indexPath.row)
        let wakeUpDetailCardVC = WakeUpDetailCardVC()
        wakeUpDetailCardVC.modalPresentationStyle = .overFullScreen
        wakeUpDetailCardVC.modalTransitionStyle = .crossDissolve
        self.present(wakeUpDetailCardVC, animated: true, completion: nil)
    }
}


extension WakeUpCardCollectionListVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WakeUpCardCollectionListCell.reuseID, for: indexPath) as! WakeUpCardCollectionListCell
        return cell
    }
}


extension WakeUpCardCollectionListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
