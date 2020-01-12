//
//  PriceView.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/8/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit


class PriceView: UIView {
    var priceLabel = UILabel()
    var label = UILabel()
    var userCanAffordItem: Bool!{
        didSet{
            if userCanAffordItem{
                self.backgroundColor = .systemGreen
            }
            else{
                self.backgroundColor = .systemRed

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        priceLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height / 2.0)
        label.frame = CGRect(x: 0, y: self.frame.height / 2.0, width: self.frame.width, height: self.frame.height / 2.0)
    }
    
    fileprivate func setupUI(){
        self.layer.cornerRadius = 8.0
        label.text = "Credits"
        priceLabel.textAlignment = .center
        priceLabel.textColor = .white
        label.textColor = .white
        label.textAlignment = .center
        self.addSubview(priceLabel)
        self.addSubview(label)
        priceLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height / 2.0)
        label.frame = CGRect(x: 0, y: self.frame.height / 2.0, width: self.frame.width, height: self.frame.height / 2.0)
        
        
    }
    
}
