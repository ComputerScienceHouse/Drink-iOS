//
//  NetworkManager.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import Foundation
import AppAuth

enum Machines: String{
    case littleDrink = "littledrink"
    case bigDrink = "bigdrink"
}
class NetworkManager{
    static let shared = NetworkManager()
    let baseURL = "https://mizu.csh.rit.edu:443"
    private var authState: OIDAuthState?
    
    private init(){}
    
    func getItems(in machine: Machines, completed: @escaping (Machine?, String?) -> Void){
        //drinks?machine=littledrink
        let endpoint = baseURL + "/drinks?machine=\(machine.rawValue)"
        // not a valid URL
        guard let url = URL(string: endpoint) else{
            completed(nil, "Invalid URL to request items from a machine")
            return
        }
        
        self.authState?.performAction(){ accessToken, idToken, error in
            if error != nil{
                print("Error fetching fresh tokens: \(error?.localizedDescription ?? "unknown error")")
                completed(nil, nil)
            }
            guard let accessToken = accessToken else{
                return
            }
            
            // Add Bearer toke to request
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = ["Authorization" : "Bearer \(accessToken)"]
            
            let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
                if let _ = error{
                    completed(nil, "an error occured")
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                    completed(nil, "an error occured")
                    return
                }
                
                guard let data = data else{
                    completed(nil, "an error occured")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let machine = try decoder.decode(Machine.self, from: data)
                    completed(machine ,nil)
                } catch{
                    completed(nil, "an error occured")
                }
            }
            //starts network call
            task.resume()
            
        }
        
    }
        
}
