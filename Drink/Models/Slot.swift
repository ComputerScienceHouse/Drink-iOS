//
//  Slot.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import Foundation

struct Slot: Codable{
    var active, empty: Bool
    var number: Int
    var item: Item
    
}
