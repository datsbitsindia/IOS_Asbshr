//
//  RecoverPasswordVC.swift
//  ABSHR
//
//  Created by mac on 01/11/20.
//  Copyright © . All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class RecoverPasswordVC: UIViewController {
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var lblReset: UILabel!
    @IBOutlet weak var textEnterOldPass: UITextField!
    @IBOutlet weak var textNewPass: UITextField!
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        [lblReset].forEach{
            $0?.setLocalize()
        }
        [btnReset].forEach{
            $0?.setLocalize()
        }
        [textEnterOldPass,textNewPass].forEach{
            $0?.setLocalize()
        }
    }
    
    func updatePassword(){
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"type":"change-password",
                           "id":user_id,
                           "password":textNewPass.text!] as [String : Any]
        print(dictRequest)
        
        AF.request(REGISTRATION, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    AppHelper.shared.showToast(message: "Rest Password Successfully....", sender: self)
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    let nav1 = UINavigationController(rootViewController: vc)
                    appDelegate.window?.rootViewController = nav1
                    appDelegate.window?.makeKeyAndVisible()
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
            if textEnterOldPass.text == textNewPass.text{
                self.updatePassword()
            }else{
                AppHelper.shared.showToast(message: "Please Enter Same Password..", sender: self)
            }
            
            
        }else{
            AppHelper.shared.showToast(message: "Please Enter Password..", sender: self)
        }
    }
    
    
}
