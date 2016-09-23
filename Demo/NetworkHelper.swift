//
//  NetworkHelper.swift
//  Demo
//
//  Created by Shawn Roller on 9/22/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class NetworkHelper {
    
    func login(email: String, password: String, loggedIn: @escaping (Bool) -> Void) {
        if self.checkConnection() {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if user != nil && error == nil {
                    loggedIn(true)
                } else {
                    loggedIn(false)
                }
            }
        }
    }
    
    func logout() {
        
        try! FIRAuth.auth()?.signOut()
        
    }
    
    func checkConnection() -> Bool {
        
        return Reachability.isConnectedToNetwork()
        
    }
    
    func checkUserSignInStatus() -> Bool {
        
        var signedIn = false
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if let _ = user {
                signedIn = true
            }
            
        })
        
        return signedIn
        
    }

}
