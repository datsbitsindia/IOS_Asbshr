//
//  Products.swift
//  ABSHR
//
//  Created by mac on 10/10/20.
//  Copyright © . All rights reserved.
//

import UIKit

class Products: NSObject,NSCoding{
    
    var id = String()
    var name = String()
    var product_description = String()
    var row_order = String()
    var other_images = [String]()
    var image = String()
    var indicator = String()
    var slug = String()
    var variants = [Variants]()
    var price = String()
    var subcategory_id = String()
    var status = String()
    var date_added = String()
    var category_id = String()
    
    override init() {
        
    }
    
    init(id:String,name:String,product_description:String,row_order:String,other_images:[String],image:String,indicator:String,slug:String,variants:[Variants],price:String,subcategory_id:String,status:String,date_added:String,category_id:String) {
        self.id = id
        self.name = name
        self.product_description = product_description
        self.row_order = row_order
        self.other_images = other_images
        self.image = image
        self.indicator = indicator
        self.slug = slug
        self.variants = variants
        self.price = price
        self.subcategory_id = subcategory_id
        self.status = status
        self.date_added = date_added
        self.category_id = category_id
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id =  aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.product_description = aDecoder.decodeObject(forKey: "product_description") as! String
        self.row_order =  aDecoder.decodeObject(forKey: "row_order") as! String
        self.other_images = aDecoder.decodeObject(forKey: "other_images") as! [String]
        self.image = aDecoder.decodeObject(forKey: "image") as! String
        self.indicator =  aDecoder.decodeObject(forKey: "indicator") as! String
        self.slug = aDecoder.decodeObject(forKey: "slug") as! String
        self.price = aDecoder.decodeObject(forKey: "price") as! String
        self.subcategory_id =  aDecoder.decodeObject(forKey: "subcategory_id") as! String
        self.status = aDecoder.decodeObject(forKey: "status") as! String
        self.date_added = aDecoder.decodeObject(forKey: "date_added") as! String
        self.category_id = aDecoder.decodeObject(forKey: "category_id") as! String
        let data = aDecoder.decodeObject(forKey: "variants") as! Data
        self.variants = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Variants]
    }
    
    func encode(with aCoder: NSCoder) {
       aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.variants, forKey:"variants")
        aCoder.encode(self.product_description, forKey: "product_description")
        aCoder.encode(self.row_order, forKey: "row_order")
        aCoder.encode(self.other_images, forKey: "other_images")
        aCoder.encode(self.image, forKey:"image")
        aCoder.encode(self.indicator, forKey: "indicator")
        aCoder.encode(self.slug, forKey: "slug")
        aCoder.encode(self.price, forKey: "price")
        aCoder.encode(self.subcategory_id, forKey:"subcategory_id")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.date_added, forKey: "date_added")
        aCoder.encode(self.date_added, forKey: "date_added")
        
        let encodedData : NSData = NSKeyedArchiver.archivedData(withRootObject:self.variants) as NSData
        aCoder.encode(encodedData, forKey: "variants")
    }

}
