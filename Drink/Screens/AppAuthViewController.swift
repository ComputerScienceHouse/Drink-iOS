//
//  ViewController.swift
//  Drink
//
//  Created by Lonnie Gerol on 12/30/19.
//  Copyright © 2019 Lonnie Gerol. All rights reserved.
//

import UIKit
import SwiftUI
import AppAuth


protocol WelcomeViewDelegate{
    func userTappedSignInButton()
}


class AppAuthViewController: UIViewController, WelcomeViewDelegate {
    var hostingController: UIHostingController<WelcomeView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var view = WelcomeView()
        view.delegate = self
        self.isModalInPresentation = true
        hostingController = UIHostingController(rootView: view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostingController.view)
        self.view.addConstraints([
            hostingController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            hostingController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor)])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    func userTappedSignInButton() {
        OIDAuthorizationService.discoverConfiguration(forIssuer: AppAuthConstants.kIssuer) { (configuration, error) in
            guard let config = configuration else{
                print("Error retrieving discovery document: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            // builds authentication request
            let request = OIDAuthorizationRequest(configuration: config,
                                                  clientId: AppAuthConstants.kClientID,
                                                  clientSecret: AppAuthConstants.clientSecret,
                                                  scopes: [OIDScopeOpenID, OIDScopeProfile, "offline_access"],
                                                  redirectURL: AppAuthConstants.kRedirectURL,
                                                  responseType: OIDResponseTypeCode,
                                                  additionalParameters: nil)
            
            //performs authentication request
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: self) { (authState, error) in
                if let authState = authState{
                    NetworkManager.shared.authState = authState
                    authState.stateChangeDelegate = NetworkManager.shared
                    NetworkManager.shared.saveState()
                    //fetching userinfo
                    
                    authState.performAction(){
                        (accessToken, idToken, error) in
                        let userinfoEndpoint = authState.lastAuthorizationResponse.request.configuration.discoveryDocument!.userinfoEndpoint
                        var urlRequest = URLRequest(url: userinfoEndpoint!)
                        urlRequest.allHTTPHeaderFields = ["Authorization":"Bearer \(accessToken!)"]
                        let task = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
                            
                            DispatchQueue.main.async {
                                
                                var json: [AnyHashable: Any]?
                                do {
                                    json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                                } catch {
                                    //self.logMessage("JSON Serialization Error")
                                }
                                
                                if let json = json {
                                    DispatchQueue.main.async {
                                        NetworkManager.shared.user = User(username: json["preferred_username"] as! String)
                                        self.postNotification()
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                } else {
                                    NetworkManager.shared.authState = authState
                                }
                                
                            }
                        }
                        task.resume()
                    }
             
                    
                }
                
            }
        }
    }
    
    
    
    
    private func postNotification(){
        let name = Notification.Name(loginDismissedKey)
        NotificationCenter.default.post(name: name, object: nil)
    }
    
}

