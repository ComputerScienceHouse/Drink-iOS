//
//  LoadingView.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/11/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    private var loadingImageView = UIImageView()
    private var infoLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 0.75)
               infoLabel.frame = CGRect(x: 0, y: loadingImageView.frame.height, width: self.frame.width, height: self.frame.height * 0.25)
               sizeToFit()
        
      
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
       
    }
    private func setup(){
        loadingImageView.image = UIImage(named: "soda-can")
        loadingImageView.contentMode = .scaleAspectFit
        infoLabel.text = "Fetching Drinks..."
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        self.addSubviews(subviews: [infoLabel, loadingImageView])
    }
}
