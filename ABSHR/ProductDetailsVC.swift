//
//  ProductDetailsVC.swift
//  ABSHR
//
//  Created by mac on 08/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import ImageSlideshow
import AlamofireImage
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ProductDetailsVC: UIViewController {

    @IBOutlet weak var simiProView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var btnBackGo: UIButton!
    @IBOutlet weak var lblQnt: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblSimi: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblMore: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblprcdct: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPic: UILabel!
    @IBOutlet weak var lblItemsCount: UILabel!
    @IBOutlet weak var textDetails: UITextView!
    @IBOutlet weak var textDetailsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var viewMoreVarients: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var lblMRP: UILabel!
    @IBOutlet weak var imgFavarite: UIImageView!
    @IBOutlet weak var lblCartCount: UILabel!
    
    var product_details = Products()
    var favarite_products = [FavariteProducts]()
    var productCount = Int()
    var cart_list = [CartItem]()
    var selected_variant = Int()
    var discount = String()
    var slider1 = [AlamofireSource]()
    var verients = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
            likeView.semanticContentAttribute = .forceLeftToRight
            lblLike.textAlignment = .left
            shareView.semanticContentAttribute = .forceLeftToRight
            lblShare.textAlignment = .left
            simiProView.semanticContentAttribute = .forceLeftToRight
            lblSimi.textAlignment = .left
        }else {
            likeView.semanticContentAttribute = .forceLeftToRight
            lblLike.textAlignment = .left
            shareView.semanticContentAttribute = .forceLeftToRight
            lblShare.textAlignment = .left
            simiProView.semanticContentAttribute = .forceLeftToRight
            lblSimi.textAlignment = .left
        }
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
        
        self.setData()
        self.setupSlideShow()
    }
    
    func changeLang(){
        
        lblTittle.translateToarabic()
        lblLike.setLocalize()
        lblShare.setLocalize()
        lblSimi.setLocalize()
        lblOffer.setLocalize()
        lblMore.setLocalize()
        lblprcdct.setLocalize()
        lblTittle.setLocalize()
        lblTitle.setLocalize()
        lblQnt.setLocalize()
        btnAdd.setLocalize()
  
//        [lblQnt,lblLike,lblShare,lblSimi,lblOffer,lblMore,lblprcdct,lblPrice,lblPic,lblItemsCount,lblTittle,lblDiscount,lblMRP].forEach{
//            $0?.setLocalize()
//        }
//        lblTitle.setLocalize()
//        [btnAdd].forEach{
//            $0?.setLocalize()
//        }
//        [textDetails].forEach{
//            $0?.setLocalize()
//        }
        
//        [lblQnt,lblLike,lblShare,lblSimi,lblOffer,lblMore,lblprcdct,lblPrice,lblPic,lblItemsCount,lblTittle,lblDiscount,lblMRP].forEach{
//            $0?.translateToarabic()
//        }
//        lblTitle.setLocalize()
//        [btnAdd].forEach{
//            $0?.translateToarabic()
//        }
//        [textDetails].forEach{
//            $0?.translateToarabic()
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let placesData = UserDefaults.standard.object(forKey: KEY_CART) as? NSData
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [CartItem]
            if let placesArray = placesArray {
                self.cart_list = placesArray
                if cart_list.count > 0{
                    lblCartCount.isHidden = false
                    lblCartCount.text = "\(self.cart_list.count)"
                    for i in 0..<cart_list.count{
                        if cart_list[i].id == product_details.variants[selected_variant].id{
                            self.productCount = Int(cart_list[i].count)!
                            self.lblItemsCount.text = cart_list[i].count
                            lblItemsCount.translateToarabic()
                        }
                    }
                }else{
                     lblCartCount.isHidden = true
                }
            }

        }
        
        if cart_list.count > 0{
            lblCartCount.isHidden = false
            lblCartCount.text = "\(self.cart_list.count)"
        }else{
             lblCartCount.isHidden = true
        }
        
        let trans = TranslatorManager()
        
        
        for i in 0..<product_details.variants.count{
//            if product_details.variants[i].discounted_price == "0"{
//                TranslatorManager.shared.translateText(text: "QAR \(product_details.variants[i].price)") { (str) in
//                    self.verients.append(str)
//                }
//
//            }else{
//                TranslatorManager.shared.translateText(text: "QAR \(product_details.variants[i].discounted_price)") { (str) in
//                    self.verients.append(str)
//                }
//            }
            
            if product_details.variants[i].discounted_price == "0"{
                trans.translateText(text: "QAR \(product_details.variants[i].price)") { (str) in
                    self.verients.append(str)
                }
                
            }else{
                trans.translateText(text: "QAR \(product_details.variants[i].discounted_price)") { (str) in
                    self.verients.append(str)
                }
            }
            
        }
    }
    
    func setData(){
        viewMoreVarients.isHidden = self.product_details.variants.count > 1 ? false : true
        if product_details.variants[selected_variant].discounted_price == "0"{
            self.lblPrice.text = "QAR \(product_details.variants[selected_variant].price).00"
            self.discount = ""
            self.lblMRP.text = ""
            self.lblDiscount.text = ""
        }else{
            self.lblMRP.text = "M.R.P.: QAR \(product_details.variants[selected_variant].price).00"
            let diff = Int(product_details.variants[selected_variant].price)! - Int(product_details.variants[selected_variant].discounted_price)!
            let dic = (100*diff)/Int(product_details.variants[selected_variant].price)!
            if Int(dic) > 0{
              self.lblDiscount.text = "You Save : QAR \(diff).00 (\(Int(dic))%)"
            }
            self.discount = "QAR \(product_details.variants[selected_variant].price) (\(Int(dic))%)"
            self.lblPrice.text = "QAR \(product_details.variants[selected_variant].discounted_price).00"
        }
        
        self.lblTittle.text = product_details.name
        self.textDetails.text = product_details.product_description.htmlToString
        self.textDetails.translateToarabic()
        self.lblPrice.translateToarabic()
        self.lblPic.text = "( \(product_details.variants[0].measurement) \(product_details.variants[0].measurement_unit_name) )"
        lblItemsCount.text = "\(productCount)"
        lblItemsCount.translateToarabic()
        
        for i in 0..<favarite_products.count{
            if favarite_products[i].id == product_details.id{
                imgFavarite.isHighlighted = true
            }
        }
        changeLang()
    }
    
    func setupSlideShow(){
        var slider = [AlamofireSource]()
        slider.append(AlamofireSource(urlString:product_details.image)!)
        for i in 0..<product_details.other_images.count{
            slider.append(AlamofireSource(urlString:product_details.other_images[i])!)
        }
        
        self.slider1 = slider
        slideShow.layer.cornerRadius = 12
        slideShow.clipsToBounds = true
        slideShow.inputView?.layer.cornerRadius = 12
        slideShow.slideshowInterval = 5.0
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = App_Color
        pageControl.pageIndicatorTintColor = UIColor.gray
        slideShow.pageIndicator = pageControl
        
        slideShow.activityIndicator = DefaultActivityIndicator()
        slideShow.delegate = self
        slideShow.setImageInputs(slider)
        
    }

    //MARK:- API Calling
    override func viewDidAppear(_ animated: Bool) {
        textDetailsHeight.constant = textDetails.contentSize.height
    }
    
    //MARK:- Btn Cliks
    
    @IBAction func actionAddProducts(_ sender: Any) {
        productCount += 1
        if Int(product_details.variants[selected_variant].stock)! >= productCount {
             lblItemsCount.text = "\(productCount)"
            lblItemsCount.translateToarabic()
        }else{
            AppHelper.shared.showToast(message: "No More Product In Stock", sender: self)
        }
       
    }
    
    @IBAction func actionSlider(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SliderVC") as! SliderVC
        vc.slider1 = self.slider1
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func actionRemoveProducts(_ sender: Any) {
        if productCount > 0{
            productCount -= 1
            lblItemsCount.text = "\(productCount)"
            lblItemsCount.translateToarabic()
        }
        
    }
    
    @IBAction func actionGoToCart(_ sender: Any) {
        if Int(lblItemsCount.text!)! > 0{
            var isAvalible = false
            var index = Int()
            var price = String()
            
            for i in 0..<cart_list.count{
                if cart_list[i].id == product_details.variants[selected_variant].id{
                    isAvalible = true
                    index = i
                }
            }
            if product_details.variants[selected_variant].discounted_price == "0"{
                price = product_details.variants[selected_variant].price
            }else{
                price = product_details.variants[selected_variant].discounted_price
            }
            
            if !isAvalible{
                cart_list.append(CartItem.init(id: product_details.variants[selected_variant].id, name: product_details.name, image: product_details.image, price:price, count: lblItemsCount.text!, mesurment: "( \(product_details.variants[0].measurement) \(product_details.variants[0].measurement_unit_name) )", discount: self.discount))
            }else{
                cart_list[index].id = product_details.variants[selected_variant].id
                cart_list[index].name = product_details.name
                cart_list[index].image = product_details.image
                cart_list[index].price = price
                cart_list[index].count = lblItemsCount.text!
                cart_list[index].mesurment = "( \(product_details.variants[0].measurement) \(product_details.variants[0].measurement_unit_name) )"
                cart_list[index].discount = self.discount
            }
            
            let placesData = NSKeyedArchiver.archivedData(withRootObject: self.cart_list)
            userdefault.set(placesData, forKey: KEY_CART)
            userdefault.synchronize()
            
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionCart(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionFavarite(_ sender: Any) {
        imgFavarite.isHighlighted = imgFavarite.isHighlighted == true ? false : true
        var index = Int()
        var isStore = Bool()
        for i in 0..<favarite_products.count{
            if favarite_products[i].id == product_details.id{
                index = i
                isStore = true
            }
        }
        
        if !isStore{
            favarite_products.append(FavariteProducts.init(id: product_details.id, name: product_details.name, product_description: product_details.product_description, row_order: product_details.row_order, other_images: product_details.other_images, image: product_details.image, indicator: product_details.indicator, slug: product_details.slug, variants: product_details.variants, price: product_details.price, subcategory_id: product_details.subcategory_id, status: product_details.status, date_added: product_details.date_added, category_id: product_details.category_id, product_count: lblItemsCount.text!))
        }else{
            favarite_products.remove(at: index)
        }
        
        let placesData = NSKeyedArchiver.archivedData(withRootObject: self.favarite_products)
        userdefault.set(placesData, forKey: KEY_FAVARITE)
        userdefault.synchronize()
    }
    
    @IBAction func actionShare(_ sender: UIButton) {
        let title = "\n \n Check out this app \n"
        let productName = "\(product_details.name)\n"
        let productDetails = "\(product_details.product_description)\n"
        let productImage = "\(product_details.image)"
        if let objectsToShare = URL.init(string: APP_URL){
            let activityVC = UIActivityViewController(activityItems:[productName,productImage,title,objectsToShare], applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            
            if let presenter = activityVC.popoverPresentationController {
                presenter.sourceView = sender
                presenter.sourceRect = sender.bounds
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionSimilarProducts(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SimilarProductVC") as! SimilarProductVC
        vc.productName = self.product_details.name
        vc.product_id = self.product_details.subcategory_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionMoreVerients(_ sender: UIButton) {
        
        
        KTOptionMenu(sender: sender, options:verients, action: { index in
            self.productCount = 0
            self.selected_variant = index
            self.setData()
        })
    }
    
    
}
extension ProductDetailsVC: ImageSlideshowDelegate {
  func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//    print("current page:", page)
  }
}
