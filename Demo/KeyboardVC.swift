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
    
    func setupKeyboardScrolling(sender: KeyboardVC) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.viewOrigin = sender.view.frame.origin.y
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject: AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if kbHidden {
                kbHidden = false
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height / 2
                })
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        kbHidden = true
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let _: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y = self.viewOrigin
    }
    
    func simulateNetworkCall(username: String, password: String) -> (Bool, String) {
        
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        kbHidden = true
        self.view.endEditing(true)
        
    }
    
    func displayAlert(sender: String, title:String, message:String, buttonAction: String, alertColor: UIColor) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: buttonAction, style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        alert.view.tintColor = alertColor
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}
