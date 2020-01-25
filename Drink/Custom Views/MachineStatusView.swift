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
class MachineStatusView: UIView {
    private var colorView: UIView!
    private var machineStatusLabel: UILabel!
    
    var machineStatus: MachineStatus = .disabled {
        didSet{
            print("machine status set")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
