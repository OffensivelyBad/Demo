//
//  UIViewExtension.swift
//  Demo
//
//  Created by Shawn Roller on 7/21/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import Foundation

extension UIView {
    
    func animateFade(_ delay: Int64, alpha: CGFloat, duration: TimeInterval) {
        
        let d: Int64 = delay * Int64(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(d) / Double(NSEC_PER_SEC)
        
            DispatchQueue.main.asyncAfter(deadline: time) {
            
            
            UIView.animate(withDuration: duration, animations: { 
                
                self.alpha = alpha
                
            }) 
        }
    }
}
