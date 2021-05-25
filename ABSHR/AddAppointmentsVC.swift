//
//  AddAppointmentsVC.swift
//  ABSHR
//
//  Created by mac on 27/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
class AddAppointmentsVC: UIViewController {
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textMobile: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblPetCategory: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
    var user = User()
    var pet_category = [String]()
    var pet_list = JSON.null
    var pet_id = String()
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
        let placesData1 = UserDefaults.standard.object(forKey: KEY_USER) as? NSData
        if let placesData = placesData1 {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? User
            if let placesArray = placesArray {
                self.user = placesArray
            }
            
        }
        textName.text = user.name
        textMobile.text = user.mobile
        textEmail.text = user.email
        self.getPetList()
        
    }
    
    func getPetList(){
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"get-petcategory":"1"] as [String : Any]
        print(dictRequest)
        
        AF.request(GET_PET_CATEGORY, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    self.pet_list = dict["data"]
                    for i in 0..<self.pet_list.count{
                        self.pet_category.append(self.pet_list[i]["name"].stringValue)
                    }
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
    
//    func getPatCategory(){
//        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
//        let dictRequest = ["accesskey":90336,"get-petcategory":"1"] as [String : Any]
//        print(dictRequest)
//        
//        AF.request(GET_PET_CATEGORY, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
//            switch response.result{
//            case .success(let value):
//                let dict = JSON(value)
//                SVProgressHUD.dismiss()
//                //                if dict["error"].stringValue == "false"{
//                let alert = UIAlertController.init(title: "Successfully!!", message: dict["message"].stringValue, preferredStyle: .alert)
//                
//                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in
//                    self.navigationController?.popViewController(animated: true)
//                }))
//                self.present(alert, animated: true, completion: nil)
//            case .failure(let error):
//                print(error.localizedDescription)
//                SVProgressHUD.dismiss()
//                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
//            }
//        }
//    }
    
    func addAppointments(){
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"mobile_no":textMobile.text!,"name":textName.text!,"description":textDescription.text!,"pet_category":self.pet_id,"user_id":user.user_id,"email":textEmail.text!] as [String : Any]
        print(dictRequest)
        
        AF.request(GET_DOCTORS, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                
//                var msg = dict["message"].stringValue.replacingOccurrences(of: "<span class='label label-success'>", with: "")
//
//                msg = msg.replacingOccurrences(of: "<span>", with: "")
//                msg = msg.replacingOccurrences(of: "\("")", with: "")
//                msg = msg.replacingOccurrences(of: "/", with: "")
                
                    let alert = UIAlertController.init(title: "Successfully!!", message: dict["message"].stringValue, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentsVC") as! AppointmentsVC
                        self.navigationController?.pushViewController(vc, animated: true)
//                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
//                }else{
//                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
//                }
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
    
    @IBAction func actionSubmit(_ sender: Any) {
        if textName.text!.count != 0 && textMobile.text!.count != 0 && textEmail.text!.count != 0 && textDescription.text!.count != 0 && lblPetCategory.text! != "Select Pet Category"{
            self.addAppointments()
        }else{
            AppHelper.shared.showToast(message: "Please Add All Informations", sender: self)
        }
    }
    
    @IBAction func actionSelect(_ sender: UIButton) {
        if pet_category.count > 0{
            KTOptionMenu(sender: sender, options: self.pet_category, action: { index in
                self.lblPetCategory.text = self.pet_category[index]
                self.pet_id = self.pet_list[index]["id"].stringValue
            })
        }
        
    }
    
}
