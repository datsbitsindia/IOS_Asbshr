//
//	SubCategoryData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SubCategoryData : NSObject, NSCoding{

	var categoryId : String!
	var id : String!
	var image : String!
	var name : String!
	var slug : String!
	var subtitle : String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		categoryId = dictionary["category_id"] as? String
		id = dictionary["id"] as? String
		image = dictionary["image"] as? String
		name = dictionary["name"] as? String
		slug = dictionary["slug"] as? String
		subtitle = dictionary["subtitle"] as? String
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
		if id != nil{
			dictionary["id"] = id
		}
		if image != nil{
			dictionary["image"] = image
		}
		if name != nil{
			dictionary["name"] = name
		}
		if slug != nil{
			dictionary["slug"] = slug
		}
		if subtitle != nil{
			dictionary["subtitle"] = subtitle
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
         id = aDecoder.decodeObject(forKey: "id") as? String
         image = aDecoder.decodeObject(forKey: "image") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         slug = aDecoder.decodeObject(forKey: "slug") as? String
         subtitle = aDecoder.decodeObject(forKey: "subtitle") as? String
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
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if slug != nil{
			aCoder.encode(slug, forKey: "slug")
		}
		if subtitle != nil{
			aCoder.encode(subtitle, forKey: "subtitle")
		}

	}

}
