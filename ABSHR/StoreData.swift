//
//	StoreData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class StoreData : NSObject, NSCoding{

	var categoryId : String!
	var created : String!
	var id : String!
    var descriptions : String!
	var image : String!
	var modified : AnyObject!
	var name : String!
	var slug : String!
	var subcategoryId : String!
	var subtitle : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		categoryId = dictionary["category_id"] as? String
		created = dictionary["created"] as? String
		id = dictionary["id"] as? String
		image = dictionary["image"] as? String
		modified = dictionary["modified"] as? AnyObject
		name = dictionary["name"] as? String
		slug = dictionary["slug"] as? String
		subcategoryId = dictionary["subcategory_id"] as? String
		subtitle = dictionary["subtitle"] as? String
        descriptions = dictionary["Descriptions"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if categoryId != nil{
			dictionary["category_id"] = categoryId
		}
		if created != nil{
			dictionary["created"] = created
		}
		if id != nil{
			dictionary["id"] = id
		}
		if image != nil{
			dictionary["image"] = image
		}
		if modified != nil{
			dictionary["modified"] = modified
		}
		if name != nil{
			dictionary["name"] = name
		}
		if slug != nil{
			dictionary["slug"] = slug
		}
		if subcategoryId != nil{
			dictionary["subcategory_id"] = subcategoryId
		}
		if subtitle != nil{
			dictionary["subtitle"] = subtitle
		}
        if descriptions != nil {
            dictionary["Descriptions"] = descriptions
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
         created = aDecoder.decodeObject(forKey: "created") as? String
         id = aDecoder.decodeObject(forKey: "id") as? String
         image = aDecoder.decodeObject(forKey: "image") as? String
         modified = aDecoder.decodeObject(forKey: "modified") as? AnyObject
         name = aDecoder.decodeObject(forKey: "name") as? String
         slug = aDecoder.decodeObject(forKey: "slug") as? String
         subcategoryId = aDecoder.decodeObject(forKey: "subcategory_id") as? String
         subtitle = aDecoder.decodeObject(forKey: "subtitle") as? String
        descriptions = aDecoder.decodeObject(forKey: "Descriptions") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if categoryId != nil{
			aCoder.encode(categoryId, forKey: "category_id")
		}
		if created != nil{
			aCoder.encode(created, forKey: "created")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if modified != nil{
			aCoder.encode(modified, forKey: "modified")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if slug != nil{
			aCoder.encode(slug, forKey: "slug")
		}
		if subcategoryId != nil{
			aCoder.encode(subcategoryId, forKey: "subcategory_id")
		}
		if subtitle != nil{
			aCoder.encode(subtitle, forKey: "subtitle")
		}
        if descriptions != nil {
            aCoder.encode(descriptions,forKey: "Descriptions")
        }

	}

}
