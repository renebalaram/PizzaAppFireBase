//
//  PizzaService.swift
//  PizzaApp
//
//  Created by mac on 5/8/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import UIKit
import Foundation
import Firebase

typealias PizzaHandler = ([(Pizza, Int)])->Void
typealias OrderHandler = ([Order]) -> Void
typealias ToppingsHandler = ([String]) -> Void

class PizzaService {
 
    static let ordersRef = Database.database().reference(withPath: Entity.Names.pizzaOrder.rawValue)
    static let pizzasRef = Database.database().reference(withPath: Entity.Names.pizza.rawValue)
    static let toppingsRef = Database.database().reference(withPath: Entity.Names.topping.rawValue)
    
    class func getPizzas(limit: Int = 20,sorting: Entity.Sorting, completion: @escaping PizzaHandler){
        
        PizzaService.pizzasRef.observe(.value, with: {snapshot in
            
            var counts : [Pizza: Int] = [:]
            for data in snapshot.children{
                let dataSnapshot: DataSnapshot = data as! DataSnapshot
                let pizza = Pizza(snapshot: dataSnapshot)
                counts[pizza!] = pizza?.popularity
            }
            
            var topPizzas: [(key:Pizza, value:Int)]
            
            switch sorting {
            case .byPopularity:
                // sort all pizzas by popularity
                topPizzas = counts.sorted(by: { $0.value > $1.value })
            case .byNameAsc:
                topPizzas = counts.sorted(by: { $0.key.joinedToppings > $1.key.joinedToppings })
            case .byNameDesc:
                topPizzas = counts.sorted(by: { $0.key.joinedToppings < $1.key.joinedToppings })
            }
            
            
            // if the limit is greater than the count, we will crash
            let end = min(limit, topPizzas.count)
            
            // return the top N pizzas
            completion(Array(topPizzas[0..<end]))
        })
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            guard let path = Bundle.main.path(
//                forResource: "pizzas",
//                ofType: "json") else {
//                return
//            }
//
//            let fileURL = URL(fileURLWithPath: path)
//
//            var pizzas: [Pizza]
//            do {
//                let data = try Data(contentsOf: fileURL)
//                pizzas = try JSONDecoder().decode([Pizza].self, from: data)
//            } catch  {
//                print(error.localizedDescription)
//                return
//            }
//
//            let counts = pizzas.reduce(into: [Pizza: Int]()){ $0[$1, default: 0] += 1}
////            this was created only for the first upload from the json file to firebase
////            firstPizzasUpload(topPizzas: counts)
//
//            var topPizzas: [(key:Pizza, value:Int)]
//
//            switch sorting {
//            case .byPopularity:
//                // sort all pizzas by popularity
//                topPizzas = counts.sorted(by: { $0.value > $1.value })
//            case .byNameAsc:
//                topPizzas = counts.sorted(by: { $0.key.joinedToppings > $1.key.joinedToppings })
//            case .byNameDesc:
//                topPizzas = counts.sorted(by: { $0.key.joinedToppings < $1.key.joinedToppings })
//            }
//
//
//            // if the limit is greater than the count, we will crash
//            let end = min(limit, topPizzas.count)
//
//            // return the top N pizzas
//            completion(Array(topPizzas[0..<end]))
//        }
    }
    
    class func firstPizzasUpload(topPizzas: [Pizza: Int]) {
        
        
        for topPizza in topPizzas {
            let pizza: Any = ["toppings": topPizza.key.toppings.sorted(),"price": topPizza.key.price ?? 0,"popularity": topPizza.value]
            let pizzaReference = PizzaService.pizzasRef.child(topPizza.key.joinedToppings)
            pizzaReference.setValue(pizza)
        }
    }
    
    class func updateOrder(_ order: Order){
        order.ref?.updateChildValues([
            "favorite": order.favorite == true
            ])
    }
    
    class func saveOrder(toppings ntoppings: [String]){
        let newOrder: Order = Order(toppings: ntoppings)
        let orderReference = PizzaService.ordersRef.child("\(newOrder.toppingString) - \(newOrder.date.toUnix)")
        orderReference.setValue(newOrder.asAnyObject)
    }
    
    class func deleteOrder(order: Order){
        order.ref?.removeValue()
    }
    
    
    class func getOrders(completion: @escaping OrderHandler){
        PizzaService.ordersRef.observe(.value, with: {snapshot in
            var orders : [Order] = []
            for data in snapshot.children{
                let dataSnapshot: DataSnapshot = data as! DataSnapshot
                let order = Order(snapshot: dataSnapshot)
                orders.append(order!)
            }
            completion(orders)
        })
    }
    
    class func getToppings(completion: @escaping ToppingsHandler){
        PizzaService.toppingsRef.observe(.value, with: {snapshot in
            var toppings : [String] = []
            for data in snapshot.children{
                let dataSnapshot: DataSnapshot = data as! DataSnapshot
                let topping = Topping(snapshot: dataSnapshot)
                toppings.append(topping!.topping)
            }
            completion(toppings)
        })
    }
    
    class func saveToping(topping: String){
        let newTopping: Topping = Topping(topping: topping)
        let toppingReference = PizzaService.toppingsRef.child(topping)
        toppingReference.setValue(newTopping.asAnyObject)
    }
}
