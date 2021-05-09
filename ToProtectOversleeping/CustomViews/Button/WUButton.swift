//
//  WUButton.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/05.
//

import UIKit

class WUButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    convenience init(backgroundColor: UIColor, sfSymbolString: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        let image = UIImage(systemName: sfSymbolString)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30,weight: .bold))
        self.setImage(image, for: .normal)
    }
    
    
    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        setTitleColor(.systemBackground, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
