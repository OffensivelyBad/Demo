//
//  MenuControlViewController.swift
//  Demo
//
//  Created by Shawn Roller on 7/24/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case bothCollapsed
    case leftPanelExpanded
    case rightPanelExpanded
    case disabled
}

var nays: Array<Person>?
var yays: Array<Person>?

class ContainerViewController: UIViewController {
    
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    var loginViewController: LoginViewController!
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var leftViewController: SidePanelViewController?
    var rightViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        loginViewController = UIStoryboard.loginViewController()

        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)
        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(_:)))
//        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
}

// MARK: CenterViewController delegate

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(notAlreadyExpanded)
    }
    
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .rightPanelExpanded:
            toggleRightPanel()
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        
        if let yays = yays {
            if yays.count > 0 {
                rightViewController?.people = yays
            }
        }
        if let nays = nays {
            if nays.count > 0 {
                leftViewController?.people = nays
            }
        }
        
        sidePanelController.delegate = centerViewController
        
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    func addRightPanelViewController() {
        if (rightViewController == nil) {
            rightViewController = UIStoryboard.rightViewController()
            addChildSidePanelController(rightViewController!)
        }
    }
    
    func animateLeftPanel(_ shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .leftPanelExpanded
            
            animateCenterPanelXPosition(centerNavigationController.view.frame.width - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(0) { finished in
                self.currentState = .bothCollapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(_ targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animateRightPanel(_ shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .rightPanelExpanded
            
            animateCenterPanelXPosition(-centerNavigationController.view.frame.width + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(0) { _ in
                self.currentState = .bothCollapsed
                
                self.rightViewController!.view.removeFromSuperview()
                self.rightViewController = nil;
            }
        }
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
}

/*

    // MARK: Gesture recognizer
extension ContainerViewController: UIGestureRecognizerDelegate {
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .BothCollapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                } else {
                    addRightPanelViewController()
                }
                
                showShadowForCenterViewController(true)
            }
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            if (leftViewController != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(hasMovedGreaterThanHalfway)
            } else if (rightViewController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
                animateRightPanel(hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
}
 */

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
    }
    
    class func rightViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "RightViewController") as? SidePanelViewController
    }
    
    class func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? CenterViewController
    }
    
    class func loginViewController() -> LoginViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
    }
    
}
