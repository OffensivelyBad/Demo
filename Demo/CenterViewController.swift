//
//  CenterViewController.swift
//  Demo
//
//  Created by Shawn Roller on 7/24/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@objc
protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
    @objc optional func logout()
}

class CenterViewController: UIViewController, UIScrollViewDelegate {
    
    weak fileprivate var imageView: UIImageView!
    weak fileprivate var nameLabel: UILabel!
    weak fileprivate var ageLabel: UILabel!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileAge: UILabel!
    @IBOutlet weak var stackView: UIStackView!   
    
    @IBOutlet weak var placeholderLabel: UILabel!
    let networkHelper = NetworkHelper()
    let activityIndicator = ActivityIndicator()
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
    var naysTitle: String = "Nays"
    var yaysTitle: String = "Yays"
    var naysAction: Selector = #selector(CenterViewController.naysTapped(_:))
    var yaysAction: Selector = #selector(CenterViewController.yaysTapped(_:))
    enum ProfileVisibility {
        case visible
        case invisible
    }
    var profileState: ProfileVisibility = .invisible
    
// MARK: Button actions
    
    func naysTapped(_ sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    func yaysTapped(_ sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.setupNavigationBar()
        self.scrollView.isHidden = true
        self.scrollView.alpha = 0
        self.viewProfileButton.backgroundColor = _THEME_COLOR
        self.placeholderLabel.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        self.view.bringSubview(toFront: self.viewProfileButton)
    }
    
    func setupNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.materialDesign = true
        
        self.navigationController?.navigationBar.barTintColor = _THEME_COLOR
        if let titleFont = self.titleFont {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: titleFont, NSForegroundColorAttributeName: UIColor.white]
        }
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let nayButton = createBarButton(self.naysTitle, action: naysAction)
        let yayButton = createBarButton(self.yaysTitle, action: yaysAction)
    
        self.navigationItem.leftBarButtonItem = nayButton
        self.navigationItem.rightBarButtonItem = yayButton
        
    }
    
    func createBarButton(_ title: String, action: Selector) -> UIBarButtonItem {
        let button: CustomButton = CustomButton()
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 29)
        button.setTitleColor(_THEME_COLOR, for: UIControlState())
        button.setTitle(title, for: UIControlState())
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 3
        button.materialDesign = true
        let finishedButton = UIBarButtonItem(customView: button)
        return finishedButton
    }
    
    func loadData() {
        
        self.activityIndicator.activityStarted(sender: self)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.networkHelper.getData { (data, success) in
            
            if success && data.count > 0 {
                //load the data from the API
                print("\(data)-------------")
                self.peoplePool = data
                self.activityIndicator.activityStopped()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.addPictures()
            } else {
                //populate the array from all people
                self.peoplePool = Person.allPeople()
                self.activityIndicator.activityStopped()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.addPictures()
            }
        }
        
    }
    
}

//Mark: handle profilestate
extension CenterViewController {
    
    func getButtonTitle() -> String {
        switch self.profileState {
        case .invisible:
            return "View Profile"
        case .visible:
            return "Dismiss"
        }
    }
    
}

//MARK: handle profile view
extension CenterViewController {
    
    @IBAction func viewProfileTapped(_ sender: AnyObject) {
        
        if self.profileState == .visible {
            dismissProfileView()
            transformView(self.viewProfileButton, duration: 0.5, alpha: 1.0, backgroundColor: _THEME_COLOR, color: UIColor.white, title: getButtonTitle())
        } else {
            openProfile()
            transformView(self.viewProfileButton, duration: 0.5, alpha: 1.0, backgroundColor: UIColor.white, color: _THEME_COLOR, title: getButtonTitle())
        }
    }
    
    func openProfile() {
        //pop open the profile view
        self.profileState = .visible
        self.view.bringSubview(toFront: self.scrollView)
        self.view.bringSubview(toFront: self.stackView)
        self.view.bringSubview(toFront: self.viewProfileButton)
        self.scrollView.layer.cornerRadius = 10
        self.scrollView.backgroundColor = _THEME_COLOR
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
    
    func dismissProfileView() {
        
        self.profileState = .invisible
        self.view.bringSubview(toFront: self.viewProfileButton)
        toggleViews([self.scrollView, self.viewProfileButton, (self.navigationController?.navigationBar)!])
        
    }
    
}

//MARK: handle view visibility
extension CenterViewController {
    
    func toggleViews(_ views: [UIView]) {
        
        if let navBar = self.navigationController?.navigationBar {
        
            if navBar.isTranslucent {
                self.navigationController?.navigationBar.isTranslucent = false
            } else {
                self.navigationController?.navigationBar.isTranslucent = true
            }
            
        }
        
        for view in views {
            if view.isHidden {
                view.isHidden = false
                transformView(view, duration: 0.5, alpha: 1.0, backgroundColor: nil, color: nil, title: nil)
            } else {
                transformView(view, duration: 0.5, alpha: 0.0, backgroundColor: nil, color: nil, title: nil)
            }
        }
        
    }
    
