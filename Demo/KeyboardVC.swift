//
//  KeyboardVC.swift
//  Demo
//
//  Created by Shawn Roller on 7/24/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

class KeyboardVC: UIViewController {
    
    var kbHidden = true
    var viewOrigin = CGFloat()
    
    let username = "Gary"
    let password = "test"
    
    func setupKeyboardScrolling(_ sender: KeyboardVC) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.viewOrigin = sender.view.frame.origin.y
        
    }
    
    func keyboardWillShow(_ sender: Notification) {
        
        let userInfo: [AnyHashable: Any] = (sender as NSNotification).userInfo!
        
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if kbHidden {
                kbHidden = false
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height / 2
                })
            }
        }
    }
    
    func keyboardWillHide(_ sender: Notification) {
        kbHidden = true
        let userInfo: [AnyHashable: Any] = (sender as NSNotification).userInfo!
        let _: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        self.view.frame.origin.y = self.viewOrigin
    }
    
    func simulateNetworkCall(_ username: String, password: String) -> (Bool, String) {
        
        var success = true
        var error = ""
        if Reachability.isConnectedToNetwork() {
            if username == self.username {
                if password == self.password {
                    //do nothing
                } else {
                    success = false
                    error = "Incorrect password"
                }
            } else {
                success = false
                error = "Incorrect username"
            }
        } else {
            success = false
            error = "Network Connection Failed"
        }
        
        return (success, error)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        kbHidden = true
        self.view.endEditing(true)
        
    }
    
    func displayAlert(_ sender: String, title:String, message:String, buttonAction: String, alertColor: UIColor) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonAction, style: .default, handler: { (action) -> Void in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        alert.view.tintColor = alertColor
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
