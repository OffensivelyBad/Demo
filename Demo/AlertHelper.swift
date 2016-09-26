//
//  AlertHelper.swift
//  Demo
//
//  Created by Shawn Roller on 9/23/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

class AlertHelper {    
    
    func displayAlert(sender: UIViewController, title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
        }))
        
        alert.view.tintColor = _THEME_COLOR
        
        sender.present(alert, animated: true, completion: nil)
        
    }
    
}
