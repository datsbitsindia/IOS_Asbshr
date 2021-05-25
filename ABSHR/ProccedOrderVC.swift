//
//  ProccedOrderVC.swift
//  ABSHR
//
//  Created by mac on 18/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
class ProccedOrderVC: UIViewController {
    
    
    @IBOutlet weak var btnBackGo: UIButton!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var btnTomorrow: UIButton!
    @IBOutlet weak var btnAfternoon: UIButton!
    @IBOutlet weak var btnMorning: UIButton!
    @IBOutlet weak var btnEvening: UIButton!
    @IBOutlet weak var btnCOD: UIButton!
    @IBOutlet weak var viewCOD: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var lblFinalTotal: UILabel!
    
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblFinalAmount: UILabel!
    @IBOutlet weak var viewConfirm: UIView!
    
    @IBOutlet weak var lblDelivery: UILabel!
    
    @IBOutlet weak var lblPayment: UILabel!
    
    @IBOutlet weak var lblProceed: UIButton!
    
    @IBOutlet weak var lbltxtTotal: UILabel!
    
    @IBOutlet weak var lblSelectPayment: UILabel!
    
    @IBOutlet weak var lblCashonDelivery: UILabel!
    @IBOutlet weak var lblCheckout: UILabel!
    var cart_list = [CartItem]()
    var user = User()
    var address = String()
    var product_ids = [String]()
    var quntity = [String]()
    var total = String()
    var tax = String()
    var discount = String()
    var dilevery_charge = String()
    var final_total = String()
    var homeoroffice = String()
    var todayortommorow = String()
    var selectedTime = String()
    var promoDiscount = Double()
    var promoCode = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblCheckout.setLocalize()
        lblDelivery.setLocalize()
        lblPayment.setLocalize()
        lblSelectPayment.setLocalize()
        lblCashonDelivery.setLocalize()
        lbltxtTotal.setLocalize()
        lblProceed.setLocalize()
        
