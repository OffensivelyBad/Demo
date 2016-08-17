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

class CenterViewController: UIViewController, UIScrollViewDelegate {
    
    weak private var imageView: UIImageView!
    weak private var nameLabel: UILabel!
    weak private var ageLabel: UILabel!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileAge: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!   
    
    var initialLoad = true
    var xFromCenter: CGFloat = 0
    var peoplePool: Array<Person>?
    var selectedPerson: Person?
    var delegate: CenterViewControllerDelegate?
    var placeholderImage = UIImage(named: "wristlylogo.png")
    var personWasSelected = false
    var animationEngine: AnimationEngine!
    var navBarHeight: CGFloat = 50.0
    var titleFont: UIFont? = UIFont(name: "HelveticaNeue", size: 22)

    
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
        
        self.scrollView.hidden = true
        self.scrollView.alpha = 0
        self.view.bringSubviewToFront(self.viewProfileButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        addPictures()
    }
    
    func setupNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.materialDesign = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.310, green: 0.659, blue: 1.000, alpha: 1.00)
        if let titleFont = self.titleFont {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: titleFont, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let naysButton = UIBarButtonItem(title: "Nays", style: .Plain, target: self, action: #selector(CenterViewController.naysTapped(_:)))
        self.navigationItem.leftBarButtonItem = naysButton
        
        let yaysButton = UIBarButtonItem(title: "Yays", style: .Plain, target: self, action: #selector(CenterViewController.yaysTapped(_:)))
        self.navigationItem.rightBarButtonItem = yaysButton
        
    }
    
}

//handle profile view
extension CenterViewController {
    
    @IBAction func viewProfileTapped(sender: AnyObject) {
        
        openProfile()
        
    }
    
    func openProfile() {
        //pop open the profile view
        self.view.bringSubviewToFront(self.scrollView)
        self.view.bringSubviewToFront(self.stackView)
        self.scrollView.layer.cornerRadius = 10
        self.scrollView.backgroundColor = UIColor(red: 0.310, green: 0.659, blue: 1.000, alpha: 1.00)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        
        toggleViews([self.scrollView, self.viewProfileButton, (self.navigationController?.navigationBar)!])
        
        populateProfileData()
//        populateTestData()
    }
    
    func populateTestData() {
        
        let image = UIImage(named: "DrunkCowboy.jpg")
        self.profileImage.image = image
        self.profileName.text = "DrunkCowboy"
        self.profileAge.text = "33"
        
    }
    
    func populateProfileData() {
        if let person = self.selectedPerson {
            self.profileImage.image = person.image
            self.profileName.text = person.name
            self.profileAge.text = "\(person.age)"
        }
    }
    
    @IBAction func dismissProfileView() {
        
        toggleViews([self.scrollView, self.viewProfileButton, (self.navigationController?.navigationBar)!])
        
    }
    
}

//handle view visibility
extension CenterViewController {
    
    func toggleViews(views: [UIView]) {
        
        if let navBar = self.navigationController?.navigationBar {
        
            if navBar.translucent {
                self.navigationController?.navigationBar.translucent = false
            } else {
                self.navigationController?.navigationBar.translucent = true
            }
            
        }
        
        for view in views {
            if view.hidden {
                view.hidden = false
                fadeView(view, duration: 0.5, alpha: 1.0)
            } else {
                fadeView(view, duration: 0.5, alpha: 0.0)
            }
        }
        
    }
    
    func fadeView(view: UIView, duration: Double, alpha: CGFloat) {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            view.alpha = alpha
            
        }) { (complete) -> Void in
            if complete {
                if alpha == 0.0 {
                    view.hidden = true
                }
            }
        }
    }
    
}

//handle images
extension CenterViewController {
    
    func addPictures() {
        
        for view in self.view.subviews {
            if view is UIImageView {
                view.removeFromSuperview()
            }
        }
        
        if let pool = self.peoplePool {
            var randomIndex = 0
            if pool.count > 0 {
                //if person was not selected, get random index, otherwise use the first person in the array
                if !personWasSelected {
                    randomIndex = Int(arc4random_uniform(UInt32(pool.count)))
                }
                self.selectedPerson = pool[randomIndex]
                //create the imageview
                if let image = self.selectedPerson!.image {
                    let userImage = createImage()
                    userImage.image = image
                    addGesture(userImage)
                    self.view.addSubview(userImage)
                    setImageConstraints(userImage)
                }
            } else {
                let placeholderImageView = createImage()
                let centeredImage = centerImage(placeholderImageView)
                centeredImage.image = self.placeholderImage
                centeredImage.materialDesign = true
                self.view.addSubview(centeredImage)
            }
        }
        personWasSelected = false
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let image = gesture.view! as! UIImageView
        self.xFromCenter += translation.x
        
        //remove the constraints but hold the view in place
        image.removeConstraints(image.constraints)
        image.translatesAutoresizingMaskIntoConstraints = true
        
        var scale: CGFloat = min(100 / abs(xFromCenter), 1)
        image.center = CGPoint(x: image.center.x + translation.x, y: image.center.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        let rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        let stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        image.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            func recycle() {
                //remove the person from the pool
                if self.peoplePool?.count > 0 {
                    for i in 0..<self.peoplePool!.count {
                        if peoplePool![i] === self.selectedPerson {
                            peoplePool!.removeAtIndex(i)
                            break
                        }
                    }
                }
                image.removeFromSuperview()
                addPictures()
            }
            
            if image.center.x < 100 {
                if let person = self.selectedPerson {
                    nays?.append(person)
                }
                recycle()
            } else if image.center.x > self.view.bounds.width - 100 {
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
        let image: UIImageView = UIImageView(frame: CGRectMake(0,0, self.view.frame.width - 100, self.view.frame.height - 100))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.materialDesign = true
        
        return image
    }
    
    func setImageConstraints(image: UIImageView) {
        image.contentMode = UIViewContentMode.ScaleAspectFit
        let widthConstraint = NSLayoutConstraint(item: image, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.view.frame.width - 100)
        let heightConstraint = NSLayoutConstraint(item: image, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.view.frame.height - 100)
        let xConstraint = NSLayoutConstraint(item: image, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: image, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activateConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
        self.animationEngine = AnimationEngine(constraints: [yConstraint], effect: "slideFromTop")
        self.animationEngine.animateOnScreen(0)
    }
    
    func centerImage(image: UIImageView) -> UIImageView {
        image.contentMode = UIViewContentMode.ScaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = true
        let midX = CGRectGetMidX(self.view.frame)
        let midY = CGRectGetMidY(self.view.frame)
        image.center = CGPointMake(midX, midY)
        
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
        self.peoplePool?.insert(person, atIndex: 0)
        self.personWasSelected = true
        
        //remove the person from nays
        if nays?.count > 0 {
            if nays!.contains({ $0 === person }) {
                for i in 0..<nays!.count {
                    if nays![i] === person {
                        nays!.removeAtIndex(i)
                        break
                    }
                }
            }
        }
        //remove the person from nays
        if yays?.count > 0 {
            if yays!.contains({ $0 === person }) {
                for i in 0..<yays!.count {
                    if yays![i] === person {
                        yays!.removeAtIndex(i)
                        break
                    }
                }
            }
        }
        
        delegate?.collapseSidePanels?()
        
        addPictures()
    }
}
