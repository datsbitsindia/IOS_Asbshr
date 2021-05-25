//
//  VerifyOTPVC.swift
//  ABSHR
//
//  Created by mac on 13/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class VerifyOTPVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnBackGo: UIButton!
    @IBOutlet weak var btnResenf: UIButton!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var lblEnter: UILabel!
    @IBOutlet weak var textFieldOtpOne: UITextField!
    @IBOutlet weak var textFieldOtpTwo: UITextField!
    @IBOutlet weak var textFieldOtpThree: UITextField!
    @IBOutlet weak var textFieldOtpFour: UITextField!

    @IBOutlet weak var textFieldFive: UITextField!
    @IBOutlet weak var textFieldSix: UITextField!
    @IBOutlet weak var buttonResendOtp: UIButton!
    
    @IBOutlet weak var lblText: UILabel!
    
    var verificationCode = ""
    var verificationId = ""
    var phoneNumber = ""
    var contryCode = ""
    var isReset = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardOnTap()
        
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
    
        textFieldOtpOne.delegate = self
        textFieldOtpTwo.delegate = self
        textFieldOtpThree.delegate = self
        textFieldOtpFour.delegate = self
        textFieldFive.delegate = self
        textFieldSix.delegate = self
        
        lblText.text = "\(Const.Please_Enter_OTP_Sent) \(contryCode) \(phoneNumber)"
        localized()
        
        
    }
    func localized(){
        [lblText,lblEnter,].forEach{
            $0?.setLocalize()
        }
        [btnResenf,btnVerify].forEach{
             $0?.setLocalize()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        textFieldOtpOne.becomeFirstResponder()
    }
    
   
    func hideKeyBoardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text
        if text?.count == 1 && string != "" {
          switch textField{
          case textFieldOtpOne:
            textFieldOtpTwo.text? = string
            textFieldOtpTwo.becomeFirstResponder()
          case textFieldOtpTwo:
            textFieldOtpThree.text? = string
            textFieldOtpThree.becomeFirstResponder()
          case textFieldOtpThree:
              textFieldOtpFour.text? = string
              textFieldOtpFour.becomeFirstResponder()
          case textFieldOtpFour:
              textFieldFive.text? = string
              textFieldFive.becomeFirstResponder()
          case textFieldFive:
              textFieldSix.text? = string
              textFieldFive.resignFirstResponder()
              verificationCode = "\((textFieldOtpOne?.text)!)\((textFieldOtpTwo?.text)!)\((textFieldOtpThree?.text)!)\((textFieldOtpFour?.text)!)\((textFieldFive?.text)!)\(string)"
              
              self.view.endEditing(true)
          default:
            break
          }
          return false
        }
        else {
          switch textField{
          case textFieldOtpOne:
            textFieldOtpOne.becomeFirstResponder()
          case textFieldOtpTwo:
            textFieldOtpOne.becomeFirstResponder()
          case textFieldOtpThree:
            textFieldOtpTwo.becomeFirstResponder()

          case textFieldOtpFour:
            textFieldOtpThree.becomeFirstResponder()

          case textFieldFive:
            textFieldOtpFour.becomeFirstResponder()
          case textFieldSix:
            textFieldFive.becomeFirstResponder()

          default:
            break
          }
          textField.text? = string
          verificationCode = ""
          return false
        }
    }
    
    func ReSendCode(){
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        SVProgressHUD.show()
        PhoneAuthProvider.provider().verifyPhoneNumber("\(contryCode) \(phoneNumber)", uiDelegate: nil) { (verificationID, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                print("failed")
                print(error.localizedDescription)
                return
            }
            AppHelper.shared.showToast(message: Const.OTP_Sent_Successfully, sender: self)
            userdefault.set(verificationID, forKey: KEY_VERIFICATIONID)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
//            vc.phoneNumber = self.textEnterNumber.text!
//            self.navigationController?.pushViewController(vc, animated: true)
            print("sccess")
        }
        
    }
    
    //MARK:- Button Cliks
    
    @IBAction func actionProcced(_ sender: Any) {
        if verificationCode.count != 0 && verificationCode.count == 6{
            SVProgressHUD.show()
            let verificationID = UserDefaults.standard.string(forKey: KEY_VERIFICATIONID)
            let testVerificationCode = verificationCode
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",
                                                                     verificationCode: testVerificationCode)
            Auth.auth().signIn(with: credential, completion: { authData, error in
                SVProgressHUD.dismiss()
                if error != nil{
                    // Handles error
                    AppHelper.shared.showToast(message: error!.localizedDescription, sender: self)
                    print(error!.localizedDescription)
                    return
                }
                
                let user = authData?.user
                print(user!)
                if self.isReset{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecoverPasswordVC") as! RecoverPasswordVC
//                    vc.phoneNumber = self.phoneNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                    vc.phoneNumber = self.phoneNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            })
            
        }else{
            AppHelper.shared.showToast(message: Const.Please_Enter_Valid_Code, sender: self)
        }
        
    }
    
    @IBAction func actionResendCode(_ sender: Any) {
        self.ReSendCode()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
