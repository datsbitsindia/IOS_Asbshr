//
//	CategoryData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CategoryData : NSObject, NSCoding{

	var id : String!
	var image : String!
	var name : String!
	var status : AnyObject!
	var subtitle : String!
    var is_subcategory : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["id"] as? String
		image = dictionary["image"] as? String
		name = dictionary["name"] as? String
		status = dictionary["status"] as? AnyObject
		subtitle = dictionary["subtitle"] as? String
        is_subcategory = dictionary["is_subcategory"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["id"] = id
		}
		if image != nil{
			dictionary["image"] = image
		}
		if name != nil{
			dictionary["name"] = name
		}
		if status != nil{
			dictionary["status"] = status
		}
		if subtitle != nil{
			dictionary["subtitle"] = subtitle
		}
        if is_subcategory != nil {
            dictionary["is_subcategory"] = is_subcategory
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? String
         image = aDecoder.decodeObject(forKey: "image") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         status = aDecoder.decodeObject(forKey: "status") as? AnyObject
         subtitle = aDecoder.decodeObject(forKey: "subtitle") as? String
        is_subcategory = aDecoder.decodeObject(forKey: "is_subcategory") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if subtitle != nil{
			aCoder.encode(subtitle, forKey: "subtitle")
		}
        if is_subcategory != nil {
            aCoder.encode(is_subcategory, forKey: "is_subcategory")
        }

	}

}
