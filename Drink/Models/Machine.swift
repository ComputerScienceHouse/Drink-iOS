//
//  Machine.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import Foundation
struct Machine: Codable{
    var displayName: String
    var isOnline: String
    var slots: [Slot]
}

