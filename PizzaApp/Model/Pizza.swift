//
//  Pizza.swift
//  PizzaApp
//
//  Created by mac on 5/8/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import Foundation
import Firebase
struct Pizza: Decodable {
    
    var toppings: [String]
    var price: Int?
    var popularity: Int?
    var joinedToppings: String {
        return toppings.sorted().joined(separator: ", ")
    }
    
    init(toppings: [String],price: Int?){
        self.toppings = toppings.sorted()
        self.price = price
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let toppings = value["toppings"] as? [String],
            let price = value["price"] as? Int,
            let popularity = value["popularity"] as? Int else {
                return nil
        }
        
        self.toppings = toppings.sorted()
        self.price = price
        self.popularity = popularity
    }
}


extension Pizza: Equatable {
    
    static func ==(lhs: Pizza, rhs: Pizza) -> Bool {
        return lhs.toppings.sorted() == rhs.toppings.sorted()
    }
}

extension Pizza: Hashable {
    
    var hashValue: Int {
        return toppings.sorted().joined().hashValue
    }
}
