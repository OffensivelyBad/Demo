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
    func logout()
}

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let networkHelper = NetworkHelper()
    
    var delegate: SidePanelViewControllerDelegate?
    var people: Array<Person>?
    var sectionHeight: CGFloat = 45
    var titleFont: UIFont? = UIFont(name: "HelveticaNeue", size: 22)
    
    struct TableView {
        struct CellIdentifiers {
            static let PersonCell = "PersonCell"
            static let LogoutCell = "LogoutCell"
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
    
    func logout() {
        delegate?.logout()
    }
    
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if let people = self.people {
            count = people.count + 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        func createLogoutCell() -> LogoutCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.LogoutCell, for: indexPath) as! LogoutCell
            cell.logoutButton.addTarget(self, action: #selector(SidePanelViewController.logout), for: .touchUpInside)
            return cell
        }
        
        let defaultCell = createLogoutCell()
        
        if let people = self.people {
        
            if indexPath.row == people.count {
                
                let cell = createLogoutCell()
                return cell
                
            } else {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.PersonCell, for: indexPath) as! PersonCell
                cell.configureForPerson(people[(indexPath as NSIndexPath).row])
                return cell
            }
            
        }
    
        return defaultCell
        
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

class LogoutCell: UITableViewCell {
    
    @IBOutlet weak var logoutButton: UIButton!
    
}
