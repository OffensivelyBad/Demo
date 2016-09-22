//
//  AnimationEngine.swift
//  Demo
//
//  Created by Shawn Roller on 7/21/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
    
    class var offScreenRightPosition: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.midY)
    }
    
    class var offScreenLeftPosition: CGPoint {
        return CGPoint(x: -UIScreen.main.bounds.width, y: UIScreen.main.bounds.midY)
    }
    
    class var offScreenTopPosition: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.midX, y: -UIScreen.main.bounds.height)
    }
    
    class var offScreenBottomPosition: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height)
    }
    
    class var screenCenterPosition: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    }
    
    let ANIM_DELAY: Int64 = 1
    var originalConstants = [CGFloat]()
    var constraints = [NSLayoutConstraint]()
    
    init(constraints: [NSLayoutConstraint], effect: String) {
        for con in constraints {
            originalConstants.append(con.constant)
            if effect == "slideFromRight" {
                con.constant = AnimationEngine.offScreenRightPosition.x
            } else if effect == "slideFromLeft" {
                con.constant = AnimationEngine.offScreenLeftPosition.x
            } else if effect == "slideFromTop" {
                con.constant = AnimationEngine.offScreenTopPosition.y
            } else if effect == "slideFromBottom" {
                con.constant = AnimationEngine.offScreenBottomPosition.y
            }
        }
        
        self.constraints = constraints
    }
    
    func animateOnScreen(_ delay: Int64?) {
        
        let d: Int64 = delay == nil ? ANIM_DELAY * Int64(NSEC_PER_SEC) : delay! * Int64(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(d) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim?.toValue = self.originalConstants[index]
                moveAnim?.springBounciness = 25
                moveAnim?.springSpeed = 12
                moveAnim?.dynamicsFriction = 25
                
                if index > 0 {
                    moveAnim?.dynamicsFriction += 15 + CGFloat(index)
                    moveAnim?.dynamicsMass += 2
                }
                
                let con = self.constraints[index]
                con.pop_add(moveAnim, forKey: "moveOnScreen")
                
                index += 1
            } while index < self.constraints.count
        }
        
    }
    
    class func animateToPosition(_ view: UIView, position: CGPoint, completion: @escaping ((POPAnimation?, Bool) -> Void)) {
        let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        moveAnim?.toValue = NSValue(cgPoint: position)
        moveAnim?.springBounciness = 8
        moveAnim?.springSpeed = 8
        moveAnim?.completionBlock = completion
        view.pop_add(moveAnim, forKey: "moveToPosition")
    }
    
}
