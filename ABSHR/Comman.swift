//
//  Comman.swift
// 
//
//  Created by mac on 03/09/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Localize_Swift
let userdefault = UserDefaults.standard
let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//var user = User()
let App_Color = UIColor(red: 63/255, green: 24/255, blue: 35/255, alpha: 1)

var listData = JSON.null
var lat = "40.6"
var long = "2.3"
var addressString = ""
var user_id = ""

let KEY_FIRSTTIME = "Firsttime"
let KEY_ISARABIC = "Arabic"
let KEY_CART = "Cart"
let KEY_FAVARITE = "Favarite"
let KEY_VERIFICATIONID = "Verificationid"
let KEY_GAUST = "Gaust"
let KEY_ISLOGIN = "Login"
let KEY_USER = "User"
let KEY_PASSWORD = "Password"
let KEY_SOCIAL = "Social"

var APP_ID = "1526664456"
var PRIVACY_POLICY = "https://loveemojiblog.wordpress.com/privacy-policy/"
var CONTECT_US = "https://loveemojiblog.wordpress.com/contact/"
var MORE_APPS = "itms-apps://apps.apple.com/developer/cbdash-infotech-llp/id1467854550"
var APP_URL = "http://itunes.apple.com/app/\(APP_ID)"
var ABOUT_US = ""
var FAQ = "https://zikzok.me/pages_web/faq.php"
var TERMSOFCONDITIONS = ""

var TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MDExMTQ1MjUsInN1YiI6ImVLYXJ0IEF1dGhlbnRpY2F0aW9uIiwiaXNzIjoiZUthcnQifQ.usjg40akQHBl5A1tiKto9_aQbgjchwMCpJkhJjs3SEA"

let CLIENTID = "780208750630-9goiqadr5dhanda7761rbl033tji170q.apps.googleusercontent.com"

var API_KEY = "AIzaSyBoag1siv9jlZpuDYTP-94HsLQVm2f5ymY"

let BASE_URL = "https://my.abshr.online/api-firebase/"


let GET_CATEGORIES = BASE_URL + "get-categories.php"
let GET_STORE_BY_CAT_OR_SUBCAT = BASE_URL + "get-store-by-subcategory-id-or-category-id.php"
let GET_SUB_CATEGORIES = BASE_URL + "get-subcategories-by-category-id.php"
let GET_CITIES = BASE_URL + "get-cities.php"
let GET_AREAOFCITIRE = BASE_URL + "get-areas-by-city-id.php"
let GET_PRODUCTSBY_CATEGORY = BASE_URL + "get-products-by-category-id.php"
let GET_PRODUCTBY_STOREID = BASE_URL + "get-products-by-store-id.php"
let GET_PRODUCTSBY_SUBCATEGORY = BASE_URL + "get-products-by-subcategory-id.php"
let GET_PRODUCTSBYID = BASE_URL + "get-product-by-id.php"
let ORDER_PROCESS = BASE_URL + "order-process.php"
let SET_DEVICE = BASE_URL + "set-device.php"
let REGISTRATION = BASE_URL + "user-registration.php"
let LOGIN = BASE_URL + "login.php"
let PRODUCTS_SEARCH = BASE_URL + "products-search.php"
let PROMO_CODE = BASE_URL + "validate-promo-code.php"

let SECTIONS = BASE_URL + "sections.php"
let SETTINGS = BASE_URL + "settings.php"
let SLIDER_IMAGES = BASE_URL + "slider-images.php"

let GET_DOCTORS = BASE_URL + "doctors-data.php"
let GET_PET_CATEGORY = BASE_URL + "pet_category.php"

let GET_FAQ = "https://my.abshr.online/pages_web/faq.php"

let GOOGLE_LOGIN = "https://my.abshr.online/api/redirect.php"
let FB_LOGIN = "https://my.abshr.online/api/facebook_login.php"
let APPLE_LOGIN = "https://my.abshr.online/api/apple_login.php"




func getCurrentLang() -> String{
    
   return UserDefaults.standard.string(forKey: "getCurrentLang") ?? "ar-SA"//"en"
}
func setCurrentLang(str:String){
    UserDefaults.standard.set(str, forKey: "getCurrentLang")
    Localize.setCurrentLanguage(getCurrentLang())
}
