//
//  viewExtension.swift
//  Demo
//
//  Created by Shawn Roller on 7/21/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

extension UIView {
    
    func animateFade(delay: Int64, alpha: CGFloat, duration: NSTimeInterval) {
        
        let d: Int64 = delay * Int64(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, d)
        
            dispatch_after(time, dispatch_get_main_queue()) {
            
            
            UIView.animateWithDuration(duration) { 
                
                self.alpha = alpha
                
            }
        }
    }
}