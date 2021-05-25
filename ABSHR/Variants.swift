//
//  Variants.swift
//  ABSHR
//
//  Created by mac on 11/10/20.
//  Copyright © . All rights reserved.
//

import UIKit

class Variants: NSObject,NSCoding{
    var serve_for = String()
    var id = String()
    var measurement_unit_id = String()
    var price = String()
    var product_id = String()
    var stock = String()
    var measurement_unit_name = String()
    var type = String()
    var discounted_price = String()
    var stock_unit_id = String()
    var stock_unit_name = String()
    var measurement = String()
    
    override init() {
        
    }
    
    init(serve_for:String,id:String,measurement_unit_id:String,price:String,product_id:String,stock:String,measurement_unit_name:String,type:String,discounted_price:String,stock_unit_id:String,stock_unit_name:String,measurement:String) {
        self.serve_for = serve_for
        self.id = id
        self.measurement_unit_id = measurement_unit_id
        self.price = price
        self.product_id = product_id
        self.stock = stock
        self.measurement_unit_name = measurement_unit_name
        self.type = type
        self.discounted_price = discounted_price
        self.stock_unit_id = stock_unit_id
        self.stock_unit_name = stock_unit_name
        self.measurement = measurement
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.serve_for = aDecoder.decodeObject(forKey: "serve_for") as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.measurement_unit_id = aDecoder.decodeObject(forKey: "measurement_unit_id") as? String ?? ""
        self.price = aDecoder.decodeObject(forKey: "price") as? String ?? ""
        self.product_id = aDecoder.decodeObject(forKey: "product_id") as? String ?? ""
        self.stock = aDecoder.decodeObject(forKey: "stock") as? String ?? ""
        self.measurement_unit_name = aDecoder.decodeObject(forKey: "measurement_unit_name") as? String ?? ""
        self.type = aDecoder.decodeObject(forKey: "type") as? String ?? ""
        self.discounted_price = aDecoder.decodeObject(forKey: "discounted_price") as? String ?? ""
        self.stock = aDecoder.decodeObject(forKey: "stock") as? String ?? ""
        self.measurement_unit_name = aDecoder.decodeObject(forKey: "measurement_unit_name") as? String ?? ""
        self.type = aDecoder.decodeObject(forKey: "type") as? String ?? ""
        self.discounted_price = aDecoder.decodeObject(forKey: "discounted_price") as? String ?? ""
        self.stock_unit_id = aDecoder.decodeObject(forKey: "stock_unit_id") as? String ?? ""
        self.stock_unit_name = aDecoder.decodeObject(forKey: "stock_unit_name") as? String ?? ""
        self.measurement = aDecoder.decodeObject(forKey: "measurement") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(serve_for, forKey: "serve_for")
        aCoder.encode(measurement_unit_id, forKey: "measurement_unit_id")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(product_id, forKey: "product_id")
        aCoder.encode(stock, forKey: "stock")
        aCoder.encode(measurement_unit_name, forKey: "measurement_unit_name")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(discounted_price, forKey: "discounted_price")
        aCoder.encode(stock, forKey: "stock")
        aCoder.encode(measurement_unit_name, forKey: "measurement_unit_name")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(discounted_price, forKey: "discounted_price")
        aCoder.encode(stock_unit_id, forKey: "stock_unit_id")
        aCoder.encode(stock_unit_name, forKey: "stock_unit_name")
        aCoder.encode(measurement, forKey: "measurement")
        
    }
    
}

