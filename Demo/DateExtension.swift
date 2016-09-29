//
//  DateExtension.swift
//  Demo
//
//  Created by Shawn Roller on 7/24/16.
//  Copyright © 2016 OffensivelyBad. All rights reserved.
//

import UIKit

extension Date {
    
    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since: d)
    }
    
    
}
