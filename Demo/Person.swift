//
//  Person.swift
//  Demo
//
//  Created by Shawn Roller on 7/24/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit


class Person {
    
    let name: String
    let birthDate: NSDate
    var age: Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let ageComponents = calendar.components(NSCalendarUnit.Year, fromDate: birthDate, toDate: now, options: [])
        return ageComponents.year
    }
    let image: UIImage?
    
    init(name: String, birthDate: NSDate, image: UIImage?) {
        self.name = name
        self.birthDate = birthDate
        self.image = image
    }
    
    class func allPeople() -> Array<Person> {
        return [
            Person(name: "Shane", birthDate: NSDate(dateString: "1983-02-07"), image: UIImage(named: "DrunkCowboy.jpg")),
            Person(name: "Ricky", birthDate: NSDate(dateString: "2015-09-06"), image: UIImage(named: "fam.jpg")),
            Person(name: "WorkerDog", birthDate: NSDate(dateString: "1853-05-13"), image: UIImage(named: "dog.jpeg")),
            Person(name: "Jeep", birthDate: NSDate(dateString: "2010-12-30"), image: UIImage(named: "Jeep31.jpg")),
            Person(name: "Troll", birthDate: NSDate(dateString: "2001-09-11"), image: UIImage(named: "sad_troll.jpg"))
        ]
    }
    
//    class func allCats() -> Array<Animal> {
//        return [ Animal(title: "Sleeping Cat", creator: "papaija2008", image: UIImage(named: "ID-100113060.jpg")),
//                 Animal(title: "Pussy Cat", creator: "Carlos Porto", image: UIImage(named: "ID-10022760.jpg")),
//                 Animal(title: "Korat Domestic Cat", creator: "sippakorn", image: UIImage(named: "ID-10091065.jpg")),
//                 Animal(title: "Tabby Cat", creator: "dan", image: UIImage(named: "ID-10047796.jpg")),
//                 Animal(title: "Yawning Cat", creator: "dan", image: UIImage(named: "ID-10092572.jpg")),
//                 Animal(title: "Tabby Cat", creator: "dan", image: UIImage(named: "ID-10041194.jpg")),
//                 Animal(title: "Cat On The Rocks", creator: "Willem Siers", image: UIImage(named: "ID-10017782.jpg")),
//                 Animal(title: "Brown Cat Standing", creator: "aopsan", image: UIImage(named: "ID-10091745.jpg")),
//                 Animal(title: "Burmese Cat", creator: "Rosemary Ratcliff", image: UIImage(named: "ID-10056941.jpg")),
//                 Animal(title: "Cat", creator: "dan", image: UIImage(named: "ID-10019208.jpg")),
//                 Animal(title: "Cat", creator: "graur codrin", image: UIImage(named: "ID-10011404.jpg")) ]
//    }
//    
//    class func allDogs() -> Array<Animal> {
//        return [ Animal(title: "White Dog Portrait", creator: "photostock", image: UIImage(named: "ID-10034505.jpg")),
//                 Animal(title: "Black Labrador Retriever", creator: "Michal Marcol", image: UIImage(named: "ID-1009881.jpg")),
//                 Animal(title: "Anxious Dog", creator: "James Barker", image: UIImage(named: "ID-100120.jpg")),
//                 Animal(title: "Husky Dog", creator: "James Barker", image: UIImage(named: "ID-100136.jpg")),
//                 Animal(title: "Puppy", creator: "James Barker", image: UIImage(named: "ID-100140.jpg")),
//                 Animal(title: "Black Labrador Puppy", creator: "James Barker", image: UIImage(named: "ID-10018395.jpg")),
//                 Animal(title: "Yellow Labrador", creator: "m_bartosch", image: UIImage(named: "ID-10016005.jpg")),
//                 Animal(title: "Black Labrador", creator: "Felixco, Inc.", image: UIImage(named: "ID-10012923.jpg")),
//                 Animal(title: "Sleepy Dog", creator: "Maggie Smith", image: UIImage(named: "ID-10021769.jpg")),
//                 Animal(title: "English Springer Spaniel Puppy", creator: "Tina Phillips", image: UIImage(named: "ID-10056667.jpg")),
//                 Animal(title: "Intelligent Dog", creator: "James Barker", image: UIImage(named: "ID-100137.jpg")) ]
//    }
}