        let placesData = UserDefaults.standard.object(forKey: KEY_USER) as? NSData
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? User
            if let placesArray = placesArray {
                self.user = placesArray
            }
            
        }
        
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
        iniView()
        viewConfirm.alpha = 0.0
    }
    
    func iniView(){
        DispatchQueue.main.async {
            if !UIDevice.current.hasNotch{
                self.viewHeaderHeight.constant = 66
            }
        }
        if cart_list.count > 0{
            for i in 0..<cart_list.count{
                product_ids.append(cart_list[i].id)
                quntity.append(cart_list[i].count)
            }
        }
        
        var total1 = Double()
        viewCOD.shadow()
        viewTime.shadow()
        for i in 0..<cart_list.count{
            total1 = total1 + (Double(self.cart_list[i].price)! * Double(self.cart_list[i].count)!)
        }
        
        if total1 > 500 {
            self.total = "\(total1.rounded(toPlaces: 1) + Double(total1)*0.1.rounded(toPlaces: 1))"
            self.dilevery_charge = "0.0"
            self.lblDeliveryCharge.text = "QAR \(self.dilevery_charge)"
            self.tax = "\(Double(total1)*0.1.rounded(toPlaces: 1))"
            self.final_total = "\(total1+(Double(total1)*0.1.rounded(toPlaces: 1)).rounded(toPlaces: 1)-promoDiscount)"
        }else{
            self.total = "\(total1.rounded(toPlaces: 1) + 30 + Double(total1)*0.1.rounded(toPlaces: 1))"
            self.dilevery_charge = "30.0"
            self.lblDeliveryCharge.text = "QAR \(self.dilevery_charge)"
            self.tax = "\(Double(total1)*0.1.rounded(toPlaces: 1))"
            self.final_total = "\(total1+(Double(total1)*0.1.rounded(toPlaces: 1))+30.rounded(toPlaces: 1)-promoDiscount)"
        }
        lblTax.text = "+ QAR \(self.tax)"
        lblTotal.text = "QAR \(self.total)"
        lblItemPrice.text = "QAR \(self.total)"
        lblPromoCode.text = "- QAR \(self.promoDiscount.rounded(toPlaces: 2))"
        lblFinalTotal.text = "QAR \(self.final_total)"
        lblFinalAmount.text = "QAR \(self.final_total)"
        
        if Calendar.current.component(.hour, from: Date()) > 18{
            btnToday.isEnabled = false
        }else{
            btnToday.isEnabled = true
        }
        
    }
    
    func selectOption(){
        if btnToday.isSelected{
            if Calendar.current.component(.hour, from: Date()) > 12{
                btnMorning.isEnabled = false
                btnAfternoon.isEnabled = true
                btnEvening.isEnabled = true
            }else if Calendar.current.component(.hour, from: Date()) > 16{
                btnMorning.isEnabled = false
                btnAfternoon.isEnabled = false
                btnEvening.isEnabled = true
            }else{
                btnMorning.isEnabled = false
                btnAfternoon.isEnabled = false
                btnEvening.isEnabled = true
            }
        }else{
            btnMorning.isEnabled = true
            btnAfternoon.isEnabled = true
            btnEvening.isEnabled = true
        }
        
    }
    
    func orderPlace(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        var dictRequest = [String:Any]()
        if promoCode.count > 0{
            dictRequest = ["accesskey":90336,
                           "user_id":user.user_id,
                           "tax_amount":self.tax,
                           "quantity":"\(self.quntity)",
                "address":"\(self.address) \(homeoroffice)",
                "latitude":lat,
                "mobile":user.mobile,
                "delivery_time":"\(todayortommorow) \(selectedTime)",
                "total":self.total,
                "delivery_charge":self.dilevery_charge,
                "final_total":self.final_total,
                "tax_percentage":"10.0",
                "place_order":"1",
                "wallet_used":false,
                "product_variant_id":"\(self.product_ids)",
                "payment_method":"cod",
                "email":user.email,
                "longitude":long,
                "promo_code":self.promoCode,
                "promo_discount":self.promoDiscount
                ] as [String : Any]
        }else{
            dictRequest = ["accesskey":90336,
                           "user_id":user.user_id,
                           "tax_amount":self.tax,
                           "quantity":"\(self.quntity)",
                "address":"\(self.address) \(homeoroffice)",
                "latitude":lat,
                "mobile":user.mobile,
                "delivery_time":"\(todayortommorow) \(selectedTime)",
                "total":self.total,
                "delivery_charge":self.dilevery_charge,
                "final_total":self.final_total,
                "tax_percentage":"10.0",
                "place_order":"1",
                "wallet_used":false,
                "product_variant_id":"\(self.product_ids)",
                "payment_method":"cod",
                "email":user.email,
                "longitude":long
                ] as [String : Any]
        }
       
        print(dictRequest)
        
        AF.request(ORDER_PROCESS, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    let alert = UIAlertController.init(title: "Successfully!!", message: "Your Order Done Successfully...", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in
                        self.cart_list.removeAll()
                        let placesData = NSKeyedArchiver.archivedData(withRootObject: self.cart_list)
                        userdefault.set(placesData, forKey: KEY_CART)
                        userdefault.synchronize()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessfullyVC") as! SuccessfullyVC
                        self.navigationController?.pushViewController(vc, animated: true)
//                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                   
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
    
    
    //MARK:- Btn Action

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionToday(_ sender: UIButton) {
        btnTomorrow.isSelected = false
        btnToday.isSelected = sender.isSelected ? false : true
    }
    
    @IBAction func actionTomorrow(_ sender: UIButton) {
        btnToday.isSelected = false
        btnTomorrow.isSelected = sender.isSelected ? false : true
    }
    
    @IBAction func actionAfternoon(_ sender: UIButton) {
        btnMorning.isSelected = false
        btnEvening.isSelected = false
        btnAfternoon.isSelected = sender.isSelected ? false : true
        selectOption()
    }
    
    @IBAction func actionMorning(_ sender: UIButton) {
        btnAfternoon.isSelected = false
        btnEvening.isSelected = false
        btnMorning.isSelected = sender.isSelected ? false : true
        selectOption()
    }
    
    @IBAction func actionEvening(_ sender: UIButton) {
        btnAfternoon.isSelected = false
        btnMorning.isSelected = false
        btnEvening.isSelected = sender.isSelected ? false : true
        selectOption()
    }
    
    @IBAction func actionCOD(_ sender: UIButton) {
        btnCOD.isSelected = sender.isSelected ? false : true
    }
    
    
    @IBAction func actionProcced(_ sender: Any) {
        todayortommorow = btnToday.isSelected ? "Today" : "Tomorrow"
        if btnAfternoon.isSelected{
            selectedTime = "Aftermoon"
        }else if btnMorning.isSelected{
            selectedTime = "Morning 9.00am - 12.00pm"
        }else if btnEvening.isSelected{
            selectedTime = "Evening 4.00pm - 8.00pm"
        }
        
//        if (btnToday.isSelected || btnTomorrow.isSelected) && (btnMorning.isSelected || btnAfternoon.isSelected || btnEvening.isSelected) && btnCOD.isSelected{
        if btnCOD.isSelected{
            UIView.animate(withDuration: 0.5, animations: {
                self.viewConfirm.alpha = 1.0
            }) { (complate) in
                
            }
        }else{
            if !btnCOD.isSelected{
                AppHelper.shared.showToast(message: "Please Select Payment Method..", sender: self)
            }
        }
    }
    
    @IBAction func actionConfirmOrder(_ sender: Any) {
       
        orderPlace()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewConfirm.alpha = 0.0
        }) { (complate) in
            
        }
    }
    
    
}
