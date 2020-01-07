//
//  Machine.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import Foundation

struct Machines: Codable{
    let machines: [Machine]
    let message: String
}

struct Machine: Codable{
    let displayName: String
    let isOnline: Bool
    var slots: [Slot]
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case isOnline = "is_online"
        case slots
    }
    
     mutating func removeEmptySlots() {
        self.slots = slots.filter {
              $0.item.name != "Empty"
          }
      }
    
}

