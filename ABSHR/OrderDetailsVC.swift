//
//  OrderDetailsVC.swift
//  ABSHR
//
//  Created by mac on 03/11/20.
//  Copyright © . All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire
import SwiftyJSON

class OrderDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnOrderPlaced: UIButton!
    @IBOutlet weak var btnOrderProcessed: UIButton!
    @IBOutlet weak var btnOrderShipped: UIButton!
    @IBOutlet weak var btnOrderDelivered: UIButton!
    
    @IBOutlet weak var lblOrderPlaced: UILabel!
    @IBOutlet weak var lblOrderProcessed: UILabel!
    @IBOutlet weak var lblOrderShipped: UILabel!
    @IBOutlet weak var lblOrderDelivered: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDis: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPromocode: UILabel!
    @IBOutlet weak var lblWallerBalance: UILabel!
    @IBOutlet weak var lblFinalTotal: UILabel!
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnCancelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
    var orederList = JSON.null
    var isCancel = Bool()
    
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
        lblOrderId.text = orederList["id"].stringValue
        lblDate.text = orederList["date_added"].stringValue
        
        if orederList["active_status"].stringValue == "received"{
            btnOrderPlaced.isEnabled = true
            btnOrderShipped.isEnabled = false
            btnOrderDelivered.isEnabled = false
            btnOrderProcessed.isEnabled = false
            lblOrderPlaced.text = orederList["status"][0][1].stringValue
        }else if orederList["active_status"].stringValue == "processed"{
            btnOrderPlaced.isEnabled = true
            btnOrderShipped.isEnabled = false
            btnOrderDelivered.isEnabled = false
            btnOrderProcessed.isEnabled = true
            lblOrderPlaced.text = orederList["status"][0][1].stringValue
            lblOrderProcessed.text = orederList["status"][1][1].stringValue
        }else if orederList["active_status"].stringValue == "shipped"{
            btnOrderPlaced.isEnabled = true
            btnOrderShipped.isEnabled = true
            btnOrderDelivered.isEnabled = false
            btnOrderProcessed.isEnabled = true
            lblOrderPlaced.text = orederList["status"][0][1].stringValue
            lblOrderProcessed.text = orederList["status"][1][1].stringValue
            lblOrderShipped.text = orederList["status"][2][1].stringValue
        }else if orederList["active_status"].stringValue == "delivered"{
            btnOrderPlaced.isEnabled = true
            btnOrderShipped.isEnabled = true
            btnOrderDelivered.isEnabled = true
            btnOrderProcessed.isEnabled = true
            lblOrderPlaced.text = orederList["status"][0][1].stringValue
            lblOrderProcessed.text = orederList["status"][1][1].stringValue
            lblOrderShipped.text = orederList["status"][2][1].stringValue
            lblOrderDelivered.text = orederList["status"][3][1].stringValue
        }else{
            btnOrderPlaced.isEnabled = true
            btnOrderShipped.isEnabled = true
            btnOrderDelivered.isEnabled = true
            btnOrderProcessed.isEnabled = true
            
        }
        if orederList["status"].count > 0{
            lblOrderPlaced.text = orederList["status"][0][1].stringValue
        }
        
        if orederList["status"].count > 1{
            lblOrderPlaced.text = orederList["status"][0][1].stringValue
            lblOrderProcessed.text = orederList["status"][1][1].stringValue
        }
        
        if orederList["status"].count > 2{
            lblOrderPlaced.text = orederList["status"][0][1].stringValue
            lblOrderProcessed.text = orederList["status"][1][1].stringValue
            lblOrderShipped.text = orederList["status"][2][1].stringValue
        }
        
        if orederList["status"].count > 3{
            lblOrderPlaced.text = orederList["status"][0][1].stringValue
            lblOrderProcessed.text = orederList["status"][1][1].stringValue
            lblOrderShipped.text = orederList["status"][2][1].stringValue
            lblOrderDelivered.text = orederList["status"][3][1].stringValue
        }
        
        lblName.text = "Name : \(orederList["user_name"].stringValue)"
        lblAddress.text = "Address : \(orederList["address"].stringValue)"
        lblMobile.text = "Mobile : \(orederList["mobile"].stringValue)"
       
        lblAmount.text = "QAR \(orederList["total"].stringValue)"
        lblDeliveryCharge.text = "+ QAR \(orederList["delivery_charge"].stringValue)"
        lblTax.text = "+ QAR \(orederList["tax_amount"].stringValue)"
        lblDis.text = "Discount(\(orederList["discount"].stringValue)%) :"
        lblDiscount.text = "- QAR \(orederList["discount_rupees"].stringValue)"
        lblTotal.text = "QAR \(orederList["total"].stringValue)"
        lblPromocode.text = "- QAR \(orederList["promo_discount"].doubleValue)"
        lblWallerBalance.text = "- QAR \(orederList["wallet_balance"].doubleValue)"
        lblFinalTotal.text = "QAR \(orederList["final_total"].doubleValue)"
        
        print(orederList)
        tableViewHeight.constant = CGFloat(150*orederList["items"].count)
        
        if orederList["active_status"].stringValue == "cancelled"{
            btnCancel.isHidden = true
            self.viewStatusHeight.constant = 0
            self.btnCancelHeight.constant = 0
        }else{
            btnCancel.isHidden = false
            self.viewStatusHeight.constant = 100
            self.btnCancelHeight.constant = 50
        }
        
    }
    
    func cancelOrder(itemId:String,orderId:String,index:Int){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        
        var dictRequest = [String:Any]()
        if isCancel{
            dictRequest = ["accesskey":90336,"update_order_status":1,"id":orderId,"status":"cancelled"] as [String : Any]
        }else{
            dictRequest = ["accesskey":90336,"update_order_item_status":"1","order_item_id":itemId,"order_id":orderId,"status":"cancelled"] as [String : Any]
        }
        print(dictRequest)
        
        AF.request(ORDER_PROCESS, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    if self.isCancel{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        let cell = self.tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! TrackOrderTCV
                        self.orederList["items"][index]["active_status"] = "Cancelled"
                        cell.lblStatus.text = "Cancelled"
                        cell.btnCancel.isHidden = true
                        cell.lblStatus.textColor = App_Color
                    }
                    NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
                    
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
    
    //MARK:- Btn Cliks
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCancelOrder(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel!", message: "Are you sure to cancel order?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.isCancel = true
            self.cancelOrder(itemId: "", orderId: self.orederList["id"].stringValue,index: 0)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    
    @objc func actionCancle(_ sender:UIButton){
        let alert = UIAlertController(title: "Cancel!", message: "Are you sure to cancel item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let index = sender.tag
            self.isCancel = false
            self.cancelOrder(itemId: self.orederList["items"][index]["id"].stringValue, orderId: self.orederList["items"][index]["order_id"].stringValue,index: index)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    
    //MARK:- Tableview Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orederList["items"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrackOrderTCV
        cell.lblProductName.text = orederList["items"][indexPath.row]["name"].stringValue
        cell.lblCount.text = "Qty: \(orederList["items"][indexPath.row]["quantity"].stringValue) \(orederList["items"][indexPath.row]["unit"].stringValue)"
        let price = Int(orederList["items"][indexPath.row]["quantity"].stringValue)! * orederList["items"][indexPath.row]["price"].intValue
        cell.lblPrice.text = "QAR \(price).0"
        cell.lblVia.text = "Via \(orederList["payment_method"].stringValue.uppercased())"
        cell.lblStatus.text = orederList["items"][indexPath.row]["active_status"].stringValue.capitalized
        cell.imgProduct.sd_setImage(with: URL.init(string: orederList["items"][indexPath.row]["image"].stringValue), placeholderImage: UIImage.init(named: "placeholder"), options:[.refreshCached], context: nil)
        if orederList["items"][indexPath.row]["active_status"].stringValue.capitalized == "Cancelled"{
            cell.btnCancel.isHidden = true
            cell.lblStatus.textColor = UIColor.red
        }else{
            cell.btnCancel.isHidden = false
            cell.lblStatus.textColor = UIColor.darkGray
        }
        cell.btnCancel.tag = indexPath.row
//        if orederList["active_status"].stringValue == "cancelled"{
//            cell.btnCancel.isHidden = true
//        }else{
//
//            cell.btnCancel.isHidden = false
//        }
        cell.btnCancel.addTarget(self, action: #selector(actionCancle(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

