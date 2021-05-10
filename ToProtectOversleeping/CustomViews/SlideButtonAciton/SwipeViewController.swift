//
//  ViewController.swift
//  slideButtonAciton
//
//  Created by 近藤宏輝 on 2021/05/02.
//

import UIKit

class SwipeViewController: UIViewController {

    var swipeButton: SwipeButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeButton()
    }


    func setupSwipeButton() {
        if swipeButton == nil {
            self.swipeButton = SwipeButton(frame: CGRect(x: 40, y: 200, width: 300, height: 50))
            swipeButton.isRightToLeft = false
            swipeButton.text = "すぐ買う"
            swipeButton.swipedText = "購入いたしました"

            self.view.addSubview(self.swipeButton)
        }
    }
}
