//
//  EnterMobileNoVC.swift
//  ABSHR
//
//  Created by mac on 13/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseAuth
class EnterMobileNoVC: UIViewController {
    
    
    @IBOutlet weak var btnBackGo: UIButton!
    
    @IBOutlet weak var btnCont: UIButton!
    @IBOutlet weak var contryCode: UITextField!
    @IBOutlet weak var textEnterNumber: UITextField!
        
    @IBOutlet weak var lblVerify: UILabel!
    @IBOutlet weak var lblWe: UILabel!
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    func initView(){
        [lblWe,lblVerify].forEach{
            $0?.setLocalize()
        }
        [textEnterNumber].forEach{
             $0?.setLocalize()
        }
        [btnCont].forEach{
             $0?.setLocalize()
        }
    }

    func sendCode(){
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        SVProgressHUD.show()
        PhoneAuthProvider.provider().verifyPhoneNumber("+\(contryCode.text!) \(textEnterNumber.text!)", uiDelegate: nil) { (verificationID, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                print("failed")
                print(error.localizedDescription)
                return
            }
            AppHelper.shared.showToast(message: Const.OTP_Sent_Successfully, sender: self)
            userdefault.set(verificationID, forKey: KEY_VERIFICATIONID)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
            vc.phoneNumber = self.textEnterNumber.text!
            vc.contryCode = "+\(self.contryCode.text!)"
            self.navigationController?.pushViewController(vc, animated: true)
            print("sccess")
        }
        
    }
        
    //MARK:- Button Clicks
        
    @IBAction func actionSendCode(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        if textEnterNumber.text!.count != 0 && contryCode.text!.count != 0{
            self.sendCode()
        }else{
            AppHelper.shared.showToast(message: Const.Enter_Valid_Number, sender: self)
        }
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
}
