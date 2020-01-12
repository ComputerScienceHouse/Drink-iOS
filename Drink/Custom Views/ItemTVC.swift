//
//  ItemTVC.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/8/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit

class ItemTVC: UITableViewCell {
    private var itemNameLabel = UILabel()
    private var priceView: PriceView = PriceView()
    
    var item: Item! {
        didSet{
            itemNameLabel.text = item.name
            priceView.priceLabel.text = "\(item.price)"
            priceView.userCanAffordItem = item.price > 100
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup(){
        backgroundColor = .clear
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.textColor = .label
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 8.0
        self.contentView.addSubview(containerView)
        contentView.addConstraints([
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5.0),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5.0),
            containerView.topAnchor.constraint(equalTo:
                contentView.topAnchor, constant: 5.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
        ])
        containerView.addSubview(itemNameLabel)
        containerView.addConstraints([
            itemNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            itemNameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10.0),
            itemNameLabel.heightAnchor.constraint(equalToConstant: 25.0)
        ])
        containerView.addSubview(priceView)
        priceView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints([
            priceView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            priceView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10.0),
            priceView.heightAnchor.constraint(equalToConstant: 42.0),
            priceView.widthAnchor.constraint(equalToConstant: 80.0)
        ])
        
        
        
    }
    
}
