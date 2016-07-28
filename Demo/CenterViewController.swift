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
    var selectedPerson: Person?
    var delegate: CenterViewControllerDelegate?
    var placeholderImage = UIImage(named: "wristlylogo.png")
    
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
                self.selectedPerson = pool[randomIndex]
                //create the imageview
                if let image = self.selectedPerson!.image {
                    let userImage = createImage()
                    let centeredImage = centerImage(userImage)
                    centeredImage.image = image
                    centeredImage.materialDesign = true
                    self.view.addSubview(centeredImage)
                    addGesture(centeredImage)
                }
            } else {
                let placeholderImageView = createImage()
                let centeredImage = centerImage(placeholderImageView)
                centeredImage.image = self.placeholderImage
                centeredImage.materialDesign = true
                self.view.addSubview(centeredImage)
            }
        }
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let image = gesture.view! as! UIImageView
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
                if let person = self.selectedPerson {
                    nays?.append(person)
                }
                recycle()
            } else if image.center.x > self.view.bounds.width - 100 {
                print("chosen")
                if let person = self.selectedPerson {
                    yays?.append(person)
                }
                recycle()
            } else {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    let centeredImage = self.centerImage(image)
                    scale = 1
                    let rotation:CGAffineTransform = CGAffineTransformMakeRotation(0)
                    let stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
                    centeredImage.transform = stretch
                })
            }
            self.xFromCenter = 0
        }
        
    }
    
    func createImage() -> UIImageView {
        let image: UIImageView = UIImageView(frame: CGRectMake(0,100, self.view.frame.width - 100, self.view.frame.height - 100))
        return image
    }
    
    func centerImage(image: UIImageView) -> UIImageView {
        let midX = CGRectGetMidX(self.view.frame)
        let midY = CGRectGetMidY(self.view.frame)
        image.center = CGPointMake(midX, midY)
        image.contentMode = UIViewContentMode.ScaleAspectFit
        return image
    }
    
    func addGesture(image: UIImageView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(CenterViewController.wasDragged(_:)))
        image.addGestureRecognizer(gesture)
        image.userInteractionEnabled = true
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
