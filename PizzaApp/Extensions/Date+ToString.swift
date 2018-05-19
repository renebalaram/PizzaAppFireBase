//
//  Date+ToString.swift
//  PizzaApp
//
//  Created by Admin on 5/19/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import Foundation

fileprivate struct Formatter{
    
    static var myFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return formatter
    }
}

extension Date {
    
    var toString: String {
        return Formatter.myFormatter.string(from: self)
    }
    
    var toUnix: String {
        let timeInterval: String = "\((self.timeIntervalSince1970 as Double))"
        return timeInterval.replacingOccurrences(of: ".", with: "")
    }
    
    init?(fromString :String){
        let formatter = Formatter.myFormatter
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let date = formatter.date(from:fromString)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        self = finalDate!
    }
}
