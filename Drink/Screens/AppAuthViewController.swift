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

let loginDismissedKey = "edu.rit.csh.loginDismissed"

class AppAuthViewController: UIViewController, WelcomeViewDelegate {
    var hostingController: UIHostingController<WelcomeView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var view = WelcomeView()
        view.delegate = self
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
                                                  scopes: [OIDScopeOpenID, OIDScopeProfile],
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
                    DispatchQueue.main.async {
                        self.postNotification()
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    NetworkManager.shared.authState = authState
                }
            }
        }
    }
    
    
    private func postNotification(){
        let name = Notification.Name(loginDismissedKey)
        NotificationCenter.default.post(name: name, object: nil)
    }
    
}

