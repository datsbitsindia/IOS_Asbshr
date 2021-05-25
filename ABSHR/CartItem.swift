//
//  CartItem.swift
//  ABSHR
//
//  Created by mac on 11/10/20.
//  Copyright © . All rights reserved.
//

import UIKit

class CartItem: NSObject,NSCoding{
    
    var id = String()
    var name = String()
    var image = String()
    var price = String()
    var count = String()
    var mesurment = String()
    var discount = String()
    override init() {
        
    }
    
    init(id:String,name:String,image:String,price:String,count:String,mesurment:String,discount:String) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.count = count
        self.mesurment = mesurment
        self.discount = discount
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
        self.price = aDecoder.decodeObject(forKey: "price") as? String ?? ""
        self.count = aDecoder.decodeObject(forKey: "count") as? String ?? ""
        self.mesurment = aDecoder.decodeObject(forKey: "mesurment") as? String ?? ""
        self.discount = aDecoder.decodeObject(forKey: "discount") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(count, forKey: "count")
        aCoder.encode(mesurment, forKey: "mesurment")
        aCoder.encode(discount, forKey: "discount")
        
    }

}
