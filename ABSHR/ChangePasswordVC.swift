//
//  ChangePasswordVC.swift
//  ABSHR
//
//  Created by mac on 19/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
class ChangePasswordVC: UIViewController {

    @IBOutlet weak var btnBackGo: UIButton!
    
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var lblChangePassword: UILabel!
    @IBOutlet weak var textEnterOldPass: UITextField!
    @IBOutlet weak var textNewPass: UITextField!
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
        btnChangePassword.setLocalize()
        lblChangePassword.setLocalize()
        textNewPass.setLocalize()
        textEnterOldPass.setLocalize()
    }
    
    func initView(){
       let placesData1 = UserDefaults.standard.object(forKey: KEY_USER) as? NSData
       if let placesData = placesData1 {
           let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? User
           if let placesArray = placesArray {
               self.user = placesArray
           }
           
       }
    }
    
    func updatePassword(){
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"type":"change-password",
                           "id":user.user_id,
                           "password":textNewPass.text!] as [String : Any]
        print(dictRequest)
        
        AF.request(REGISTRATION, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    AppHelper.shared.showToast(message: "Update Password Successfully....", sender: self)
                    self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func acctionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUpdatePassword(_ sender: Any) {
        if textEnterOldPass.text?.count != 0 && textNewPass.text?.count != 0{
            var pass = String()
            if let password = userdefault.object(forKey: KEY_PASSWORD){
                pass = password as? String ?? ""
            }else{
                pass = ""
            }
            
            if textEnterOldPass.text! == pass{
                self.updatePassword()
            }else{
                AppHelper.shared.showToast(message: "Old Password not matched", sender: self)
            }
            
            
        }else{
            AppHelper.shared.showToast(message: "Please Enter Password..", sender: self)
        }
    }
    
    
}
