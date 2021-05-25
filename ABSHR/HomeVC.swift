//
//  HomeVC.swift
//  ABSHR
//
//  Created by mac on 07/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import ImageSlideshow
import AlamofireImage
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage
import SVPullToRefresh
class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var cvStoreList: UICollectionView!
    
    @IBOutlet weak var blTitle: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblFav: UILabel!
    @IBOutlet weak var lblAcount: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    
//    @IBOutlet weak var btnHuman: UIButton!
//    @IBOutlet weak var btnAnimal: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var lblCartCount: UILabel!
    
    // Drawer
     @IBOutlet weak var viewNavigationDrawer: UIView!
     @IBOutlet weak var navigationView: UIView!
     @IBOutlet weak var navigationViewLeading: NSLayoutConstraint!
     
     @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
     @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    
    
    @IBOutlet weak var svStoreListHeight: NSLayoutConstraint!
    
    var cateID: Int?
    var type = Int()
    var selectedIndex = Int()
    var isHuman = Bool()
    var slider_images = JSON.null
    var product_data = JSON.null
    var product_list = [Products]()
    var cart_list = [CartItem]()
    var offset = Int()
    var user = User()
    var navigationDrawerOpen = Bool()
    var header = ["","","","",""]
    var titleList = [["Home","Cart","Notifications"],["Appointments","Track Order","Profile","Change Password","Change Language"],["Contact Us","About Us","Rate Us","Share App"],["FAQ","Terms & Conditions","Privacy Policy"],["LogOut"]]
    
    var iconList = [["icon_home","icon_cart","icon_notification"],["icon_calendar","icon_truck","profile1","icon_lock","icon_language"],["icon_contact","icon_info","icon_star","icon_share"],["ic_faq","icon_terms-and-conditions","icon_security"],["logout"]]
    
    var homeStoreList = [StoreData]()
    var selectedStoreInd : Int = 0
    var SubCatID: Int = 0
    var selectCatName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        if getCurrentLang() == "ar-SA" {
            
            tableView.semanticContentAttribute = .forceLeftToRight
        }else {
            tableView.semanticContentAttribute = .forceLeftToRight
        }
        
        homeStoreList.append(StoreData(fromDictionary: [:]))
        cvStoreList.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.init(rawValue: "refresh"), object: nil)
        
//        self.getSetting()
//        self.getSection()
    }
    
    @objc func refresh(){
        self.user = User()
        self.cart_list.removeAll()
        let placesData = UserDefaults.standard.object(forKey: KEY_CART) as? NSData
        
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [CartItem]
            if let placesArray = placesArray {
                self.cart_list = placesArray
            }
        }
        
        if cart_list.count > 0{
            lblCartCount.isHidden = false
            lblCartCount.text = "\(self.cart_list.count)"
        }else{
             lblCartCount.isHidden = true
        }
    }
    
    func initView(){
        
        self.navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.async {
            if !UIDevice.current.hasNotch{
                self.viewHeaderHeight.constant = 128
            }
        }
        searchBar.backgroundImage = UIImage()
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = UIColor.white
        } else {
            
        }
        
        collectionView.register(UINib.init(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "DrowerCell", bundle: nil), forCellReuseIdentifier: "cell")
        getSliderImages()
        getCategory(index: type, offset: 0)
//        getCategory(index: selectedIndex, offset: 0)
//        if isHuman{
//            btnHuman.isSelected = true
//            btnAnimal.isSelected = false
//        }else{
//            btnHuman.isSelected = false
//            btnAnimal.isSelected = true
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        
        let placesData = UserDefaults.standard.object(forKey: KEY_CART) as? NSData
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [CartItem]
            if let placesArray = placesArray {
                self.cart_list = placesArray
                
            }
        }
