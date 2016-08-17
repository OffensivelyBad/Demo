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
        return CGPointMake(UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var offScreenLeftPosition: CGPoint {
        return CGPointMake(-UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var offScreenTopPosition: CGPoint {
        return CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), -UIScreen.mainScreen().bounds.height)
    }
    
    class var offScreenBottomPosition: CGPoint {
        return CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), UIScreen.mainScreen().bounds.height)
    }
    
    class var screenCenterPosition: CGPoint {
        return CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
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
    
    func animateOnScreen(delay: Int64?) {
        
        let d: Int64 = delay == nil ? ANIM_DELAY * Int64(NSEC_PER_SEC) : delay! * Int64(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, d)
        
        dispatch_after(time, dispatch_get_main_queue()) {
            
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = self.originalConstants[index]
                moveAnim.springBounciness = 25
                moveAnim.springSpeed = 12
                moveAnim.dynamicsFriction = 25
                
                if index > 0 {
                    moveAnim.dynamicsFriction += 15 + CGFloat(index)
                    moveAnim.dynamicsMass += 2
                }
                
                let con = self.constraints[index]
                con.pop_addAnimation(moveAnim, forKey: "moveOnScreen")
                
                index += 1
            } while index < self.constraints.count
        }
        
    }
    
    class func animateToPosition(view: UIView, position: CGPoint, completion: ((POPAnimation!, Bool) -> Void)) {
        let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        moveAnim.toValue = NSValue(CGPoint: position)
        moveAnim.springBounciness = 8
        moveAnim.springSpeed = 8
        moveAnim.completionBlock = completion
        view.pop_addAnimation(moveAnim, forKey: "moveToPosition")
    }
    
}
