//
//  CenterViewController.swift
//  Demo
//
//  Created by Shawn Roller on 7/24/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

var initialLoad = true

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var ageLabel: UILabel!
    
    var centerNavigationController: UINavigationController!
    var loginViewController: LoginViewController!
    
    var delegate: CenterViewControllerDelegate?
//    var delegate: CenterViewControllerDelegate?
    
    // MARK: Button actions
    
    @IBAction func right(sender: AnyObject) {
        
        delegate?.toggleRightPanel?()
        
    }
    
    @IBAction func left(sender: AnyObject) {
        
        delegate?.toggleLeftPanel?()
        
    }
    
    
    func naysTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    func yaysTapped(sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        loginViewController = UIStoryboard.loginViewController()
        
//        if initialLoad {
//            initialLoad = false
//            self.navigationController!.pushViewController(loginViewController, animated: false)
//            self.navigationController = UINavigationController(rootViewController: self)
//        }
        
//        let vc = ContainerViewController()
//        self.delegate = vc
        
    }
    
    func setupNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let naysButton = UIBarButtonItem(title: "Nays", style: .Plain, target: self, action: #selector(CenterViewController.naysTapped(_:)))
        self.navigationItem.leftBarButtonItem = naysButton
        
        let yaysButton = UIBarButtonItem(title: "Yays", style: .Plain, target: self, action: #selector(CenterViewController.yaysTapped(_:)))
        self.navigationItem.rightBarButtonItem = yaysButton
        
    }
    
}

extension CenterViewController: SidePanelViewControllerDelegate {
    func personSelected(person: Person) {
        imageView.image = person.image
        nameLabel.text = person.name
        ageLabel.text = "\(person.age)"
        
        delegate?.toggleLeftPanel?()
        delegate?.toggleRightPanel?()
        delegate?.collapseSidePanels?()
    }
}

private extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
    }
    
    class func loginViewController() -> LoginViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
    }
    
}
