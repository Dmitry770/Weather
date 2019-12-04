//
//  DateExtension.swift
//  Weather
//
//  Created by Macintosh on 03/12/2019.
//  Copyright © 2019 Macintosh. All rights reserved.
//

import Foundation

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
