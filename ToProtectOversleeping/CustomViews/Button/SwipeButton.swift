//
//  SwipeButton.swift
//  slideButtonAciton
//
//  Created by 近藤宏輝 on 2021/05/02.
//


import UIKit

protocol GetGeocoderDelegate {
    func getAddressFromCurrentPlace()
}

class SwipeButton: UIView {
    
    var getGeocoderDelegate: GetGeocoderDelegate?
    
    var borderColor:  UIColor = .black
    var borderWidth:  CGFloat = 2.0
    var cornerRadius: CGFloat = 10.0
    var duration:     Double  = 0.8
    
    var frontColor : UIColor = .systemOrange {
        didSet {
            self.button.backgroundColor = frontColor
        }
    }
    var groundColor : UIColor = .systemGray.withAlphaComponent(0.5) {
        didSet {
            self.bar.backgroundColor = groundColor.withAlphaComponent(0.5)
        }
    }
    var backColor : UIColor = .clear {
        didSet {
            self.backgroundColor = backColor
        }
    }
    var textColor : UIColor = .label {
        didSet {
            self.textLabel.textColor = textColor
        }
    }
        
    var swipedFrontColor : UIColor = .systemOrange
    var swipedGroundColor : UIColor = .darkGray
    var swipedTextColor : UIColor = .systemOrange
    
    var textFont : UIFont = UIFont.systemFont(ofSize: 20) {
        didSet {
            self.textLabel.font = textFont
        }
    }
    
    var barHeight: CGFloat = 40.0 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public var isRightToLeft: Bool = true {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public var text: String? = nil {
        didSet {
            self.layoutSubviews()
        }
    }
    public var swipedText: String?
    
    private var startFrame:CGRect!
    private var turnedFrame:CGRect!
    private var moveTo = CGFloat(0)
    
    public lazy var textLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.textColor = textColor
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = textFont
        return label
    }()
    
    public lazy var bar: UIView = { [unowned self] in
        let view = UIView()
        view.backgroundColor = groundColor.withAlphaComponent(0.5)
        return view
    }()
    
    public lazy var button: RoundView = { [unowned self] in
        let view = RoundView()
        view.backgroundColor = frontColor
        view.layer.borderColor = UIColor.systemBackground.cgColor
        view.layer.borderWidth = 3.0
        view.delegate = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commInt()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commInt()
    }
    
    public convenience init(_ text: String?) {
        self.init()
        self.text = text
        self.commInt()
    }
    func commInt() {
        self.backgroundColor = backColor
        
        self.addSubview(bar)
        self.bar.addSubview(textLabel)
        self.addSubview(button)
        self.bringSubviewToFront(button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.touchSize = self.frame.size
        let maxWidth: CGFloat = self.frame.width
        let maxHeight: CGFloat = self.frame.height
        if barHeight > maxHeight {
            barHeight = maxHeight
        }
        if barHeight < 10 {
            textLabel.isHidden = true
        }
        self.bar.frame = CGRect(x: 0, y: (maxHeight - barHeight) / 2, width: maxWidth, height: barHeight)
        if self.text != nil,!textLabel.isHidden {
            textLabel.text = self.text
            textLabel.frame = CGRect(origin: .zero, size: bar.frame.size)
        } else {
            textLabel.frame = CGRect.zero
        }
        let leftFrame = CGRect(x: 0, y: 0, width: maxHeight, height: maxHeight)
        let rightFrame  = CGRect(x: (maxWidth - maxHeight), y: 0, width: maxHeight, height: maxHeight)
        if isRightToLeft {
            self.startFrame = rightFrame
            self.turnedFrame = leftFrame
        } else {
            self.startFrame = leftFrame
            self.turnedFrame = rightFrame
        }
        button.frame = startFrame
        
        if isEnabled {
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
        self.corner(bar)
        self.corner(button)
        if borderWidth > 0 {
            self.bouder(bar, width: borderWidth, color: borderColor)
        }
    }
}

extension SwipeButton {
    func bouder(_ view: UIView, width: CGFloat, color: UIColor) {
        view.layer.masksToBounds = true
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
    }
    
    func corner(_ view: UIView, radius: CGFloat = 0) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = (radius > 0) ? radius : (view.frame.height / 2)
    }
}

extension SwipeButton {
    func swipeToGo() {
        UIView.animate(withDuration: self.duration, animations: {
            self.button.frame = self.turnedFrame
        }){ (completed) in
            // ここにボタンがスワイプされた時の処理を書く
            self.button.backgroundColor = self.swipedFrontColor
            self.bar.backgroundColor = self.swipedGroundColor.withAlphaComponent(0.7)
            self.textLabel.textColor = self.swipedTextColor
            if let swipedText = self.swipedText {
                self.textLabel.text = swipedText
                self.getGeocoderDelegate?.getAddressFromCurrentPlace()
            }
            UIView.animate(withDuration: self.duration, delay: 5.0) {
                self.swipeToBack()
            } completion: { completed in
                print("completed: ",completed)
            }
        }
    }
    
    func swipeToBack() {
        UIView.animate(withDuration: self.duration, animations: {
            self.button.frame = self.startFrame
        }){ (completed) in
            self.button.backgroundColor = self.frontColor
            self.bar.backgroundColor = self.groundColor.withAlphaComponent(0.5)
            self.textLabel.textColor = self.textColor
            if let text = self.text {
                self.textLabel.text = text
            } else {
                self.textLabel.text = nil
            }
        }
    }
}

// MARK: - RoundViewDelegate
extension SwipeButton : RoundViewDelegate{
    func roundViewTouchesEnded() {
        if self.button.center.x > (self.frame.width / 2) {
            if self.isRightToLeft {
                // ここはデッドコードになる
                //                swipeToBack()
            } else {
                //ここでスワイプしたときの処理が描かれる、1回だけ処理をさせる
                swipeToGo()
            }
        } else {
            if self.isRightToLeft {
                // ここはデッドコードになる
                //                swipeToGo()
                
                
            } else {
                //ここにボタンスワイプ終了の
                swipeToBack()
            }
        }
    }
}
protocol RoundViewDelegate: AnyObject {
    func roundViewTouchesEnded() -> Void
}

class RoundView: UIView {
    weak var delegate: RoundViewDelegate?
    public var touchSize: CGSize!
    private var locationInitialTouch:CGPoint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let location = touch.location(in: self)
        print(" Began:(\(location.x), \(location.y))")
        locationInitialTouch = location
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let location = touch.location(in: self)
        if location.x < 0 || location.x > touchSize.width { return }
        if location.y < 0 || location.y > touchSize.height { return }
        print(" Moved:(\(location.x), \(location.y))")
        let f = frame.offsetBy(dx: location.x - locationInitialTouch.x, dy: 0)
        if (f.minX >= 0 && f.maxX <= touchSize.width) {
            frame = f
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            delegate?.roundViewTouchesEnded()
        }
        guard let touch = touches.first else{
            return
        }
        let location = touch.location(in: self)
        if location.x < 0 || location.x > touchSize.width {
            return
        }
        if location.y < 0 || location.y > touchSize.height {
            return
        }
        print(" Ended:(\(location.x), \(location.y))")
        let f = frame.offsetBy(dx: location.x - locationInitialTouch.x, dy: 0)
        if (f.minX >= 0 && f.maxX <= touchSize.width) {
            frame = f
        }
    }
}
