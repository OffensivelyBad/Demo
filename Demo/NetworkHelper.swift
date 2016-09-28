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
    
    let url = NSURL(string: "\(_WEB_ADDRESS).json?auth=\(_SECRET)")
    
    func login(email: String, password: String, loggedIn: @escaping (Bool) -> Void) {
        if self.checkConnection() {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if user != nil && error == nil {
                    loggedIn(true)
                } else {
                    loggedIn(false)
                }
            }
        } else {
            loggedIn(false)
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
    
    func getData(dataAcquired: @escaping (_ data: [Person], _ success: Bool) -> Void) {
        
        let session = URLSession.shared
        if let url = self.url {
            let urlRequest = URLRequest(url: url as URL)
            session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
                    
                if error == nil && data != nil {
                    do {
                        let dataDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                        //parse the json
                        if let objects = dataDict["blenders"] as? [[String: String]] {
                            var blenderArr = [Person]()
                            for object in objects {
                                if let name = object["name"], let birthDate = object["birthDate"], let imageURL = object["image"] {
                                    let imageView = UIImageView()
                                    imageView.downloadedFrom(link: imageURL) { (downloaded) in
                                        let newBlender = Person(name: name, birthDate: Date(dateString: birthDate), image: imageView.image)
                                        blenderArr.append(newBlender)
                                        if blenderArr.count == objects.count {
                                            dataAcquired(blenderArr, true)
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        //catch conversion error
                        dataAcquired([], false)
                    }
                } else {
                    print("\(error)")
                    dataAcquired([], false)
                }
                    
            }).resume()
        }
        
    }

}
