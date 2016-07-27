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
    
    var people: Array<Person>!
    
    struct TableView {
        struct CellIdentifiers {
            static let PersonCell = "PersonCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.PersonCell, forIndexPath: indexPath) as! PersonCell
        cell.configureForPerson(people[indexPath.row])
        cell.materialDesign = true
        return cell
    }
    
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPerson = people[indexPath.row]
        delegate?.personSelected(selectedPerson)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "People"
        
    }
    
}

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