//
//  LoginVC.swift
//  ABSHR
//
//  Created by mac on 13/10/20.
//  Copyright © 2020 . All rightsif reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices
class LoginVC: UIViewController,GIDSignInDelegate{
    
    @IBOutlet weak var googleHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var btnCont: UIButton!
    @IBOutlet weak var btnDont: UIButton!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var textMobileNo: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var viewApple: UIView!
    var user = User()
    
    var isApple = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
       initView()
        
        if getCurrentLang() == "ar-SA" {
            googleHeight.constant = 40
        }else {
            googleHeight.constant = -40
        }
    }
    
    func initView(){
        self.navigationController?.navigationBar.isHidden = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        [lblOr,lblLogin,lblAppName].forEach{
            $0?.setLocalize()
        }
        [textMobileNo,textPassword].forEach{
             $0?.setLocalize()
        }
        [btnSubmit,btnForgot,btnCont,btnDont,btnSignin].forEach{
             $0?.setLocalize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            self.setupAppleIDCredentialObserver()
            self.setupAppleLogin()
        } else {
            self.viewApple.isHidden = true
        }
    }
    
    @available(iOS 13.0, *)
    func setupAppleLogin(){
      let authorizationButton = ASAuthorizationAppleIDButton.init(type: .default, style: .white)
      authorizationButton.frame = CGRect(x: 0, y: 0, width: self.viewApple.frame.size.width, height: self.viewApple.frame.size.height)
      authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
      viewApple.addSubview(authorizationButton)
      viewApple.layer.cornerRadius = 12
      viewApple.layer.masksToBounds = true
      
    }
    
    @available(iOS 13.0, *)
     @objc
     func handleAuthorizationAppleIDButtonPress() {
       let generator = UIImpactFeedbackGenerator(style: .heavy)
       generator.impactOccurred()
       let appleIDProvider = ASAuthorizationAppleIDProvider()
       let request = appleIDProvider.createRequest()
       request.requestedScopes = [.fullName, .email]
       
       let authorizationController = ASAuthorizationController(authorizationRequests: [request])
       authorizationController.delegate = self
       authorizationController.presentationContextProvider = self
       authorizationController.performRequests()
     }
    
    @available(iOS 13.0, *)
       @IBAction func Applelogin(_ sender: Any) {
           
        isApple = true
          let appleIDProvider = ASAuthorizationAppleIDProvider()
           let request = appleIDProvider.createRequest()
           request.requestedScopes = [.fullName, .email]
           
           let authorizationController = ASAuthorizationController(authorizationRequests: [request])
           authorizationController.delegate = self
           authorizationController.presentationContextProvider = self
           authorizationController.performRequests()
       }
    
    @available(iOS 13.0, *)
    private func setupAppleIDCredentialObserver() {
        let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        authorizationAppleIDProvider.getCredentialState(forUserID: "currentUserIdentifier") { (credentialState: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) in
            if let error = error {
                print(error)
                // Something went wrong check error state
                return
            }
            switch (credentialState) {
            case .authorized:
                //User is authorized to continue using your app
                print("User is authorized to continue using your app")
                break
            case .revoked:
                //User has revoked access to your app
                print("User has revoked access to your app")
                break
            case .notFound:
                //User is not found, meaning that the user never signed in through Apple ID
                print("User is not found, meaning that the user never signed in through Apple ID")
                break
            default: break
            }
        }
    }
    
    func loginUser(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"mobile":textMobileNo.text!,"password":textPassword.text!,"status":1] as [String : Any]
        print(dictRequest)
        
        AF.request(LOGIN, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    self.user = User.init(user_id: dict["user_id"].stringValue, city_id: dict["city_id"].stringValue, status: dict["status"].stringValue, latitude: dict["latitude"].stringValue, country_code: dict["country_code"].stringValue, message: dict["message"].stringValue, mobile: dict["mobile"].stringValue, street: dict["street"].stringValue, created_at: dict["created_at"].stringValue, apikey: dict["apikey"].stringValue, area_name: dict["area_name"].stringValue, city_name: dict["city_name"].stringValue, dob: dict["dob"].stringValue, area_id: dict["area_id"].stringValue, name: dict["name"].stringValue, referral_code: dict["referral_code"].stringValue, fcm_id: dict["fcm_id"].stringValue, email: dict["email"].stringValue, pincode: dict["pincode"].stringValue, friends_code: dict["friends_code"].stringValue, longitude: dict["longitude"].stringValue)
                    
                    let placesData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                    userdefault.set(placesData, forKey: KEY_USER)
                    userdefault.synchronize()
                    userdefault.set(self.textPassword.text!, forKey: KEY_PASSWORD)
                    userdefault.set(true, forKey: KEY_ISLOGIN)
                    userdefault.set(true, forKey: KEY_FIRSTTIME)
                   
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
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
    
    func GoogleApi(user: GIDGoogleUser!){
        
//        let sv = HomeViewController.displaySpinner(onView: self.view)
//
//        if(user.profile.email == nil || user.userID == nil || user.profile.email == "" || user.userID == ""){
//            AppHelper.shared.showAlert(title: "Error", message: "You cannot signup with this Google account because your Google is not linked with any email.")
//        }else{
//            //SliderViewController.removeSpinner(spinner: sv)
//            self.email = user.profile.email
//            self.first_name = user.profile.givenName
//            self.last_name = user.profile.familyName
//            self.my_id = user.userID
//            if user.profile.hasImage
//            {
//                let pic = user.profile.imageURL(withDimension: 100)
//                self.profile_pic = pic!.absoluteString
//
//            }else{
//                self.profile_pic = ""
//            }
//
//            self.signUPType = "gmail"
//            self.SignUpApi()
//        }
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"email":user.profile.email ?? "","name":"\(user.profile.givenName ?? "") \(user.profile.familyName ?? "")","api_id":user.userID ?? ""] as [String : Any]
        print(dictRequest)
        
        AF.request(GOOGLE_LOGIN, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict.count > 0{
                    self.user = User.init(user_id: dict[0]["id"].stringValue, city_id: dict[0]["city_id"].stringValue, status: dict[0]["status"].stringValue, latitude: dict[0]["latitude"].stringValue, country_code: dict[0]["country_code"].stringValue, message: dict[0]["message"].stringValue, mobile: dict[0]["mobile"].stringValue, street: dict[0]["street"].stringValue, created_at: dict[0]["created_at"].stringValue, apikey: dict[0]["apikey"].stringValue, area_name: dict[0]["area"].stringValue, city_name: dict[0]["city"].stringValue, dob: dict[0]["dob"].stringValue, area_id: dict[0]["area_id"].stringValue, name: dict[0]["name"].stringValue, referral_code: dict[0]["referral_code"].stringValue, fcm_id: dict[0]["fcm_id"].stringValue, email: dict[0]["email"].stringValue, pincode: dict[0]["pincode"].stringValue, friends_code: dict[0]["friends_code"].stringValue, longitude: dict[0]["longitude"].stringValue)
                    
                    let placesData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                    userdefault.set(placesData, forKey: KEY_USER)
                    userdefault.synchronize()
                    userdefault.set(self.textPassword.text!, forKey: KEY_PASSWORD)
                    userdefault.set(true, forKey: KEY_ISLOGIN)
                    userdefault.set(true, forKey: KEY_FIRSTTIME)
                    userdefault.set(true, forKey: KEY_SOCIAL)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
                    vc.isSocial = true
                    let nav1 = UINavigationController(rootViewController: vc)
                    appDelegate.window?.rootViewController = nav1
                    appDelegate.window?.makeKeyAndVisible()
                }else{
                    if dict["message"].stringValue.count > 0{
                         AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                    }else{
                        AppHelper.shared.showToast(message: Const.Something_Wrong, sender: self)
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
    
    func fbLogin(id:String,email:String){
        SVProgressHUD.show()
        var email_id = String()
        var url = String()
        if email.count != 0{
            email_id = email
        }else{
//            email_id = "ss@gmail.com"
        }
        if isApple{
            url = APPLE_LOGIN
        }else{
            url = FB_LOGIN
        }
        
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"api_id":id,"email":email_id] as [String : Any]
        print(dictRequest)
        print(APPLE_LOGIN)
        
        AF.request(url, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict.count > 0{
                    self.user = User.init(user_id: dict[0]["id"].stringValue, city_id: dict[0]["city_id"].stringValue, status: dict[0]["status"].stringValue, latitude: dict[0]["latitude"].stringValue, country_code: dict[0]["country_code"].stringValue, message: dict[0]["message"].stringValue, mobile: dict[0]["mobile"].stringValue, street: dict[0]["street"].stringValue, created_at: dict[0]["created_at"].stringValue, apikey: dict[0]["apikey"].stringValue, area_name: dict[0]["area"].stringValue, city_name: dict[0]["city"].stringValue, dob: dict[0]["dob"].stringValue, area_id: dict[0]["area_id"].stringValue, name: dict[0]["name"].stringValue, referral_code: dict[0]["referral_code"].stringValue, fcm_id: dict[0]["fcm_id"].stringValue, email: dict[0]["email"].stringValue, pincode: dict[0]["pincode"].stringValue, friends_code: dict[0]["friends_code"].stringValue, longitude: dict[0]["longitude"].stringValue)
                    
                    let placesData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                    userdefault.set(placesData, forKey: KEY_USER)
                    userdefault.synchronize()
                    userdefault.set(self.textPassword.text!, forKey: KEY_PASSWORD)
                    userdefault.set(true, forKey: KEY_ISLOGIN)
                    userdefault.set(true, forKey: KEY_FIRSTTIME)
                    userdefault.set(true, forKey: KEY_SOCIAL)
                    if !self.isApple{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
                        vc.isSocial = true
                        let nav1 = UINavigationController(rootViewController: vc)
                        appDelegate.window?.rootViewController = nav1
                        appDelegate.window?.makeKeyAndVisible()
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
                        let nav1 = UINavigationController(rootViewController: vc)
                        appDelegate.window?.rootViewController = nav1
                        appDelegate.window?.makeKeyAndVisible()
                    }
                   
                    
                }else{
                    if dict["message"].stringValue.count > 0{
                         AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                    }else{
                        AppHelper.shared.showToast(message: Const.Something_Wrong, sender: self)
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
    
    //MARK:- Btn Submit
    
    @IBAction func btnSubmit(_ sender: Any) {
        if textMobileNo.text!.count > 0 && textPassword.text!.count > 0{
            self.loginUser()
        }else{
            if textMobileNo.text!.count == 0{
                AppHelper.shared.showToast(message: Const.Please_Enter_Mobile_Number, sender: self)
            }else{
                AppHelper.shared.showToast(message: Const.Please_Enter_Password, sender: self)
            }
        }
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterMobileNoVC") as! EnterMobileNoVC
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnGuast(_ sender: Any) {
        userdefault.set(true, forKey: KEY_GAUST)
        userdefault.set(true, forKey: KEY_FIRSTTIME)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
        let nav1 = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = nav1
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func actionGoogleSignin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func actionFB(_ sender: Any) {
        isApple = false
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")){
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        SVProgressHUD.show()
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,age_range"]).start(completionHandler: { (connection, result, error) -> Void in
                SVProgressHUD.dismiss()
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    if let dict = result as? [String : AnyObject]{
                        if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" ){
                            
                             AppHelper.shared.showAlert(title: "Error", message: "You cannot login with this facebook account because your facebook is not linked with any email.")
                        }else{
                           
                            let email = dict["email"] as? String
//                            self.first_name = dict["first_name"] as? String
//                            self.last_name = dict["last_name"] as? String
                            let my_id = dict["id"] as? String
//
//                            self.SignUpApi()
                            self.fbLogin(id: AccessToken.current?.tokenString ?? "",email:email ?? "")
                            
                        }
                    }
                    
                }else{
                   
                }
            })
        }
        
    }
    
    
    @IBAction func actionForgetPassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Google Login Methods
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
           print(error.localizedDescription)
       }
       
       func signIn(signIn: GIDSignIn!,
                   presentViewController viewController: UIViewController!) {
           self.present(viewController, animated: true, completion: nil)
       }
       
       func signIn(signIn: GIDSignIn!,
                   dismissViewController viewController: UIViewController!) {
           self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            if(user.profile.email == nil || user.userID == nil || user.profile.email == "" || user.userID == ""){
                AppHelper.shared.showAlert(title: "Error", message: "You cannot signup with this Google account because your Google is not linked with any email.")
            }else{
                self.GoogleApi(user: user)
            }
            
        } else {
            
            print("\(error.localizedDescription)")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
    }
}


extension LoginVC: ASAuthorizationControllerDelegate {
        @available(iOS 12.0, *)
        @available(iOS 13.0, *)
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

            print("User ID: \(appleIDCredential.user)")
            
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                print(appleIDCredential)
            case let passwordCredential as ASPasswordCredential:
                print(passwordCredential)
            default: break
            }
            var email = String()
            if let userEmail = appleIDCredential.email {
              print("Email: \(userEmail)")
                email = userEmail
//                self.my_id = appleIDCredential.user
            }else{
//                email = appleIDCredential.user
            }

            if let userGivenName = appleIDCredential.fullName?.givenName,
                
              let userFamilyName = appleIDCredential.fullName?.familyName {
                //print("Given Name: \(userGivenName)")
               // print("Family Name: \(userFamilyName)",
//
//              self.my_id = appleIDCredential.user
//             self.first_name = userGivenName
//            self.last_name = userFamilyName
                
                
            }
            
            

            if let authorizationCode = appleIDCredential.authorizationCode,
              let identifyToken = appleIDCredential.identityToken {
              print("Authorization Code: \(authorizationCode)")
              print("Identity Token: \(identifyToken)")
              //First time user, perform authentication with the backend
              //TODO: Submit authorization code and identity token to your backend for user validation and signIn
                //self.signUp(self)
              // if(self.email != ""){
                                          
//                                          self.signUPType = "apple"
//                                          self.profile_pic = """"
                
                self.isApple = true
                self.fbLogin(id:appleIDCredential.user,email:email)
//                                      }else{
//
//                                       self.alertModule(title:"Error", msg: "Please share your email.")
//                                   }
             return
            }
            
          }
          
        @available(iOS 13.0, *)
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("Authorization returned an error: \(error.localizedDescription)")
          }
        }
        extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
            @available(iOS 13.0, *)
            func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return view.window!
          }
    }
