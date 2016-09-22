//
//  LoginViewController.swift
//  Demo
//
//  Created by Shawn Roller on 7/21/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

class LoginViewController: KeyboardVC, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let containerViewController = ContainerViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialLoad()
    }
    
    func initialLoad() {
        
        nays = Array<Person>()
        yays = Array<Person>()
        
        setupKeyboardScrolling(self)
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
        self.usernameField.alpha = 0
        self.passwordField.alpha = 0
        self.loginButton.alpha = 0
        
        self.usernameField.animateFade(0, alpha: 1, duration: 1)
        self.passwordField.animateFade(0, alpha: 1, duration: 1)
        self.loginButton.animateFade(0, alpha: 1, duration: 1)
        
        self.loginButton.setTitleColor(UIColor.white, for: UIControlState())
        self.loginButton.backgroundColor = themeColor
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.usernameField {
            self.passwordField.becomeFirstResponder()
        } else {
            kbHidden = true
            textField.resignFirstResponder()
        }
        
        return true
        
    }
    
    @IBAction func loginTouched(_ sender: AnyObject) {
        
        //bypass credentials
//        performSegueWithIdentifier("loginHomeSegue", sender: self)

        present(containerViewController, animated: true, completion: nil)
        
        
//        if let username = self.usernameField.text, password = self.passwordField.text {
//        
//            let (success, error) = simulateNetworkCall(username, password: password)
//            
//            if success {
//                performSegueWithIdentifier("loginHomeSegue", sender: self)
//            } else {
//                displayAlert("login", title: "Login Failed", message: "\(error)", buttonAction: "OK", alertColor: UIColor.blueColor())
//            }
//        
//        }
    }
    
}
