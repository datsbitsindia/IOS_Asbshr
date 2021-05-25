//
//  NotificationVC.swift
//  ABSHR
//
//  Created by mac on 21/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage
import SVPullToRefresh

class SimilarProductVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblProductCount: UILabel!
    
    var product_list = [FavariteProducts]()
    var product_data = JSON.null
    var selected_variant = Int()
    var favarite_products = [FavariteProducts]()
    var productName = String()
    var product_id = String()
    var offset = Int()
    var cart_list = [CartItem]()
    var isNoMoreProduct = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
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
                 self.lblProductCount.text = "\(cart_list.count)"
            }

        }
        
        self.lblProductCount.translateToarabic()
        collectionView.register(UINib.init(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        SVProgressHUD.show()
        lblProductName.text = productName
        lblProductName.translateToarabic()
        if cart_list.count > 0{
            self.lblProductCount.isHidden = false
            
        }else{
           self.lblProductCount.isHidden = true
        }
        self.getData(text: productName)
        collectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            if !self.isNoMoreProduct{
                self.getData(text: self.productName)
            }else{
                self.collectionView.infiniteScrollingView.stopAnimating()
            }
            
        })
    }
    
    func getData(text:String){
        
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"subcategory_id":product_id,"limit":10,"offset":offset] as [String : Any]
        print(dictRequest)
        
        AF.request(GET_PRODUCTSBY_SUBCATEGORY, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    self.product_data = dict["data"]
                    if self.product_data.count > 0{
                        for i in 0..<self.product_data.count{
                            let other_images = self.product_data[i]["other_images"]
                            var images = [String]()
                            for j in 0..<other_images.count{
                                images.append(other_images[j].stringValue)
                            }
                            
                            let varitent = self.product_data[i]["variants"]
                            var varitents = [Variants]()
                            for j in 0..<varitent.count{
                                varitents.append(Variants.init(serve_for: varitent[j]["serve_for"].stringValue, id: varitent[j]["id"].stringValue, measurement_unit_id: varitent[j]["measurement_unit_id"].stringValue, price: varitent[j]["price"].stringValue, product_id: varitent[j]["product_id"].stringValue, stock: varitent[j]["stock"].stringValue, measurement_unit_name: varitent[j]["measurement_unit_name"].stringValue, type: varitent[j]["type"].stringValue, discounted_price: varitent[j]["discounted_price"].stringValue, stock_unit_id: varitent[j]["stock_unit_id"].stringValue, stock_unit_name: varitent[j]["stock_unit_name"].stringValue, measurement: varitent[j]["measurement"].stringValue))
                            }
                            
                            self.product_list.append(FavariteProducts.init(id: self.product_data[i]["id"].stringValue, name: self.product_data[i]["name"].stringValue, product_description: self.product_data[i]["description"].stringValue, row_order: self.product_data[i]["row_order"].stringValue, other_images: images, image: self.product_data[i]["image"].stringValue, indicator: self.product_data[i]["indicator"].stringValue, slug: self.product_data[i]["slug"].stringValue, variants: varitents, price: self.product_data[i]["price"].stringValue, subcategory_id: self.product_data[i]["subcategory_id"].stringValue, status: self.product_data[i]["status"].stringValue, date_added: self.product_data[i]["date_added"].stringValue, category_id: self.product_data[i]["category_id"].stringValue, product_count: "0"))
                        }
                        self.offset = self.offset + 10
                        self.collectionView.infiniteScrollingView.stopAnimating()
                        self.collectionView.reloadData()
                        
                    }else{
                        self.collectionView.infiniteScrollingView.stopAnimating()
                        self.collectionView.reloadData()
                    }
                }else{
                    if dict["message"].stringValue.count > 0{
                        AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                    }else{
//                        AppHelper.shared.showToast(message: dict["data"].stringValue, sender: self)
                        if dict["data"].stringValue == "No products available"{
                            self.isNoMoreProduct = true
                        }
//                        self.collectionView.reloadData()
                    }
                    self.collectionView.infiniteScrollingView.stopAnimating()
                    self.collectionView.reloadData()
                }
                
                print(dict)
                
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
    
    //MARK:- Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0{
            self.getData(text: searchText)
        }
    }
    
    
    @objc func actionPlus(_ sender:UIButton){
        let total = Int(self.product_list[sender.tag].product_count)! + 1
        self.product_list[sender.tag].product_count = "\(total)"
        self.addProduct(index: sender.tag, count: total)
        self.collectionView.reloadData()
    }
    
    @objc func actionMinus(_ sender:UIButton){
        if Int(self.product_list[sender.tag].product_count)! > 0{
            let total = Int(self.product_list[sender.tag].product_count)! - 1
            self.product_list[sender.tag].product_count = "\(total)"
            self.addProduct(index: sender.tag, count: total)
            self.collectionView.reloadData()
        }
    }
    
    @objc func actionFaverite(_ sender:UIButton){
        sender.isSelected = sender.isSelected == true ? false : true
        var index = Int()
        var isStore = Bool()
        for i in 0..<favarite_products.count{
            if favarite_products[i].id == product_list[sender.tag].id{
                index = i
                isStore = true
            }
        }
        
        if !isStore{
            favarite_products.append(product_list[sender.tag])
        }else{
            favarite_products.remove(at: index)
        }
        
        let placesData = NSKeyedArchiver.archivedData(withRootObject: self.favarite_products)
        userdefault.set(placesData, forKey: KEY_FAVARITE)
        userdefault.synchronize()
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCart(_ sender: Any) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSort(_ sender: Any) {
        
        let alert = UIAlertController(title: "Filter By", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Newest to Oldest", style: .default , handler:{ (UIAlertAction)in
            let list = self.product_list.sorted(by: { $0.date_added.toDate(DateFormat.mmmddyyyhhmm.rawValue) > $1.date_added.toDate(DateFormat.mmmddyyyhhmm.rawValue) })
            self.product_list = list
            self.collectionView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Oldest to Newest", style: .default , handler:{ (UIAlertAction)in
            let list = self.product_list.sorted(by: { $0.date_added.toDate(DateFormat.mmmddyyyhhmm.rawValue) < $1.date_added.toDate(DateFormat.mmmddyyyhhmm.rawValue) })
            self.product_list = list
            self.collectionView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Price Highest to Lowest", style: .default , handler:{ (UIAlertAction)in
            let list = self.product_list.sorted(by: { Int($0.price)! > Int($1.price)! })
            self.product_list = list
            self.collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Price Lowest to Highest", style: .default, handler:{ (UIAlertAction)in
            let list = self.product_list.sorted(by: { Int($0.price)! < Int($1.price)! })
            self.product_list = list
            self.collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                   
               }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func addProduct(index:Int,count:Int){
        if count > 0{
            var isAvalible = false
            var index1 = Int()
            var price = String()
            var discount = String()
            for i in 0..<cart_list.count{
                if cart_list[i].id == product_list[index].variants[selected_variant].id{
                    isAvalible = true
                    index1 = i
                }
            }
            if product_list[index].variants[selected_variant].discounted_price == "0"{
                price = product_list[index].variants[selected_variant].price
                discount = ""
            }else{
                price = product_list[index].variants[selected_variant].discounted_price
                
                let diff = Int(product_list[index].variants[selected_variant].price)! - Int(product_list[index].variants[selected_variant].discounted_price)!
                let dic = (100*diff)/Int(product_list[index].variants[selected_variant].price)!
                
                discount = "QAR \(product_list[index].variants[selected_variant].price) (\(Int(dic))%)"
            }
            
            if !isAvalible{
                cart_list.append(CartItem.init(id: product_list[index].variants[selected_variant].id, name: product_list[index].name, image: product_list[index].image, price:price, count: "\(count)", mesurment: "( \(product_list[index].variants[0].measurement) \(product_list[index].variants[0].measurement_unit_name) )", discount: discount))
            }else{
                cart_list[index1].id = product_list[index].variants[selected_variant].id
                cart_list[index1].name = product_list[index].name
                cart_list[index1].image = product_list[index].image
                cart_list[index1].price = price
                cart_list[index1].count = "\(count)"
                cart_list[index1].mesurment = "( \(product_list[index].variants[0].measurement) \(product_list[index].variants[0].measurement_unit_name) )"
                cart_list[index].discount = discount
            }
        }else{
            cart_list.remove(at: index)
        }
        
        if cart_list.count > 0{
            self.lblProductCount.isHidden = false
            self.lblProductCount.text = "\(cart_list.count)"
        }else{
            self.lblProductCount.isHidden = true
        }
        
        let placesData = NSKeyedArchiver.archivedData(withRootObject: self.cart_list)
        userdefault.set(placesData, forKey: KEY_CART)
        userdefault.synchronize()
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Collectionview Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.product_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCell
        cell.viewContent.frame.size.width = (collectionView.frame.size.width-8)
        cell.viewContent.frame.size.height = 175
        cell.imgProduct.sd_setImage(with: URL.init(string: self.product_list[indexPath.row].image), placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached], context: nil)
        cell.lblTitle.text = self.product_list[indexPath.row].name
        cell.lblDescription.text = self.product_list[indexPath.row].product_description.htmlToString
        cell.viewVariants.isHidden = self.product_list[indexPath.row].variants.count > 1 ? false : true
        if self.product_list[indexPath.row].variants[selected_variant].discounted_price == "0"{
            cell.lblPrice.text = "Offer Price:- QAR \(self.product_list[indexPath.row].price).00"
        }else{
            cell.lblMRP.text = "M.R.P.: QAR \(self.product_list[indexPath.row].variants[selected_variant].price).00"
            let diff = Int(self.product_list[indexPath.row].variants[selected_variant].price)! - Int(self.product_list[indexPath.row].variants[selected_variant].discounted_price)!
            let dic = (100*diff)/Int(self.product_list[indexPath.row].variants[selected_variant].price)!
            if Int(dic) > 0{
                cell.lblDiscount.text = "You Save : QAR \(diff).00 (\(Int(dic))%)"
            }
            cell.lblPrice.text = "Offer Price:- QAR \(self.product_list[indexPath.row].variants[selected_variant].discounted_price).00"
        }
        cell.lblMeasemetn.text = "( \(self.product_list[indexPath.row].variants[selected_variant].measurement) \(self.product_list[indexPath.row].variants[selected_variant].measurement_unit_name) )"
        cell.lblCount.text = self.product_list[indexPath.row].product_count
        var isStore = Bool()
        for i in 0..<self.favarite_products.count{
            if favarite_products[i].id == product_list[indexPath.row].id{
                isStore = true
            }
        }
        for i in 0..<cart_list.count{
            if cart_list[i].id == self.product_list[indexPath.row].variants[selected_variant].id{
                self.product_list[indexPath.row].product_count = cart_list[i].count
//                self.productCount = Int(cart_list[i].count)!
//                self.lblItemsCount.text = cart_list[i].count
                cell.lblCount.text = self.product_list[indexPath.row].product_count
            }
        }
        
        cell.btnFav.isSelected = isStore == true ? true : false
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(actionPlus(_:)), for: .touchUpInside)
        cell.btnMinus.tag = indexPath.row
        cell.btnMinus.addTarget(self, action: #selector(actionMinus(_:)), for: .touchUpInside)
        cell.btnFav.tag = indexPath.row
        cell.btnFav.addTarget(self, action: #selector(actionFaverite(_:)), for: .touchUpInside)
        cell.shadow()
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
        vc.product_details = Products.init(id: product_list[indexPath.row].id, name: product_list[indexPath.row].name, product_description: product_list[indexPath.row].product_description, row_order: product_list[indexPath.row].row_order, other_images: product_list[indexPath.row].other_images, image: product_list[indexPath.row].image, indicator: product_list[indexPath.row].indicator, slug: product_list[indexPath.row].slug, variants: product_list[indexPath.row].variants, price: product_list[indexPath.row].price, subcategory_id: product_list[indexPath.row].subcategory_id, status: product_list[indexPath.row].status, date_added: product_list[indexPath.row].date_added, category_id: product_list[indexPath.row].category_id)
        vc.productCount = Int(product_list[indexPath.row].product_count) ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
