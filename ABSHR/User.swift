//
//  User.swift
//  ABSHR
//
//  Created by mac on 15/10/20.
//  Copyright © . All rights reserved.
//

import Foundation

class User: NSObject,NSCoding{
    
    var user_id = String()
    var city_id = String()
    var status = String()
    var latitude = String()
    var country_code = String()
    var message = String()
    var mobile = String()
    var street = String()
    var created_at = String()
    var apikey = String()
    var area_name = String()
    var city_name = String()
    var dob = String()
    var area_id = String()
    var name = String()
    var referral_code = String()
    var fcm_id = String()
    var email = String()
    var pincode = String()
    var friends_code = String()
    var longitude = String()
    
    override init() {
        
    }
    
    init(user_id:String,city_id:String,status:String,latitude:String,country_code:String,message:String,mobile:String,street:String,created_at:String,apikey:String,area_name:String,city_name:String,dob:String,area_id:String,name:String,referral_code:String,fcm_id:String,email:String,pincode:String,friends_code:String,longitude:String) {
        self.user_id = user_id
        self.city_id = city_id
        self.status = status
        self.latitude = latitude
        self.country_code = country_code
        self.message = message
        self.mobile = mobile
        self.street = street
        self.created_at = created_at
        self.apikey = apikey
        self.area_name = area_name
        self.city_name = city_name
        self.dob = dob
        self.area_id = area_id
        self.name = name
        self.referral_code = referral_code
        self.fcm_id = fcm_id
        self.email = email
        self.pincode = pincode
        self.friends_code = friends_code
        self.longitude = longitude
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.user_id = aDecoder.decodeObject(forKey: "user_id") as! String
        self.city_id = aDecoder.decodeObject(forKey: "city_id") as! String
        self.status = aDecoder.decodeObject(forKey: "status") as! String
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        self.country_code = aDecoder.decodeObject(forKey: "country_code") as! String
        self.message = aDecoder.decodeObject(forKey: "message") as! String
        self.mobile = aDecoder.decodeObject(forKey: "mobile") as! String
        self.street =  aDecoder.decodeObject(forKey: "street") as! String
        self.created_at = aDecoder.decodeObject(forKey: "created_at") as! String
        self.apikey = aDecoder.decodeObject(forKey: "apikey") as! String
        self.area_name =  aDecoder.decodeObject(forKey: "area_name") as! String
        self.city_name =  aDecoder.decodeObject(forKey: "city_name") as! String
        self.dob = aDecoder.decodeObject(forKey: "dob") as! String
        self.area_id = aDecoder.decodeObject(forKey: "area_id") as! String
        self.name =  aDecoder.decodeObject(forKey: "name") as! String
        self.referral_code =  aDecoder.decodeObject(forKey: "referral_code") as! String
        self.fcm_id = aDecoder.decodeObject(forKey: "fcm_id") as! String
        self.email =  aDecoder.decodeObject(forKey: "email") as! String
        self.pincode =  aDecoder.decodeObject(forKey: "pincode") as! String
        self.friends_code = aDecoder.decodeObject(forKey: "friends_code") as! String
        self.longitude =  aDecoder.decodeObject(forKey: "longitude") as! String
    }
    

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.user_id, forKey: "user_id")
        aCoder.encode(self.city_id, forKey:"city_id")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.country_code, forKey: "country_code")
        aCoder.encode(self.message, forKey:"message")
        aCoder.encode(self.mobile, forKey: "mobile")
        aCoder.encode(self.street, forKey: "street")
        aCoder.encode(self.created_at, forKey: "created_at")
        aCoder.encode(self.apikey, forKey:"apikey")
        aCoder.encode(self.area_name, forKey: "area_name")
        aCoder.encode(self.city_name, forKey: "city_name")
        aCoder.encode(self.dob, forKey: "dob")
        aCoder.encode(self.area_id, forKey: "area_id")
        aCoder.encode(self.name, forKey:"name")
        aCoder.encode(self.referral_code, forKey: "referral_code")
        aCoder.encode(self.fcm_id, forKey: "fcm_id")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.pincode, forKey: "pincode")
        aCoder.encode(self.friends_code, forKey:"friends_code")
        aCoder.encode(self.longitude, forKey: "longitude")

    }
    
}
