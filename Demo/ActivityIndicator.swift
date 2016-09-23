//
//  ActivityIndicator.swift
//  Demo
//
//  Created by Shawn Roller on 9/23/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

class ActivityIndicator {

    var activityIndicator = UIActivityIndicatorView()
    let activityColor = UIColor(white: 1.0, alpha: 0.5)
    
    func activityStarted(sender: UIViewController) {
        
        self.activityIndicator = UIActivityIndicatorView(frame: sender.view.frame)
        self.activityIndicator.backgroundColor = self.activityColor
        self.activityIndicator.center = sender.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        sender.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func activityStopped() {
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }

}