//        if type == 48{
//            btnHuman.isHidden = true
//        }
        
        let placesData1 = UserDefaults.standard.object(forKey: KEY_USER) as? NSData
        if let placesData = placesData1 {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? User
            if let placesArray = placesArray {
                self.user = placesArray
            }
        }
        
        if self.user.user_id.count > 0{
            self.lblName.text = self.user.name
            self.lblMobileNo.text = self.user.mobile
        }else{
            lblName.text = "Guest User"
            self.lblMobileNo.text = ""
        }
        
        if cart_list.count > 0{
            lblCartCount.isHidden = false
            lblCartCount.text = "\(self.cart_list.count)"
        }else{
             lblCartCount.isHidden = true
        }
        
        navigationView.alpha = 0.0
        viewNavigationDrawer.alpha = 0.0
        self.navigationViewLeading.constant = 0 - view.frame.width
        self.navigationDrawerOpen = false
        searchBar.placeholder = searchBar.placeholder?.localized()
        [lblHome,lblCat,lblFav,lblAcount,blTitle].forEach{
                   $0?.setLocalize()
               }
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionViewHeight.constant = collectionView.contentSize.height + 60
        tableView.reloadData()
        tableViewHeightConstant.constant = tableView.contentSize.height
        collectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            self.getCategory(index: self.type, offset: self.offset)
        })
    }
    
    func setupSlideShow(){
        var slider = [AlamofireSource]()
        for i in 0..<slider_images.count{
            slider.append(AlamofireSource(urlString:slider_images[i]["image"].stringValue)!)
        }
        slideShow.layer.cornerRadius = 12
        slideShow.clipsToBounds = true
        slideShow.inputView?.layer.cornerRadius = 12
        slideShow.slideshowInterval = 5.0
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = App_Color
        pageControl.pageIndicatorTintColor = UIColor.gray
        slideShow.pageIndicator = pageControl
        
        slideShow.activityIndicator = DefaultActivityIndicator()
        slideShow.delegate = self
        slideShow.setImageInputs(slider)
        
    }
    
    func rateUs(){
      guard let url = URL(string: "itms-apps://itunes.apple.com/app/" + "\(APP_ID)") else {
        return
      }
      if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
      } else {
        UIApplication.shared.openURL(url)
      }
    }
    
    func openURL(type:Int,title:String){
//      guard let url = URL(string: url)else { return }
//           if #available(iOS 10.0, *) {
//             UIApplication.shared.open(url)
//           }
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
//        vc.fileURL = url
        vc.titleName = title
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Api Calling
    
    func getSliderImages(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"get-slider-images":1]
        print(dictRequest)
        
        AF.request(SLIDER_IMAGES, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    self.slider_images = dict["data"]
                    self.setupSlideShow()
                }else{
                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                }
                print(dict)
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
    
    func getSection(){
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336]
        print(dictRequest)
        
        AF.request(SECTIONS, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
//                    self.slider_images = dict["data"]
//                    self.setupSlideShow()
                }else{
                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                }
                print(dict)
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
    
    func getSetting(){
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336]
        print(dictRequest)
        
        AF.request(SETTINGS, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
//                    self.slider_images = dict["data"]
//                    self.setupSlideShow()
                }else{
                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                }
                print(dict)
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
    
    func getCategory(index:Int,offset:Int){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        var dictRequest : [String:Int] = [:]
        dictRequest["accesskey"] = 90336
        
        if type != 0 {
            dictRequest["store_id"] = index
        }else {
            if cateID == 48 {
                svStoreListHeight.constant = 0
            }else {
                svStoreListHeight.constant = 120
            }
            dictRequest["category_id"] = cateID
        }
        
//        if cateID != nil {
//            if cateID == 48 {
//                svStoreListHeight.constant = 0
//            }else {
//                svStoreListHeight.constant = 120
//            }
//
//            dictRequest["category_id"] = cateID
//        }else {
//            dictRequest["store_id"] = index
//        }
        
        dictRequest["limit"] = 10
        dictRequest["offset"] = offset
        
//                           "store_id" : index,
////                           "subcategory_id":index,
//                           "limit":10,
//                           "offset":offset]
        
    
        var productAPI : String = ""
        if type != 0 {
            productAPI = GET_PRODUCTBY_STOREID
        }else {
            productAPI = GET_PRODUCTSBY_CATEGORY
        }
        
        print("fef")
        AF.request(productAPI, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
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
                        
                        self.product_list.append(Products.init(id: self.product_data[i]["id"].stringValue, name: self.product_data[i]["name"].stringValue, product_description: self.product_data[i]["description"].stringValue, row_order: self.product_data[i]["row_order"].stringValue, other_images: images, image: self.product_data[i]["image"].stringValue, indicator: self.product_data[i]["indicator"].stringValue, slug: self.product_data[i]["slug"].stringValue, variants: varitents, price: self.product_data[i]["price"].stringValue, subcategory_id: self.product_data[i]["subcategory_id"].stringValue, status: self.product_data[i]["status"].stringValue, date_added: self.product_data[i]["date_added"].stringValue, category_id: self.product_data[i]["category_id"].stringValue))
                    }
                    print(self.product_list.count)
                    self.offset = self.offset + 10
                        if self.product_list.count == self.offset{
                            self.getCategory(index: self.type, offset: self.offset)
//                            self.collectionView.reloadData()
                        }else{
                            self.collectionView.reloadData()
                            self.collectionViewHeight.constant = self.collectionView.contentSize.height + 60
                        }
                    }else{
                        self.collectionView.reloadData()
                        self.collectionViewHeight.constant = self.collectionView.contentSize.height + 60
                    }
                }else{
                    if dict["message"].stringValue.count > 0{
                        AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                    }else{
                        AppHelper.shared.showToast(message: dict["data"].stringValue, sender: self)
                        self.collectionView.reloadData()
                        self.collectionViewHeight.constant = self.collectionView.contentSize.height + 60
                    }
                    
                }
                print(dict)
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
    
