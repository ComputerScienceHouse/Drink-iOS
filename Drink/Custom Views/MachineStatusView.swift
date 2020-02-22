//
//  MachineStatusView.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/24/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit

enum MachineStatus{
    case enabled
    case disabled
}
class MachineStatusView: UITableViewHeaderFooterView {
    private var colorView: UIView!
    private var machineStatusLabel: UILabel!
    
    var machineStatus: MachineStatus?{
        didSet{
            if machineStatus == .enabled{
               machineStatusLabel.text = "Online"
                colorView.backgroundColor = .systemGreen
            }
            else{
                machineStatusLabel.text = "Offline"
                colorView.backgroundColor = .systemRed
                
            }
            
        }
    }
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor = .systemGray
        self.addSubview(colorView)
        machineStatusLabel = UILabel()
        machineStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        machineStatusLabel.text = "Fetching Status..."
        self.addSubview(machineStatusLabel)
        
        self.addConstraints([
            colorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            colorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            colorView.heightAnchor.constraint(equalToConstant: 20.0),
            colorView.widthAnchor.constraint(equalToConstant: 20.0)
            
        ])
        
        self.addConstraints([
            machineStatusLabel.leftAnchor.constraint(equalTo: colorView.rightAnchor, constant: 5),
            machineStatusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        colorView.layer.cornerRadius = 10

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
