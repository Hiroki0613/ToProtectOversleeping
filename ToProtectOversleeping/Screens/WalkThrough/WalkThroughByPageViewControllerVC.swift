////
////  WalkThroughVC.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/07/22.
////
//
//import UIKit
//import Lottie
//
//class WalkThroughVC: UIViewController {
//
//    lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//    var walkThroughViewControllers: [UIViewController] = []
//    lazy var pageControl = UIPageControl()
//    let nextButton = UIButton()
//    var imagesArray: [AnimationView] = []
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemOrange
//
//        imagesArray = [
//            lottieView(lottieJsonString: Lottie.alarmClock, loopMode: .loop),
//            lottieView(lottieJsonString: Lottie.forestMorning, loopMode: .loop),
//            lottieView(lottieJsonString: Lottie.chatBubblesInsidePhone, loopMode: .loop),
//            lottieView(lottieJsonString: Lottie.vaporwaveVendingMachine, loopMode: .loop)
//        ]
//
//        let contentRect = CGRect(x: 40, y: 240, width: view.bounds.width - 80, height: 340)
//
//        for index in 0 ..< imagesArray.count {
//            let viewController = UIViewController()
//            viewController.view.backgroundColor = .white
//            let uiview = UIView()
//            uiview.frame.size = contentRect.size
//            uiview.addSubview(imagesArray[index])
////            viewController.view.tag = index
//            viewController.view.addSubview(uiview)
//            walkThroughViewControllers.append(viewController)
//        }
//
//        pageViewController.dataSource = self
//        pageViewController.delegate = self
//        pageViewController.setViewControllers([walkThroughViewControllers.first!], direction: .forward, animated: true, completion: nil)
//        pageViewController.view.frame = contentRect
//        view.addSubview(pageViewController.view!)
//
//        nextButton.frame = CGRect(x: 40, y: view.bounds.size.height - 100, width: view.bounds.size.width - 80, height: 40)
//        nextButton.setTitle("Next", for: .normal)
//        nextButton.layer.cornerRadius = 16
//        nextButton.clipsToBounds = true
//        nextButton.backgroundColor = .systemGray
//        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
//        view.addSubview(nextButton)
//
//    }
//
//    @objc func nextButtonTapped() {
//        print("宏輝_nextButtonTapped")
//    }
//
//    func lottieView(lottieJsonString: String, loopMode: LottieLoopMode) -> AnimationView {
//        let embedLotteView = UIView()
//        embedLotteView.frame = view.frame
////        embedLotteView.frame = CGRect(x: 0, y: 0, width:embedLotteView.bounds.width, height: embedLotteView.bounds.height)
////        let animationView = AnimationView(name: lottieJsonString)
//        let animationView = AnimationView()
////        animationView.frame = CGRect(x: 0, y: 0, width:embedLotteView.bounds.width, height: embedLotteView.bounds.height)
//        animationView.frame = view.frame
//        animationView.center = embedLotteView.center
//        animationView.loopMode = loopMode
//        animationView.contentMode = .scaleAspectFit
//        animationView.animationSpeed = 1
//        let animation = Animation.named(lottieJsonString)
//        animationView.animation = animation
//        animationView.play()
//        return animationView
//    }
//
//    private func setNextButtonStatus(index: Int) {
//        if index == imagesArray.count - 1 {
//            // last page
//            nextButton.backgroundColor = .systemOrange
//            nextButton.isEnabled = true
//        } else {
//            // 他のページ
//            nextButton.backgroundColor = .systemGray
//            nextButton.isEnabled = false
//        }
//    }
//
//
//}
//
//extension WalkThroughVC: UIPageViewControllerDataSource {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        var index = viewController.view.tag
//        pageControl.currentPage = index
//        setNextButtonStatus(index: index)
//
//        if index == imagesArray.count - 1 {
//            return nil
//        }
//        index = index + 1
//        return walkThroughViewControllers[index]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        var index = viewController.view.tag
//        pageControl.currentPage = index
//        setNextButtonStatus(index: index)
//
//        index = index - 1
//        if index < 0 {
//            return nil
//        }
//
//        return walkThroughViewControllers[index]
//    }
//}
//
//extension WalkThroughVC: UIPageViewControllerDelegate {
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        print("宏輝_didFinishAnimating")
//    }
//}
