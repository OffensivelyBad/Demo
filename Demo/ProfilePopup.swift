//
//  ProfilePopup.swift
//  Demo
//
//  Created by Shawn Roller on 9/28/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

extension CenterViewController {
    
    func getButtonTitle() -> String {
        switch self.profileState {
        case .invisible:
            return "View Profile"
        case .visible:
            return "Dismiss"
        case .reset:
            return "Reset"
        }
    }
    
    func openProfile() {
        //pop open the profile view
        self.profileState = .visible
        self.view.bringSubview(toFront: self.scrollView)
        self.view.bringSubview(toFront: self.stackView)
        self.view.bringSubview(toFront: self.viewProfileButton)
        self.scrollView.layer.cornerRadius = 10
        self.scrollView.backgroundColor = _THEME_COLOR
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        
        toggleViews([self.scrollView, self.viewProfileButton, (self.navigationController?.navigationBar)!])
        
        populateProfileData()
        //        populateTestData()
    }
    
    func populateTestData() {
        
        let image = UIImage(named: "DrunkCowboy.jpg")
        self.profileImage.image = image
        self.profileName.text = "DrunkCowboy"
        self.profileAge.text = "33"
        
    }
    
    func populateProfileData() {
        if let person = self.selectedPerson {
            self.profileImage.image = person.image
            self.profileName.text = person.name
            self.profileAge.text = "\(person.age)"
        }
    }
    
    func dismissProfileView() {
        
        self.profileState = .invisible
        self.view.bringSubview(toFront: self.viewProfileButton)
        toggleViews([self.scrollView, self.viewProfileButton, (self.navigationController?.navigationBar)!])
        
    }
    
//MARK: handle view visibility
    
    func toggleViews(_ views: [UIView]) {
        
        if let navBar = self.navigationController?.navigationBar {
            
            if navBar.isTranslucent {
                self.navigationController?.navigationBar.isTranslucent = false
            } else {
                self.navigationController?.navigationBar.isTranslucent = true
            }
            
        }
        
        for view in views {
            if view.isHidden {
                view.isHidden = false
                transformView(view, duration: 0.5, alpha: 1.0, backgroundColor: nil, color: nil, title: nil)
            } else {
                transformView(view, duration: 0.5, alpha: 0.0, backgroundColor: nil, color: nil, title: nil)
            }
        }
        
    }
    
    func transformView(_ view: UIView, duration: Double, alpha: CGFloat?, backgroundColor: UIColor?, color: UIColor?, title: String?) {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            
            if let alpha = alpha {
                view.alpha = alpha
            }
            if let backgroundColor = backgroundColor {
                view.backgroundColor = backgroundColor
            }
            if let color = color {
                if view is UIButton {
                    let button = view as! UIButton
                    button.setTitleColor(color, for: UIControlState())
                }
            }
            if let title = title {
                if view is UIButton {
                    let button = view as! UIButton
                    button.setTitle(title, for: UIControlState())
                }
            }
            
            }, completion: { (complete) -> Void in
                if complete {
                    if alpha == 0.0 {
                        view.isHidden = true
                    }
                }
        }) 
    }
    
}
