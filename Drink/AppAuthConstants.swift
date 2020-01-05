//
//  AppAuthConstants.swift
//  Drink
//
//  Created by Lonnie Gerol on 12/30/19.
//  Copyright © 2019 Lonnie Gerol. All rights reserved.
//

import Foundation

struct AppAuthConstants{
    static let kIssuer =  URL(string: "https://sso.csh.rit.edu/auth/realms/csh")!
    static let kClientID = ""
    static let kRedirectURI = URL(string: "edu.rit.csh.drink:/callback")!
    static let clientSecret = ""

    
}
