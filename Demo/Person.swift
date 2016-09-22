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
    let birthDate: Date
    var age: Int {
        let calendar: Calendar = Calendar.current
        let now = Date()
        let ageComponents = (calendar as NSCalendar).components(NSCalendar.Unit.year, from: birthDate, to: now, options: [])
        return ageComponents.year!
    }
    let image: UIImage?
    
    init(name: String, birthDate: Date, image: UIImage?) {
        self.name = name
        self.birthDate = birthDate
        self.image = image
    }
    
    class func allPeople() -> Array<Person> {
        return [
            Person(name: "Shane", birthDate: Date(dateString: "1983-02-07"), image: UIImage(named: "DrunkCowboy.jpg")),
            Person(name: "Ricky", birthDate: Date(dateString: "2015-09-06"), image: UIImage(named: "fam.jpg")),
            Person(name: "WorkerDog", birthDate: Date(dateString: "1853-05-13"), image: UIImage(named: "dog.jpeg")),
            Person(name: "Jeep", birthDate: Date(dateString: "2010-12-30"), image: UIImage(named: "Jeep31.jpg")),
            Person(name: "Troll", birthDate: Date(dateString: "2001-09-11"), image: UIImage(named: "sad_troll.jpg"))
        ]
    }

}