    func transformView(_ view: UIView, duration: Double, alpha: CGFloat?, backgroundColor: UIColor?, color: UIColor?, title: String?) {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            
            if let alpha = alpha {
                view.alpha = alpha
            }
            if let backgroundColor = backgroundColor {
                view.backgroundColor = backgroundColor
            }
            if let color = color {
                if view is UIButton {
                    let button = view as! UIButton
                    button.setTitleColor(color, for: UIControlState())
                }
            }
            if let title = title {
                if view is UIButton {
                    let button = view as! UIButton
                    button.setTitle(title, for: UIControlState())
                }
            }
            
        }, completion: { (complete) -> Void in
            if complete {
                if alpha == 0.0 {
                    view.isHidden = true
                }
            }
        }) 
    }
    
}

//MARK: handle images
extension CenterViewController {
    
    func addPictures() {
        
        for view in self.view.subviews {
            if view is UIImageView {
                view.removeFromSuperview()
            } else if view.tag == 999 {
                //hide the placeholderLabel
                view.isHidden = true
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
                
                self.placeholderLabel.isHidden = false
                
//                let placeholderImageView = createImage()
//                let centeredImage = centerImage(placeholderImageView)
//                centeredImage.image = self.placeholderImage
//                centeredImage.materialDesign = true
//                self.view.addSubview(centeredImage)
            }
        }
        personWasSelected = false
    }
    
    func wasDragged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        let image = gesture.view! as! UIImageView
        self.xFromCenter += translation.x
        
        //remove the constraints but hold the view in place
        image.removeConstraints(image.constraints)
        image.translatesAutoresizingMaskIntoConstraints = true
        
        var scale: CGFloat = min(100 / abs(xFromCenter), 1)
        image.center = CGPoint(x: image.center.x + translation.x, y: image.center.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
        let rotation:CGAffineTransform = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let stretch:CGAffineTransform = rotation.scaledBy(x: scale, y: scale)
        image.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.ended {
            
            func recycle() {
                //remove the person from the pool
                if self.peoplePool?.count > 0 {
                    for i in 0..<self.peoplePool!.count {
                        if peoplePool![i] === self.selectedPerson {
                            peoplePool!.remove(at: i)
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
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    let centeredImage = self.centerImage(image)
                    scale = 1
                    let rotation:CGAffineTransform = CGAffineTransform(rotationAngle: 0)
                    let stretch:CGAffineTransform = rotation.scaledBy(x: scale, y: scale)
                    centeredImage.transform = stretch
                })
            }
            self.xFromCenter = 0
        }
        
    }
    
    func createImage() -> UIImageView {
        let image: UIImageView = UIImageView(frame: CGRect(x: 0,y: 0, width: self.view.frame.width - 100, height: self.view.frame.height - 100))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.materialDesign = true
        
        return image
    }
    
    func setImageConstraints(_ image: UIImageView) {
        image.contentMode = UIViewContentMode.scaleAspectFit
        let widthConstraint = NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.width - 100)
        let heightConstraint = NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.height - 100)
        let xConstraint = NSLayoutConstraint(item: image, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConstraint, yConstraint, widthConstraint, heightConstraint])
        self.animationEngine = AnimationEngine(constraints: [yConstraint], effect: "slideFromTop")
        self.animationEngine.animateOnScreen(0)
    }
    
    func centerImage(_ image: UIImageView) -> UIImageView {
        image.contentMode = UIViewContentMode.scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = true
        let midX = self.view.frame.midX
        let midY = self.view.frame.midY
        image.center = CGPoint(x: midX, y: midY)
        
        return image
    }
    
    func addGesture(_ image: UIImageView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(CenterViewController.wasDragged(_:)))
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
    }
    
}

//MARK: handle touches
extension CenterViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        delegate?.collapseSidePanels?()
        super.touchesBegan(touches, with: event)
        
    }
    
}

//MARK: delegate functions
extension CenterViewController: SidePanelViewControllerDelegate {
    func personSelected(_ person: Person) {
        self.peoplePool?.insert(person, at: 0)
        self.personWasSelected = true
        
        //remove the person from nays
        if nays?.count > 0 {
            if nays!.contains(where: { $0 === person }) {
                for i in 0..<nays!.count {
                    if nays![i] === person {
                        nays!.remove(at: i)
                        break
                    }
                }
            }
        }
        //remove the person from nays
        if yays?.count > 0 {
            if yays!.contains(where: { $0 === person }) {
                for i in 0..<yays!.count {
                    if yays![i] === person {
                        yays!.remove(at: i)
                        break
                    }
                }
            }
        }
        
        delegate?.collapseSidePanels?()
        
        addPictures()
    }
    
    func logout() {
        delegate?.logout?()
    }
    
}
