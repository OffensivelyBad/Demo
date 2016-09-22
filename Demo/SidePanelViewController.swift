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
    func personSelected(_ person: Person)
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
    
    override func viewDidAppear(_ animated: Bool) {        
        self.tableView.reloadData()
    }
    
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let people = self.people {
            count = people.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.PersonCell, for: indexPath) as! PersonCell
        cell.configureForPerson(people![(indexPath as NSIndexPath).row])
        return cell
    }
    
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPerson = people![(indexPath as NSIndexPath).row]
        delegate?.personSelected(selectedPerson)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel()
        title.backgroundColor = themeColor
        title.textColor = UIColor.white
        if let titleFont = self.titleFont {
            title.font = titleFont
        }
        title.materialDesign = true
        
        let heightConstraint = NSLayoutConstraint(item: title, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: sectionHeight)
        
        NSLayoutConstraint.activate([heightConstraint])
        
        if self.restorationIdentifier == "RightViewController" {
            title.text = "Yerps "
            title.textAlignment = NSTextAlignment.right
        } else {
            title.text = " Nerps"
        }
        
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return sectionHeight
        
    }
    
}

// Mark: Configure Table View Cell

class PersonCell: UITableViewCell {
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    func configureForPerson(_ person: Person) {
        personImageView.image = person.image
        imageNameLabel.text = person.name
        ageLabel.text = "\(person.age)"
        
        //make image round
        personImageView.layer.cornerRadius = personImageView.frame.size.width / 2
        personImageView.clipsToBounds = true
        
    }
    
}
