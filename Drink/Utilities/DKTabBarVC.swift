//
//  DKTabBarVC.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit
import SwiftUI

//called when a user logs in or logs out
protocol SessionDelegate{
    func userDidSignIn()
    func userDidSignOut()
}

class DKTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NetworkManager.shared.authState == nil{
            let containerVC = AppAuthViewController()
            containerVC.isModalInPresentation = true
            self.present(containerVC, animated: true, completion: nil)
        }
    }
    
}
