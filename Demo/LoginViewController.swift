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
    let alertHelper = AlertHelper()
    let networkHelper = NetworkHelper()
    let activityIndicator = ActivityIndicator()
    let loginAlertTitle = "You done goofed"
    let loginAlertMessage = "The consequences will never be the same"
    var firstCall = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if user is logged in already
        ad.checkUserLoggedIn { (loggedIn) in
            if loggedIn && self.firstCall {
                self.firstCall = false
                self.performLoggedInSegue(animated: false)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        initialLoad()
        
    }
    
// MARK: UI Setup
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
    
// MARK: Handle login
    @IBAction func loginTouched(_ sender: AnyObject) {
        
        if !testMode {
            
            self.activityIndicator.activityStarted(sender: self)
            
            if let usernameText = self.usernameField.text, let passwordText = self.passwordField.text {
            
                self.networkHelper.login(email: usernameText, password: passwordText) { (success) in
                    
                    self.activityIndicator.activityStopped()
                    
                    if success {
                        self.performLoggedInSegue(animated: true)
                    } else {
                        //show an error
                        self.alertHelper.displayAlert(sender: self, title: self.loginAlertTitle, message: self.loginAlertMessage)
                    }
                }
            }
            
        } else {
            self.performLoggedInSegue(animated: true)
        }
        
    }
    
    func performLoggedInSegue(animated: Bool) {
        self.present(self.containerViewController, animated: animated, completion: nil)
    }
    
}
