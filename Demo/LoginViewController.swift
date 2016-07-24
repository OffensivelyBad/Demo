//
//  LoginViewController.swift
//  Demo
//
//  Created by Shawn Roller on 7/21/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var kbHidden = true
    var viewOrigin = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initialLoad() {
        
        setupKeyboardScrolling()
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
//        self.titleLabel.alpha = 0
        self.usernameField.alpha = 0
        self.passwordField.alpha = 0
        self.loginButton.alpha = 0
        
//        self.titleLabel.animateFade(0, alpha: 1, duration: 1)
        self.usernameField.animateFade(0, alpha: 1, duration: 1)
        self.passwordField.animateFade(0, alpha: 1, duration: 1)
        self.loginButton.animateFade(0, alpha: 1, duration: 1)
        
    }

    override func viewDidAppear(animated: Bool) {
        
        initialLoad()
        
    }
    
    func setupKeyboardScrolling() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.viewOrigin = self.view.frame.origin.y
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        kbHidden = true
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == self.usernameField {
            self.passwordField.becomeFirstResponder()
        } else {
            kbHidden = true
            textField.resignFirstResponder()
        }
        
        return true
        
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
    
}
