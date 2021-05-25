//
//  SelectTypeVC.swift
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

class SelectTypeVC: UIViewController{

    @IBOutlet weak var cvTypes: UICollectionView!
    @IBOutlet weak var viewCollection: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var btnBackGo: UIButton!
    
    var subcategoryList = [SubCategoryData]()
    var type = Int()
    var selectedIndex = Int()
    
    var index = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    func initView(){
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
        getSubCategory()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func actionNext(_ sender: Any) {
//        if index < imageList.count-1{
//            index += 1
//            collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .left, animated: true)
//        }
    }
    
    func getSubCategory(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        var dictRequest = ["accesskey":90336]
        dictRequest["category_id"] = type
        
//        print(dictRequest)
        
        AF.request(GET_SUB_CATEGORIES, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                _ = JSON(value)
                SVProgressHUD.dismiss()
                
                let data = SubCategoryModel(fromDictionary: value as! [String : Any])
                self.subcategoryList = data.data
                self.cvTypes.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
    
    @IBAction func actionPre(_ sender: Any) {
        if index > 1{
            index -= 1
            collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .right,animated: true)
        }
    }
}

//MARK:- Collectionview Delegate
extension SelectTypeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subcategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cvTypes.dequeueReusableCell(withReuseIdentifier: "TypeCell", for: indexPath) as! TypeCell
        
        cell.lblTypeName.text = subcategoryList[indexPath.row].name
        cell.imgTypes.sd_setImage(with: URL(string: subcategoryList[indexPath.row].image), completed: nil)
        cell.lblTypeName.translateToarabic()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (cvTypes.frame.width / 2) - 20.0
        return CGSize(width: width, height: width + 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
        vc.categoryId = type
        vc.navTitle = subcategoryList[indexPath.row].name ?? ""
        vc.subCatId = Int(subcategoryList[indexPath.row].id) ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if subcategoryList[indexPath.row].categoryId == "51" {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            vc.selectedIndex = Int(subcategoryList[indexPath.row].id) ?? 0
//            vc.type = Int(subcategoryList[indexPath.row].id) ?? 0
//            vc.isHuman = false
//            let nav1 = UINavigationController(rootViewController: vc)
//            appDelegate.window?.rootViewController = nav1
//            appDelegate.window?.makeKeyAndVisible()
//        }
    }
}

