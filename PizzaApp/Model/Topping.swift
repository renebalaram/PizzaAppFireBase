//
//  Topping.swift
//  PizzaApp
//
//  Created by Admin on 5/19/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import Foundation
import Firebase

struct Topping {
    
    let topping: String
    let ref: DatabaseReference?
    let key: String
    
    
    var asAnyObject: Any {
        return ["topping": topping]
    }
    
    
    init(topping: String){
        self.topping = topping
        self.key = ""
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let topping = value["topping"] as? String else {
                return nil
        }
        
        self.topping = topping
        self.key = snapshot.key
        self.ref = snapshot.ref
    }
}
