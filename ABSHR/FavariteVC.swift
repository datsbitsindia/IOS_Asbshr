//
//  FavariteVC.swift
//  ABSHR
//
//  Created by mac on 12/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage

class FavariteVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var btnBackGo: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblfav: UILabel!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
    var selected_variant = Int()
    var favarite_products = [FavariteProducts]()
    var cart_list = [CartItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    func initView(){
        lblfav.setLocalize()
        DispatchQueue.main.async {
            if !UIDevice.current.hasNotch{
                self.viewHeaderHeight.constant = 66
            }
        }
        
        let placesData1 = UserDefaults.standard.object(forKey: KEY_FAVARITE) as? NSData
        if let placesData1 = placesData1 {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData1 as Data) as? [FavariteProducts]
            if let placesArray = placesArray {
                self.favarite_products = placesArray
            }
        }
        
        let placesData = UserDefaults.standard.object(forKey: KEY_CART) as? NSData
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [CartItem]
            if let placesArray = placesArray {
                self.cart_list = placesArray
                
            }

        }
        
        collectionView.register(UINib.init(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    //MARK:- Action
    
    @objc func actionPlus(_ sender:UIButton){
        let total = Int(self.favarite_products[sender.tag].product_count)! + 1
        self.favarite_products[sender.tag].product_count = "\(total)"
        self.addProduct(index: sender.tag, count: total)
        self.collectionView.reloadData()
    }
    
    @objc func actionMinus(_ sender:UIButton){
        if Int(self.favarite_products[sender.tag].product_count)! > 0{
            let total = Int(self.favarite_products[sender.tag].product_count)! - 1
            self.addProduct(index: sender.tag, count: total)
            self.favarite_products[sender.tag].product_count = "\(total)"
            self.collectionView.reloadData()
        }
    }
    
    @objc func actionFaverite(_ sender:UIButton){
        favarite_products.remove(at: sender.tag)
        collectionView.reloadData()
        let placesData = NSKeyedArchiver.archivedData(withRootObject: self.favarite_products)
        userdefault.set(placesData, forKey: KEY_FAVARITE)
        userdefault.synchronize()
        
    }
    
    func addProduct(index:Int,count:Int){
        
        if count > 0{
            var isAvalible = false
            var index1 = Int()
            var price = String()
            var discount = String()
            for i in 0..<cart_list.count{
                if cart_list[i].id == favarite_products[index].variants[selected_variant].id{
                    isAvalible = true
                    index1 = i
                }
            }
            if favarite_products[index].variants[selected_variant].discounted_price == "0"{
                price = favarite_products[index].variants[selected_variant].price
                discount = ""
            }else{
                price = favarite_products[index].variants[selected_variant].discounted_price
                
                let diff = Int(favarite_products[index].variants[selected_variant].price)! - Int(favarite_products[index].variants[selected_variant].discounted_price)!
                let dic = (100*diff)/Int(favarite_products[index].variants[selected_variant].price)!
                
                discount = "QAR \(favarite_products[index].variants[selected_variant].price) (\(Int(dic))%)"
            }
            
            if !isAvalible{
                cart_list.append(CartItem.init(id: favarite_products[index].variants[selected_variant].id, name: favarite_products[index].name, image: favarite_products[index].image, price:price, count: "\(count)", mesurment: "( \(favarite_products[index].variants[0].measurement) \(favarite_products[index].variants[0].measurement_unit_name) )", discount: discount))
            }else{
                cart_list[index1].id = favarite_products[index1].variants[selected_variant].id
                cart_list[index1].name = favarite_products[index].name
                cart_list[index1].image = favarite_products[index].image
                cart_list[index1].price = price
                cart_list[index1].count = "\(count)"
                cart_list[index1].mesurment = "( \(favarite_products[index].variants[0].measurement) \(favarite_products[index].variants[0].measurement_unit_name) )"
                cart_list[index].discount = discount
            }
        }else{
            cart_list.remove(at: index)
        }
        
        let placesData = NSKeyedArchiver.archivedData(withRootObject: self.cart_list)
        userdefault.set(placesData, forKey: KEY_CART)
        userdefault.synchronize()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Collectionview Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favarite_products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCell
        cell.viewContent.frame.size.width = (collectionView.frame.size.width-8)
        cell.viewContent.frame.size.height = 175
        cell.imgProduct.sd_setImage(with: URL.init(string: self.favarite_products[indexPath.row].image), placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached], context: nil)
        cell.lblTitle.text = self.favarite_products[indexPath.row].name
        cell.lblDescription.text = self.favarite_products[indexPath.row].product_description.htmlToString
        cell.viewVariants.isHidden = self.favarite_products[indexPath.row].variants.count > 1 ? false : true
        if self.favarite_products[indexPath.row].variants[selected_variant].discounted_price == "0"{
            cell.lblPrice.text = "Offer Price:- QAR \(self.favarite_products[indexPath.row].price).00"
            cell.lblMRP.text = ""
            cell.lblMRPHeight.constant = 0
            cell.lblDiscount.text = ""
            cell.lblDiscountHeight.constant = 0
        }else{
            cell.lblMRPHeight.constant = 15
            
            cell.lblMRP.text = "M.R.P.: QAR \(self.favarite_products[indexPath.row].variants[selected_variant].price).00"
            let diff = Int(self.favarite_products[indexPath.row].variants[selected_variant].price)! - Int(self.favarite_products[indexPath.row].variants[selected_variant].discounted_price)!
            let dic = (100*diff)/Int(self.favarite_products[indexPath.row].variants[selected_variant].price)!
            if Int(dic) > 0{
                cell.lblDiscount.text = "You Save : QAR \(diff).00 (\(Int(dic))%)"
                cell.lblDiscountHeight.constant = 12
            }else{
                cell.lblDiscount.text = ""
                cell.lblDiscountHeight.constant = 10
            }
            cell.lblPrice.text = "Offer Price:- QAR \(self.favarite_products[indexPath.row].variants[selected_variant].discounted_price).00"
        }
        cell.lblMeasemetn.text = "( \(self.favarite_products[indexPath.row].variants[selected_variant].measurement) \(self.favarite_products[indexPath.row].variants[selected_variant].measurement_unit_name) )"
        cell.lblCount.text = self.favarite_products[indexPath.row].product_count
        
        for i in 0..<cart_list.count{
            if cart_list[i].id == self.favarite_products[indexPath.row].variants[selected_variant].id{
                self.favarite_products[indexPath.row].product_count = cart_list[i].count
                
                cell.lblCount.text = self.favarite_products[indexPath.row].product_count
            }
        }
        
        cell.btnFav.isSelected = true
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(actionPlus(_:)), for: .touchUpInside)
        cell.btnMinus.tag = indexPath.row
        cell.btnMinus.addTarget(self, action: #selector(actionMinus(_:)), for: .touchUpInside)
        cell.btnFav.tag = indexPath.row
        cell.btnFav.addTarget(self, action: #selector(actionFaverite(_:)), for: .touchUpInside)
        [cell.lblTitle,cell.lblMRP,cell.lblCount,cell.lblPrice,cell.lblDiscount,cell.lblMeasemetn,cell.lblDescription,cell.lblmore].forEach{
                   $0?.translateToarabic()
               }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (collectionView.frame.size.width-8), height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.product_details = Products.init(id: favarite_products[indexPath.row].id, name: favarite_products[indexPath.row].name, product_description: favarite_products[indexPath.row].product_description, row_order: favarite_products[indexPath.row].row_order, other_images: favarite_products[indexPath.row].other_images, image: favarite_products[indexPath.row].image, indicator: favarite_products[indexPath.row].indicator, slug: favarite_products[indexPath.row].slug, variants: favarite_products[indexPath.row].variants, price: favarite_products[indexPath.row].price, subcategory_id: favarite_products[indexPath.row].subcategory_id, status: favarite_products[indexPath.row].status, date_added: favarite_products[indexPath.row].date_added, category_id: favarite_products[indexPath.row].category_id)
        vc.productCount = Int(favarite_products[indexPath.row].product_count) ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
