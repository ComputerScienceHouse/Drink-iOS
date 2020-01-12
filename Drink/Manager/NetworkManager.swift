//
//  NetworkManager.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import Foundation
import AppAuth

enum ExistingMachines: String{
    case littleDrink = "littledrink"
    case bigDrink = "bigdrink"
}

class NetworkManager: NSObject{
    static let shared = NetworkManager()
    let baseURL = "https://drink.csh.rit.edu:443"
    var authState: OIDAuthState?
    
    private override init(){
        super.init()
        authState?.stateChangeDelegate = self
    }
    
        
    func getInfo(for machine: ExistingMachines, completed: @escaping (Machine?, String?) -> Void){
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
                    completed(nil, "an error occured when attempting to communicate with URL")
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                    completed(nil, "unexpected response code")
                    return
                }
                
                guard let data = data else{
                    completed(nil, "data invalid")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let machine = try decoder.decode(Machines.self, from: data)
                    var selectedMachine = machine.machines[0]
                    selectedMachine.removeEmptySlots()
                    
        
                    completed(selectedMachine ,nil)
                } catch{
                    print(error.localizedDescription)
                    completed(nil, "an error occured")
                }
            }
            //starts network call
            task.resume()
        }
    }
    
  
    
    func saveState() {
        var data: Data? = nil
        if let authState = self.authState {
            do{
            try data = NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: true)
            }
            catch{
                print("unable to save appauth state")
            }
        }
        UserDefaults.standard.set(data, forKey: AppAuthConstants.kAppAuthStateKey)
        UserDefaults.standard.synchronize()
    }
    
    func loadState() {
           guard let data = UserDefaults.standard.object(forKey: AppAuthConstants.kAppAuthStateKey) as? Data else {
               return
           }
        do{
        if let authState = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? OIDAuthState {
               self.setAuthState(authState)
           }
        }
        catch{
            print("unable to load state")
        }
       }
    
    func setAuthState(_ authState: OIDAuthState?) {
        if (self.authState == authState) {
            return
        }
        self.authState = authState;
        self.authState?.stateChangeDelegate = self;
        self.saveState()
    }
    
    func signOut(){
        self.authState = nil
        self.saveState()
    }
        
}

extension NetworkManager: OIDAuthStateChangeDelegate{
    func didChange(_ state: OIDAuthState) {
        print("state changed")
        self.saveState()
    }
    
}
