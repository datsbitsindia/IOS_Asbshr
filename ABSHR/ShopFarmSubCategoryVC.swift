//
//  ShopFarmSubCategoryVC.swift
//  ABSHR
//
//  Created by Kishan Suthar on 09/01/21.
//  Copyright © 2021 skyinfos. All rights reserved.
//

import UIKit
import AlamofireImage
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage

class ShopFarmSubCategoryVC: UIViewController {

    @IBOutlet weak var btnBackGo: UIButton!
    @IBOutlet weak var cvTypes: UICollectionView!
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    var navTitle : String = ""
    
    var storeList = [StoreData]()
 
    var categoryId: Int = 0
    var subCatId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        lblNavigationTitle.text = "\(navTitle)"
        lblNavigationTitle.translateToarabic()
        getSubCategory()
        cvTypes.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func getSubCategory(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        var dictRequest = ["accesskey":90336]

            if subCatId != 0 {
                dictRequest["subcategory_id"] = subCatId
            }else {
                dictRequest["category_id"] = categoryId
            }
        
//        print(dictRequest)
        
        AF.request(GET_STORE_BY_CAT_OR_SUBCAT, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                _ = JSON(value)
                SVProgressHUD.dismiss()
                
                let data = StoreModel(fromDictionary: value as! [String : Any])
                self.storeList = data.data
                self.cvTypes.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
}

//MARK:- Collectionview Delegate
extension ShopFarmSubCategoryVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cvTypes.dequeueReusableCell(withReuseIdentifier: "TypeCell", for: indexPath) as! TypeCell
        
//        cell.backBorderView.layer.borderWidth = 0.5
//        cell.backBorderView.layer.borderColor = UIColor.black.cgColor
        cell.backBorderView.layer.cornerRadius = 4.0
        cell.backBorderView.layer.shadowColor = UIColor.black.cgColor
        cell.backBorderView.layer.shadowRadius = 1
        cell.backBorderView.layer.shadowOpacity = 1
        cell.backBorderView.layer.shadowOffset = CGSize(width: 3, height: 4)
        
        if getCurrentLang() == "ar-SA" {
            cell.lblTypeName.textAlignment = .right
        }else {
            cell.lblTypeName.textAlignment = .left
        }
        
//        let strdesc = storeList[indexPath.row].descriptions

        
        cell.lblTypeName.text = storeList[indexPath.row].name
        cell.lblTypeName.translateToarabic()
        cell.imgTypes.sd_setImage(with: URL(string: storeList[indexPath.row].image), completed: nil)
        
        if storeList[indexPath.row].descriptions != nil {
            cell.lblDescription.text =        storeList[indexPath.row].descriptions.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            cell.lblDescription.translateToarabic()
        }else {
            cell.lblDescription.text = ""
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (cvTypes.frame.width)
        return CGSize(width: width, height: 154.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        vc.selectedIndex = Int(storeList[indexPath.row].id) ?? 0
        vc.type = Int(storeList[indexPath.row].id) ?? 0
        vc.selectedStoreInd = indexPath.row
        vc.homeStoreList = storeList
        vc.cateID = categoryId
        vc.selectCatName = navTitle
        
        if subCatId != 0 {
            vc.SubCatID = subCatId
        }
        
//        vc.isHuman = false
        let nav1 = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = nav1
        appDelegate.window?.makeKeyAndVisible()
    }
}
