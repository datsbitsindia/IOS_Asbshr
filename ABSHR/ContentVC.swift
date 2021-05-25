//
//  ContentVC.swift
//  ABSHR
//
//  Created by mac on 21/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Photos
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD

class ContentVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
    @IBOutlet weak var btnBackGo: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
//    var listData = JSON.null
    var listData1 = JSON.null
    var user = User()
    var selectedIndex = Int()
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
//        lblTitle.setLocalize()
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh(notification:)), name: Notification.Name("load"), object: nil)
    }
  
    @objc func refresh(notification: Notification) {
        initView()
    }
    
  func initView(){
    DispatchQueue.main.async {
        if !UIDevice.current.hasNotch{
            self.viewHeaderHeight.constant = 66
        }
    }
    let placesData1 = UserDefaults.standard.object(forKey: KEY_USER) as? NSData
    if let placesData = placesData1 {
        let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? User
        if let placesArray = placesArray {
            self.user = placesArray
            self.getOrderList()
        }
        
    }
//    collectionView.register(UINib.init(nibName: "TrackOrderCell", bundle: nil), forCellWithReuseIdentifier: "cell")
  }
  
  func checkData(){
    if listData.count == 0{
        collectionView.isHidden = true
    }else{
        collectionView.isHidden = false
    }
  }
    
    func getOrderList(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"get_orders":"1","user_id":self.user.user_id] as [String : Any]
        print(dictRequest)
        
        AF.request(ORDER_PROCESS, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    listData = dict["data"]
                    self.listData1 = dict["data"]
                    self.collectionView.reloadData()
                    
                }else{
                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                }
                self.checkData()
                print(dict)
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
                self.checkData()
            }
        }
    }
    
    @objc func actionDetails(_ sender:UIButton){
        let index = sender.tag
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.orederList = listData[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }

  //MARK:- CollectionView Methods

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return listData.count
  }
