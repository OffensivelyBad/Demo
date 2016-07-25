//
//  CenterViewController.swift
//  Demo
//
//  Created by Shawn Roller on 7/24/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

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
    
    var delegate: CenterViewControllerDelegate?
    
    // MARK: Button actions
    
    @IBAction func naysTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func yaysTapped(sender: AnyObject) {
        delegate?.toggleRightPanel?()
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
