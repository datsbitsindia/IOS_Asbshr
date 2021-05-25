//
//  ForgotPasswordVC.swift
//  ABSHR
//
//  Created by mac on 01/11/20.
//  Copyright © . All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseAuth
class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var btnBackGo: UIButton!
    @IBOutlet weak var lblVarify: UILabel!
    @IBOutlet weak var btnCont: UIButton!
    @IBOutlet weak var btnForgot: UILabel!
    @IBOutlet weak var contryCode: UITextField!
    @IBOutlet weak var textEnterNumber: UITextField!
    
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
            
    }
    
    func initView(){
        [lblVarify,btnForgot].forEach{
            $0?.setLocalize()
        }
        [btnCont].forEach{
            $0?.setLocalize()
        }
        [textEnterNumber].forEach{
            $0?.setLocalize()
        }
    }
    
    func verifyNumber(){
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"type":"verify-user","mobile":textEnterNumber.text!] as [String : Any]
        print(dictRequest)
        
        AF.request(REGISTRATION, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
//                if dict["error"].stringValue == "false"{
                    
                   user_id = dict["id"].stringValue
                if user_id.count>0{
                    self.sendCode()
                }else{
                    AppHelper.shared.showAlert(title:"Alert!",message: "This Mobile Number in not Registered on ABSHR.Please Register to continue.Return to Log In screen and select Sign Up. "){ _ in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
//                }else{
//                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
//                }
                print(dict)
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
    
    func sendCode(){
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        SVProgressHUD.show()
        let contycode = contryCode.text!.split(separator: "+")
        var c_code = String()
        if contycode.count>1{
            c_code = String(contycode[1])
        }else{
            c_code = contryCode.text!
        }
        PhoneAuthProvider.provider().verifyPhoneNumber("\(contryCode.text!) \(textEnterNumber.text!)", uiDelegate: nil) { (verificationID, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                print("failed")
                print(error.localizedDescription)
                return
            }
            AppHelper.shared.showToast(message: "OTP Sent Successfully...", sender: self)
            userdefault.set(verificationID, forKey: KEY_VERIFICATIONID)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
            vc.phoneNumber = self.textEnterNumber.text!
            vc.contryCode = "\(self.contryCode.text!)"
            vc.isReset = true
            self.navigationController?.pushViewController(vc, animated: true)
            print("sccess")
        }
        
    }
    
    //MARK:- Button Clicks
    
    @IBAction func actionSendCode(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        if textEnterNumber.text!.count != 0 && contryCode.text!.count != 0{
            self.verifyNumber()
            
        }else{
            AppHelper.shared.showToast(message: Const.Enter_Valid_Number, sender: self)
        }
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
