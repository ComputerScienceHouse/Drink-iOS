//
//  ProfilePictureImageView.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/7/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit

class ProfilePictureButton: UIButton {
    
    
    init(imageUrl: String){
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let url = URL(string: "https://profiles.csh.rit.edu/image/lontronix")!
        let data = try? Data(contentsOf: url)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            self.setImage(image, for: .normal)
            self.imageView?.contentMode = .scaleAspectFit

        }
       
        self.imageView?.layer.cornerRadius = self.frame.size.width / 2.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.widthAnchor.constraint(equalToConstant: 30).isActive = true

        
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