//    {
//      "discount_rupees" : "0",
//      "tax_amount" : "26",
//      "date_added" : "02-11-2020 08:12:09pm",
//      "promo_code" : "-",
//      "active_status" : "received",
//      "id" : "38",
//      "longitude" : "0",
//      "payment_method" : "cod",
//      "total" : "260",
//      "delivery_time" : " - ",
//      "user_id" : "34",
//      "mobile" : "9876598765",
//      "wallet_balance" : "0",
//      "promo_discount" : "0",
//      "address" : "Airport, , , 395010, Deliver to ",
//      "discount" : "0",
//      "delivery_boy_id" : "0",
//      "tax_percentage" : "10",
//      "latitude" : "0",
//      "delivery_charge" : "30",
//      "itemsitems" : [
//        {
//          "discounted_price" : "0",
//          "id" : "52",
//          "order_id" : "38",
//          "image" : "https:\/\/yourpanelapp.com\/upload\/images\/9685-2020-06-06.jpg",
//          "measurement" : "1",
//          "quantity" : "4",
//          "status" : [
//            [
//              "received",
//              "02-11-2020 08:12:09pm"
//            ]
//          ],
//          "active_status" : "received",
//          "product_variant_id" : "195",
//          "user_id" : "34",
//          "discount" : "0",
//          "date_added" : "2020-11-02 20:12:09",
//          "deliver_by" : null,
//          "price" : "45",
//          "name" : "Hakka Noodles - Full & Half",
//          "sub_total" : "180",
//          "unit" : "pc"
//        },
//        {
//          "discounted_price" : "0",
//          "id" : "53",
//          "order_id" : "38",
//          "image" : "https:\/\/yourpanelapp.com\/upload\/images\/4508-2020-06-06.jpg",
//          "measurement" : "1",
//          "quantity" : "1",
//          "status" : [
//            [
//              "received",
//              "02-11-2020 08:12:09pm"
//            ]
//          ],
//          "active_status" : "received",
//          "product_variant_id" : "196",
//          "user_id" : "34",
//          "discount" : "0",
//          "date_added" : "2020-11-02 20:12:09",
//          "deliver_by" : null,
//          "price" : "80",
//          "name" : "Veg Manchurian",
//          "sub_total" : "80",
//          "unit" : "pc"
//        }
//      ],
//      "status" : [
//        [
//          "received",
//          "02-11-2020 08:12:09pm"
//        ]
//      ],
//      "final_total" : "316",
//      "user_name" : "ss"
//    },
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for:indexPath) as! TrackOrderCell
    cell.viewContent.frame.size.width = (collectionView.frame.size.width-16)
    if listData[indexPath.row]["items"].count == 0{
        if listData[indexPath.row]["active_status"].stringValue == "cancelled"{
            cell.viewContent.frame.size.height = 50
        }else{
            cell.viewContent.frame.size.height = 120
        }
         
    }else{
        if listData[indexPath.row]["active_status"].stringValue == "cancelled"{
            let height = 150*listData[indexPath.row]["items"].count
            cell.viewContent.frame.size.height = CGFloat(height+50+16)
        }else{
            let height = 150*listData[indexPath.row]["items"].count
            cell.viewContent.frame.size.height = CGFloat(height+120+16)
        }
        
    }
    cell.lblOrderId.text = listData[indexPath.row]["id"].stringValue
    cell.lblDate.text = listData[indexPath.row]["date_added"].stringValue
    cell.lblOrderId.text = listData[indexPath.row]["id"].stringValue
    cell.tableView.tag = indexPath.row
    cell.tableView.reloadData()
    if listData[indexPath.row]["active_status"].stringValue == "received"{
        cell.btnOrderPlaced.isEnabled = true
        cell.btnOrderShipped.isEnabled = false
        cell.btnOrderDelivered.isEnabled = false
        cell.btnOrderProcessed.isEnabled = false
        cell.lblOrderPlaced.text = listData[indexPath.row]["status"][0][1].stringValue
    }else if listData[indexPath.row]["active_status"].stringValue == "processed"{
        cell.btnOrderPlaced.isEnabled = true
        cell.btnOrderShipped.isEnabled = false
        cell.btnOrderDelivered.isEnabled = false
        cell.btnOrderProcessed.isEnabled = true
        cell.lblOrderPlaced.text = listData[indexPath.row]["status"][0][1].stringValue
        cell.lblOrderProcessed.text = listData[indexPath.row]["status"][1][1].stringValue
    }else if listData[indexPath.row]["active_status"].stringValue == "shipped"{
        cell.btnOrderPlaced.isEnabled = true
        cell.btnOrderShipped.isEnabled = true
        cell.btnOrderDelivered.isEnabled = false
        cell.btnOrderProcessed.isEnabled = true
        cell.lblOrderPlaced.text = listData[indexPath.row]["status"][0][1].stringValue
        cell.lblOrderProcessed.text = listData[indexPath.row]["status"][1][1].stringValue
        cell.lblOrderShipped.text = listData[indexPath.row]["status"][2][1].stringValue
    }else if listData[indexPath.row]["active_status"].stringValue == "delivered"{
        cell.btnOrderPlaced.isEnabled = true
        cell.btnOrderShipped.isEnabled = true
        cell.btnOrderDelivered.isEnabled = true
        cell.btnOrderProcessed.isEnabled = true
        cell.lblOrderPlaced.text = listData[indexPath.row]["status"][0][1].stringValue
        cell.lblOrderProcessed.text = listData[indexPath.row]["status"][1][1].stringValue
        cell.lblOrderShipped.text = listData[indexPath.row]["status"][2][1].stringValue
        cell.lblOrderDelivered.text = listData[indexPath.row]["status"][3][1].stringValue
    }else{
        cell.btnOrderPlaced.isEnabled = true
        cell.btnOrderShipped.isEnabled = false
        cell.btnOrderDelivered.isEnabled = false
        cell.btnOrderProcessed.isEnabled = false
        cell.lblOrderPlaced.text = listData[indexPath.row]["status"][0][1].stringValue
        
    }
    if listData[indexPath.row]["status"].count > 0{
        cell.lblOrderPlaced.text = listData[indexPath.row]["status"][0][1].stringValue
    }
    
    if listData[indexPath.row]["status"].count > 1{
        cell.lblOrderPlaced.text = listData[indexPath.row]["status"][0][1].stringValue
        cell.lblOrderProcessed.text = listData[indexPath.row]["status"][1][1].stringValue
    }
    
    if listData[indexPath.row]["status"].count > 2{
        cell.lblOrderPlaced.text = listData[indexPath.row]["status"][0][1].stringValue
        cell.lblOrderProcessed.text = listData[indexPath.row]["status"][1][1].stringValue
        cell.lblOrderShipped.text = listData[indexPath.row]["status"][2][1].stringValue
    }
    
    if listData[indexPath.row]["status"].count > 3{
        cell.lblOrderPlaced.text = listData[indexPath.row]["status"][0][1].stringValue
        cell.lblOrderProcessed.text = listData[indexPath.row]["status"][1][1].stringValue
        cell.lblOrderShipped.text = listData[indexPath.row]["status"][2][1].stringValue
        cell.lblOrderDelivered.text = listData[indexPath.row]["status"][3][1].stringValue
        
    }
    
    if listData[indexPath.row]["items"].count == 0{
        cell.tableViewHeight.constant = 0
    }else{
        cell.tableViewHeight.constant = CGFloat(150*listData[indexPath.row]["items"].count + 16)
    }
    
    if listData[indexPath.row]["active_status"].stringValue == "cancelled"{
        cell.viewStatus.isHidden = true
        cell.viewStatusHeight.constant = 0
    }else{
        cell.viewStatus.isHidden = false
        cell.viewStatusHeight.constant = 70
    }
    
    cell.btnViewDetails.tag = indexPath.row
    cell.btnViewDetails.addTarget(self, action: #selector(actionDetails(_:)), for: .touchUpInside)
    cell.shadow()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if listData[indexPath.row]["items"].count == 0{
        if listData[indexPath.row]["active_status"].stringValue == "cancelled"{
            return CGSize.init(width: (collectionView.frame.size.width-16), height:50)
        }else{
            return CGSize.init(width: (collectionView.frame.size.width-16), height:120)
        }
         
    }else{
        if listData[indexPath.row]["active_status"].stringValue == "cancelled"{
            let height = 150*listData[indexPath.row]["items"].count
            return CGSize.init(width: (Int(collectionView.frame.size.width)-16), height: height+50+16)
        }else{
           let height = 150*listData[indexPath.row]["items"].count
            return CGSize.init(width: (Int(collectionView.frame.size.width)-16), height: height+120+16)
        }
//        let height = 150*listData[indexPath.row]["items"].count
//        return CGSize.init(width: (Int(collectionView.frame.size.width)-16), height: height+120+16)
    }
   
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
  }
    
    //MARK:- Btn Cliks
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actionSorting(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "All", style: .default , handler:{ (UIAlertAction)in
//            listData = self.listData1
//            self.collectionView.reloadData()
//            self.checkData()
            self.sortList(type: "received")
        }))
        
        alert.addAction(UIAlertAction(title: "In-Process", style: .default , handler:{ (UIAlertAction)in
            self.sortList(type: "processed")
        }))

        alert.addAction(UIAlertAction(title: "Shipped", style: .default , handler:{ (UIAlertAction)in
            self.sortList(type: "shipped")
        }))
        
        alert.addAction(UIAlertAction(title: "Delivered", style: .default , handler:{ (UIAlertAction)in
            self.sortList(type: "delivered")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            
        }))

        if let presenter = alert.popoverPresentationController{
          presenter.sourceView = sender
          presenter.sourceRect = sender.bounds
        }
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    
    func sortList(type:String){
        var list = JSON.null
        var l = [[String:Any]]()
        for i in 0...listData1.count{
            if listData1[i]["status"][0][0].stringValue == type{
                l.append(listData1[i].dictionary!)
            }
        }
        list = JSON(l)
        listData = list
        collectionView.reloadData()
        self.checkData()
    }
 
}

