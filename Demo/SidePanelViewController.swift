//
//  SideViewController.swift
//  Demo
//
//  Created by Shawn Roller on 7/24/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

//@objc
protocol SidePanelViewControllerDelegate {
    func personSelected(person: Person)
}

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SidePanelViewControllerDelegate?
    
    var people: Array<Person>?
    var sectionHeight: CGFloat = 45
    var titleFont: UIFont? = UIFont(name: "HelveticaNeue", size: 22)
    
    struct TableView {
        struct CellIdentifiers {
            static let PersonCell = "PersonCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    override func viewDidAppear(animated: Bool) {        
        self.tableView.reloadData()
    }
    
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let people = self.people {
            count = people.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.PersonCell, forIndexPath: indexPath) as! PersonCell
        cell.configureForPerson(people![indexPath.row])
        return cell
    }
    
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPerson = people![indexPath.row]
        delegate?.personSelected(selectedPerson)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel()
        title.backgroundColor = UIColor(red: 0.310, green: 0.659, blue: 1.000, alpha: 1.00)
        title.textColor = UIColor.whiteColor()
        if let titleFont = self.titleFont {
            title.font = titleFont
        }
        title.materialDesign = true
        
        let heightConstraint = NSLayoutConstraint(item: title, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: sectionHeight)
        
        NSLayoutConstraint.activateConstraints([heightConstraint])
        
        if self.restorationIdentifier == "RightViewController" {
            title.text = "Yerps "
            title.textAlignment = NSTextAlignment.Right
        } else {
            title.text = " Nerps"
        }
        
        return title
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return sectionHeight
        
    }
    
}

// Mark: Configure Table View Cell

class PersonCell: UITableViewCell {
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    func configureForPerson(person: Person) {
        personImageView.image = person.image
        imageNameLabel.text = person.name
        ageLabel.text = "\(person.age)"
        
        //make image round
        personImageView.layer.cornerRadius = personImageView.frame.size.width / 2
        personImageView.clipsToBounds = true
        
    }
    
}