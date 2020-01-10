//
//  PriceView.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/8/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit
enum PriceState{
    case canAfford
    case cantAfford
    case outOfStock
}
class PriceView: UIView {
    var priceLabel = UILabel()
    
    init(priceState: PriceState){
        super.init(frame: .zero)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(priceLabel)
        self.addConstraints([
            priceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        switch priceState{
            case .canAfford:
                backgroundColor = .red
            case .cantAfford:
                print("test")
                backgroundColor = .green
            case .outOfStock:
                backgroundColor = .gray
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
