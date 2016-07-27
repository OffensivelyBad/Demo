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
    
    var initialLoad = true
    var xFromCenter: CGFloat = 0
    var peoplePool: Array<Person>?
    var delegate: CenterViewControllerDelegate?
    
    // MARK: Button actions
    
    func naysTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    func yaysTapped(sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        //populate the array from all people
        self.peoplePool = Person.allPeople()
        addPictures()
        
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

//handle images
extension CenterViewController {
    
    func addPictures() {
        if let pool = self.peoplePool {
            var randomIndex = 0
            if pool.count > 0 {
                randomIndex = Int(arc4random_uniform(UInt32(pool.count)))
                //remove the person from the pool
                self.peoplePool?.removeAtIndex(randomIndex)
                let randomPerson = pool[randomIndex]
                //create the imageview
                if let image = randomPerson.image {
                    let userImage: UIImageView = UIImageView(frame: CGRectMake(0,100, self.view.frame.width - 100, self.view.frame.height - 100))
                    let midX = CGRectGetMidX(self.view.frame)
                    let midY = CGRectGetMidY(self.view.frame)
                    userImage.center = CGPointMake(midX, midY)
                    userImage.contentMode = UIViewContentMode.ScaleAspectFit
                    userImage.image = image
                    userImage.materialDesign = true
                    self.view.addSubview(userImage)
                    let gesture = UIPanGestureRecognizer(target: self, action: #selector(CenterViewController.wasDragged(_:)))
                    userImage.addGestureRecognizer(gesture)
                    userImage.userInteractionEnabled = true
                }
            }
        }
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let image = gesture.view!
        self.xFromCenter += translation.x
        
        var scale: CGFloat = min(100 / abs(xFromCenter), 1)
        image.center = CGPoint(x: image.center.x + translation.x, y: image.center.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        let rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        let stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        image.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            func recycle() {
                image.removeFromSuperview()
                addPictures()
            }
            
            if image.center.x < 100 {
                print("not chosen")
                recycle()
            } else if image.center.x > self.view.bounds.width - 100 {
                print("chosen")
                recycle()
            } else {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    let midX = CGRectGetMidX(self.view.frame)
                    let midY = CGRectGetMidY(self.view.frame)
                    image.center = CGPointMake(midX, midY)
                    scale = 1
                    let rotation:CGAffineTransform = CGAffineTransformMakeRotation(0)
                    let stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
                    image.transform = stretch
                })
            }
            self.xFromCenter = 0
        }
        
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
