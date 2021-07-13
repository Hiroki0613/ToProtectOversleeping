//
//  WakeUpCardTableListHeaderView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/14.
//

import UIKit

class WakeUpCardTableListHeaderView: UIView {
    
    var transparentView = UIView()
    var headerView = UIView()
    
    var leftSwipeLabel = WUBodyLabel(fontSize: 10)
    var rightSwipeLabel = WUBodyLabel(fontSize: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingInformation() {
        headerView.layer.cornerRadius = 16
        leftSwipeLabel.text = "ununi"
        rightSwipeLabel.text = "unyounyo"
    }
    
    private func configureUI() {
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(transparentView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        transparentView.addSubview(headerView)
        leftSwipeLabel.translatesAutoresizingMaskIntoConstraints = false
        transparentView.addSubview(leftSwipeLabel)
        rightSwipeLabel.translatesAutoresizingMaskIntoConstraints = false
        transparentView.addSubview(rightSwipeLabel)
        
        let padding: CGFloat = 10.0
        
        NSLayoutConstraint.activate([
            transparentView.topAnchor.constraint(equalTo: self.topAnchor),
            transparentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            transparentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: padding),
            headerView.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -padding),
            headerView.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -padding),
            
            leftSwipeLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: padding),
            leftSwipeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: padding),
            leftSwipeLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -padding),
            leftSwipeLabel.bottomAnchor.constraint(equalTo: rightSwipeLabel.topAnchor, constant: padding),
            
            rightSwipeLabel.topAnchor.constraint(equalTo: leftSwipeLabel.topAnchor, constant: padding),
            rightSwipeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: padding),
            rightSwipeLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -padding),
            rightSwipeLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -padding)
        ])
    }
}
