//
//  SelectCategoryVC.swift
//  ABSHR
//
//  Created by mac on 07/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import AlamofireImage
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage
import SVPullToRefresh

class SelectCategoryVC: UIViewController {
    
    @IBOutlet weak var lblLogo1: UILabel!
    @IBOutlet weak var imgLogo1: UIImageView!
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var btnSupermarket: UIButton!
    @IBOutlet weak var btnFish: UIButton!
    @IBOutlet weak var btnSuperstar: UIButton!
    @IBOutlet weak var btnShopFarm: UIButton!
    @IBOutlet weak var btnFood: UIButton!
    
    @IBOutlet weak var lblLogo: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    var type = Int()
    var user = User()
    var categoryList = [CategoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        if getCurrentLang() == "ar-SA" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            imgLogo.isHidden = true
            lblLogo.isHidden = true
            imgLogo1.isHidden = false
            lblLogo1.isHidden = false
                        
            lblLogo.setLocalize()
            lblLogo1.setLocalize()
            
            imgLogo1.transform = CGAffineTransform(scaleX: -1, y: 1)
            lblLogo1.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            imgBG.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnFish.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnFood.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnSuperstar.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnShopFarm.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnSupermarket.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            btnFish.setImage(UIImage(named: "fish_arabic"), for: .normal)
            btnFood.setImage(UIImage(named: "food_Arabic"), for: .normal)
            btnSupermarket.setImage(UIImage(named: "supermarket_Arabic"), for: .normal)
            btnShopFarm.setImage(UIImage(named: "shop_farm_arabic"), for: .normal)
            btnSuperstar.setImage(UIImage(named: "Superstars_arabic"), for: .normal)
            
            self.view.semanticContentAttribute = .forceRightToLeft
        }else {
            
            imgLogo.isHidden = false
            lblLogo.isHidden = false
            imgLogo1.isHidden = true
            lblLogo1.isHidden = true
            lblLogo.setLocalize()
            lblLogo1.setLocalize()
            
            btnFish.setImage(UIImage(named: "cat_fish"), for: .normal)
            btnFood.setImage(UIImage(named: "cat_food"), for: .normal)
            btnSupermarket.setImage(UIImage(named: "cat_Supermarket"), for: .normal)
            btnShopFarm.setImage(UIImage(named: "cat_shop_farma"), for: .normal)
            btnSuperstar.setImage(UIImage(named: "cat_Superstars"), for: .normal)
            
//            imgLogo.transform = CGAffineTransform(scaleX: -1, y: 1)
//            lblLogo.transform = CGAffineTransform(scaleX: -1, y: 1)
            
//            imgLogo1.transform = CGAffineTransform(scaleX: -1, y: 1)
//            lblLogo1.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.view.semanticContentAttribute = .forceLeftToRight
        }
        
    }
    
    func initView(){
        getCategory()
    }
    
    func getCategory(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336]
//        print(dictRequest)
        
        AF.request(GET_CATEGORIES, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let data = CategoryModel(fromDictionary: value as! [String : Any])
                self.categoryList = data.data
                SVProgressHUD.dismiss()
                
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let placesData1 = UserDefaults.standard.object(forKey: KEY_USER) as? NSData
        if let placesData = placesData1 {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? User
            if let placesArray = placesArray {
                self.user = placesArray
            }
        }
        
    }
    
    @IBAction func actionFood(_ sender: Any) {
        
        let data = getCategoryDetail(str: "Food")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
        vc.categoryId = 47
        vc.navTitle = "Food"
        
//        vc.subCatId = Int(subcategoryList[indexPath.row].id) ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
      
        
//        if data.is_subcategory == "1" {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectTypeVC") as! SelectTypeVC
//            vc.type = 47
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
//            vc.categoryId = 47
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func btnSuperStartAction(_ sender: Any) {
        
        let data = getCategoryDetail(str: "SuperStars")
        
        if data.is_subcategory == "1" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectTypeVC") as! SelectTypeVC
            vc.type = 50
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
            vc.categoryId = 50
            vc.navTitle = "SuperStars"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func btnSuperMarket(_ sender: Any) {
        let data = getCategoryDetail(str: "Fish")
  
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        vc.cateID = 48

//        let nav1 = UINavigationController(rootViewController: vc)
//        appDelegate.window?.rootViewController = nav1
//        appDelegate.window?.makeKeyAndVisible()
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func btnFish(_ sender: Any) {
        
        let data = getCategoryDetail(str: "Super Market")
        
        if data.is_subcategory == "1" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectTypeVC") as! SelectTypeVC
            vc.type = 49
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
            vc.categoryId = 49
            vc.navTitle = "Supermarket"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

        
//        if data.is_subcategory == "1" {
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectTypeVC") as! SelectTypeVC
//            vc.type = 48
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
//            vc.categoryId = 48
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func btnShopsFarms(_ sender: Any) {
        
        let data = getCategoryDetail(str: "Shop and Farm")
        
        if data.is_subcategory == "1" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectTypeVC") as! SelectTypeVC
            vc.type = 51
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
            vc.categoryId = 51
            vc.navTitle = "Shops and Farms"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getCategoryDetail(str: String) -> CategoryData{
        let data = categoryList.filter { (data) -> Bool in
            if data.name == str {
                return true
            }
            return false
        }
        if data.count > 0 {
            return data.first!
        }
        return CategoryData(fromDictionary: [:])
    }
}
