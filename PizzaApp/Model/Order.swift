//
//  Order.swift
//  PizzaApp
//
//  Created by mac on 5/11/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import Foundation
import Firebase

struct Order {
    
    let toppings: [String]
    let date: Date
    var favorite: Bool
    let ref: DatabaseReference?
    let key: String
    
    var toppingString: String {
        return toppings.sorted().joined(separator: ", ")
    }
    
    var asAnyObject: Any {
        return ["date": date.toString,"toppings": toppings,"favorite": favorite]
    }
    
    
    init(toppings: [String]){
        self.toppings = toppings
        self.date = Date()
        self.favorite = false
        self.key = ""
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let toppings = value["toppings"] as? [String],
            let date = value["date"] as? String,
            let favorite = value["favorite"] as? Bool else {
                return nil
        }
        
        self.toppings = toppings.sorted()
        self.favorite = favorite
        self.date = Date(fromString: date) ?? Date()
        self.key = snapshot.key
        self.ref = snapshot.ref
    }
}