//MARK:- Btn Cliks
    
//    @IBAction func actionHuman(_ sender: UIButton) {
//        if !self.btnHuman.isSelected{
//            self.product_list.removeAll()
//            btnHuman.isSelected = true
//            btnAnimal.isSelected = false
//            offset = 0
//            if type == 47{
//                selectedIndex = 1
//            }else{
//                selectedIndex = 3
//            }
//            self.product_list.removeAll()
//            SVProgressHUD.show()
//            self.getCategory(index: type, offset: offset)
//        }
//    }
//
//    @IBAction func actionAnimal(_ sender: Any) {
//        if !self.btnAnimal.isSelected{
//            offset = 0
//            btnHuman.isSelected = false
//            btnAnimal.isSelected = true
//            self.product_list.removeAll()
//            if type == 47{
//                selectedIndex = 2
//            }else{
//                selectedIndex = 4
//            }
//            self.product_list.removeAll()
//            SVProgressHUD.show()
//            self.getCategory(index: type, offset: offset)
//        }
//    }
    
    
    @IBAction func actionCart(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        self.DrawerOpen()
    }
    
    @IBAction func actionTap(_ sender: Any) {
      self.DrawerClose()
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionCatagory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectCategoryVC") as! SelectCategoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionFavarite(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavariteVC") as! FavariteVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAcount(_ sender: Any) {
        if !userdefault.bool(forKey: KEY_ISLOGIN){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav1 = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = nav1
            appDelegate.window?.makeKeyAndVisible()
        }else{
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    //MARK:- Drawer Methods
    
    func DrawerOpen(){
      if !self.navigationDrawerOpen{
        self.navigationDrawerOpen = true
        self.navigationViewLeading.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.navigationView.alpha = 1.0
                        self.viewNavigationDrawer.alpha = 1.0
                        self.view.layoutIfNeeded()
        }, completion: nil)
      }
      
    }
    
    func DrawerClose(){
      self.navigationDrawerOpen = false
      self.navigationViewLeading.constant = 0 - view.frame.width
      
      UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
                     animations: {
                      self.navigationView.alpha = 0.0
                      self.viewNavigationDrawer.alpha = 0.0
                      self.view.layoutIfNeeded()
      }, completion: nil)
    }

    //MARK:- Tableview Methods
  
    func numberOfSections(in tableView: UITableView) -> Int {
        if user.user_id.count > 0{
             return header.count
         }else{
             return header.count-1
         }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return titleList[section].count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DrowerCell
      cell.imgIcon.image = UIImage(named: iconList[indexPath.section][indexPath.row])
      cell.lblTitle.text = titleList[indexPath.section][indexPath.row]
        cell.imgIcon2.image = UIImage(named: iconList[indexPath.section][indexPath.row])
        if getCurrentLang() == "ar-SA"{
            cell.imgIcon2.isHidden = false
        }else{
            cell.imgIcon2.isHidden = true
        }
        cell.lblTitle.setLocalize()
//        cell.lblTitle.translateToarabic()
        cell.imgIcon.isHidden = !cell.imgIcon2.isHidden
      return cell
     }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            if userdefault.bool(forKey: KEY_SOCIAL){
                if indexPath.row == 3{
                    return 0
                }else{
                    return 44
                }
            }else{
               return 44
            }
            
        }else{
            return 44
        }
      
    }
     
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 5))
        view.backgroundColor = UIColor.white
        let img = UIImageView(frame: CGRect(x: 0, y: 2.2, width: self.tableView.frame.width, height: 0.5))
        img.backgroundColor = UIColor.lightGray
        if section != 0{
           view.addSubview(img)
        }
        return view
    }
     
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if user.user_id.count > 0{
            return 5
        }else{
            return 4
        }
       
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if indexPath.section == 0{
        if indexPath.row == 0{
            self.DrawerClose()
        }else if indexPath.row == 1{
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
          
        }
      }else if indexPath.section == 1{
        if indexPath.row == 0{
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentsVC") as! AppointmentsVC
        self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
//          let vc  = self.storyboard?.instantiateViewController(withIdentifier: "TreackOrderVC") as! TreackOrderVC
//          self.navigationController?.pushViewController(vc, animated: true)
            if user.user_id.count > 0{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentVC") as! ContentVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }else if indexPath.row == 2{
            if user.user_id.count > 0{
                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.row == 3{
            if user.user_id.count > 0{
                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
          
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
            vc.isFromHome = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
      }else if indexPath.section == 2{
        if indexPath.row == 0{
            self.openURL(type:5, title: "Contact Us")
        }else if indexPath.row == 1{
            self.openURL(type:4, title:"About Us")
        }else if indexPath.row == 2{
            self.rateUs()
        }else{
            let title = "ABSHR \n \n Check out this app \n"
            if let objectsToShare = URL.init(string: APP_URL){
                let activityVC = UIActivityViewController(activityItems:[title,objectsToShare], applicationActivities: nil)
                
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                
                if let presenter = activityVC.popoverPresentationController {
                    presenter.sourceView = btnMenu
                    presenter.sourceRect = btnMenu.bounds
                }
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        
      }else if indexPath.section == 3{
        if indexPath.row == 0{
            self.openURL(type:3, title: "FAQ")
        }else if indexPath.row == 1{
            self.openURL(type:2, title: "Terms & Conditions")
        }else if indexPath.row == 2{
            self.openURL(type:1, title:"Privacy Policy")
        }else{
           
        }
      }else if indexPath.section == 4{
        if user.user_id.count > 0{
            if indexPath.row == 0{
                let alert = UIAlertController(title: "Logout", message: "Are you sure,you want to Logout Your Account?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    let nav1 = UINavigationController(rootViewController: vc)
                    appDelegate.window?.rootViewController = nav1
                    appDelegate.window?.makeKeyAndVisible()
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                self.present(alert, animated: true)
            }
        }else{
            let alert = UIAlertController(title: "Login!", message: "Please Login....", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            }))
//            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
        
      }
    }
    
    
    //MARK:- Collectionview Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == cvStoreList {
            return self.homeStoreList.count
        }
        return self.product_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvStoreList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvcStoreList", for: indexPath) as! cvcStoreList
            
            if homeStoreList.count > 0 {
                if indexPath.row == homeStoreList.count - 1 {
                    cell.btnCatName.backgroundColor = #colorLiteral(red: 0.7016962171, green: 0.1650985777, blue: 0.2509245276, alpha: 1)
                    cell.btnCatName.layer.borderWidth = 1
                    cell.btnCatName.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    cell.btnCatName.clipsToBounds = true
                    cell.btnCatName.setTitle("View All", for: .normal)
                    cell.btnCatName.translateToarabic()
                    cell.lblCatName.isHidden = true
                    cell.lblCatName.translateToarabic()
                    cell.ivSlider.isHidden = true
                    cell.btnCatName.isHidden = false
                    return cell
                }else {
                    cell.lblCatName.isHidden = false
                    cell.ivSlider.isHidden = false
                    cell.btnCatName.isHidden = true
                    cell.lblCatName.text = homeStoreList[indexPath.row].name
                    cell.lblCatName.translateToarabic()
                    cell.ivSlider.sd_setImage(with: URL(string: homeStoreList[indexPath.row].image), completed: nil)
                }
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell
        cell.viewContent.frame.size.width = (collectionView.frame.size.width-12)/2
        cell.viewContent.frame.size.height = (collectionView.frame.size.width-12)/2
        cell.imgProduct.sd_setImage(with: URL.init(string: self.product_list[indexPath.row].image), placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached], context: nil)
        cell.lblProductTitle.text = self.product_list[indexPath.row].name
        
        cell.lblProductDescription.text = self.product_list[indexPath.row].product_description.htmlToString
        if self.product_list[indexPath.row].variants[0].discounted_price == "0"{
            cell.lblProductPrice.text = "Price: QAR \(self.product_list[indexPath.row].variants[0].price).00"
        }else{
            cell.lblProductPrice.text = "Price: QAR \(self.product_list[indexPath.row].variants[0].discounted_price).00"
        }
        [cell.lblProductDescription,cell.lblProductPrice,cell.lblProductTitle].forEach{
            $0?.translateToarabic()
        }
        collectionViewHeight.constant = collectionView.contentSize.height + 60
        cell.shadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == cvStoreList {
            return CGSize(width: 100.0, height: 128.0)
        }
        
        return CGSize.init(width: (collectionView.frame.size.width-12)/2, height: (collectionView.frame.size.width-12)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == cvStoreList {
            
            print("click on cat")
            
            if indexPath.row == homeStoreList.count - 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
                vc.categoryId = cateID ?? 0
                vc.navTitle = selectCatName
                
                if SubCatID != 0 {
                    vc.subCatId = SubCatID
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                print("click on cat")
                product_list.removeAll()
                getCategory(index: Int(homeStoreList[indexPath.row].id) ?? 0, offset: 0)
                self.collectionView.reloadData()
            }
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopFarmSubCategoryVC") as! ShopFarmSubCategoryVC
//            vc.categoryId =
//            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            vc.product_details = self.product_list[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- ScrollView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }

}
extension HomeVC: ImageSlideshowDelegate {
  func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
  }
}

