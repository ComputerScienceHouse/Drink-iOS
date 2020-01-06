//
//  ItemsListTableVC.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit

class ItemsListVC: UIViewController {
    var noDataLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        noDataLabel.text = "No Data"
        self.view.addSubview(noDataLabel)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints([
            noDataLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ran2113")
    }


}
