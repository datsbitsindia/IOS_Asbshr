//
//  RegisterVC.swift
//  ABSHR
//
//  Created by mac on 13/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import GoogleMaps
import CoreLocation
import MapKit
class RegisterVC: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var lblIHave: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMob: UILabel!
    @IBOutlet weak var lblPin: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblConfirm: UILabel!
    @IBOutlet weak var lblRefre: UILabel!
    @IBOutlet weak var lblPersonal: UILabel!
    @IBOutlet weak var BtnUpdate: UIButton!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var lblSelectedCity: UILabel!
    @IBOutlet weak var lblSelectedArea: UILabel!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textMobileNo: UITextField!
    @IBOutlet weak var textPin: UITextField!
    @IBOutlet weak var textAddress: UITextView!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textConformPassword: UITextField!
    @IBOutlet weak var textRefferalCode: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var cityDropDown: UIView!
    @IBOutlet weak var btnCheckMark: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var city_list = [String]()
    var citys = JSON.null
    var area_list = [String]()
    let locationManager = CLLocationManager()
    var isCurrent = Bool()
    var currentLocation = CLLocation()
    var selectedLocation = String()
    var phoneNumber = String()
    var user = User()
    var city_id = String()
    var area_id = String()
    var area_json = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentLocation()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        self.textAddress.text = addressString
    }
    
    func initView(){
        getCity()
        textMobileNo.text = phoneNumber
        [lblTitle,lblEmail,lblCity,lblArea,lblIHave,lblName,lblPin,lblAddress,lblMob,lblPassword,lblConfirm,lblRefre,lblSelectedCity,lblSelectedArea,lblPersonal].forEach{
            $0?.setLocalize()
        }
        [textEmail,textMobileNo,textPin,textPassword,textConformPassword,textRefferalCode,textName].forEach{
            $0?.setLocalize()
        }
        [btnRegister,BtnUpdate].forEach{
            $0?.setLocalize()
        }
    }
    
    func getCurrentLocation(){
      let generator = UIImpactFeedbackGenerator(style: .heavy)
      generator.impactOccurred()

      self.locationManager.requestAlwaysAuthorization()

      self.locationManager.requestWhenInUseAuthorization()

      if CLLocationManager.locationServicesEnabled() {
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
          locationManager.startUpdatingLocation()
      }
      
    }
    
    func getCity(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336] as [String : Any]
        print(dictRequest)
        
        AF.request(GET_CITIES, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    self.citys = dict["data"]
                    for i in 0..<dict["data"].count{
                        self.city_list.append(dict["data"][i]["name"].stringValue)
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
    
    func getArea(city_id:String){
        SVProgressHUD.show()
        self.city_id = city_id
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,
        "city_id":city_id] as [String : Any]
        print(dictRequest)
        
        AF.request(GET_AREAOFCITIRE, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    self.area_list.removeAll()
                    self.area_json = dict["data"]
                    for i in 0..<dict["data"].count{
                        self.area_list.append(dict["data"][i]["name"].stringValue)
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
    
    func registerUser(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,
                           "type":"register",
                           "name":textName.text!,
                           "email":textEmail.text!,
                           "password":textPassword.text!,
                           "mobile":textMobileNo.text!,
                           "city": lblSelectedCity.text!,
                           "city_id": self.city_id,
                           "area_id": self.area_id,
                           "street": textAddress.text!,
                           "pincode": textPin.text!] as [String : Any]
        print(dictRequest)
        
        AF.request(REGISTRATION, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                    self.user = User.init(user_id: dict["user_id"].stringValue, city_id: dict["city_id"].stringValue, status: dict["status"].stringValue, latitude: dict["latitude"].stringValue, country_code: dict["country_code"].stringValue, message: dict["message"].stringValue, mobile: dict["mobile"].stringValue, street: dict["street"].stringValue, created_at: dict["created_at"].stringValue, apikey: dict["apikey"].stringValue, area_name: dict["area_name"].stringValue, city_name: dict["city_name"].stringValue, dob: dict["dob"].stringValue, area_id: dict["area_id"].stringValue, name: dict["name"].stringValue, referral_code: dict["referral_code"].stringValue, fcm_id: dict["fcm_id"].stringValue, email: dict["email"].stringValue, pincode: dict["pincode"].stringValue, friends_code: dict["friends_code"].stringValue, longitude: dict["longitude"].stringValue)
                    
                    
                    
                    let placesData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                    userdefault.set(placesData, forKey: KEY_USER)
                    userdefault.set(self.textPassword.text!, forKey: KEY_PASSWORD)
                    userdefault.set(true, forKey: KEY_ISLOGIN)
                    userdefault.set(true, forKey: KEY_FIRSTTIME)
                    userdefault.synchronize()
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
                    let nav1 = UINavigationController(rootViewController: vc)
                    appDelegate.window?.rootViewController = nav1
                    appDelegate.window?.makeKeyAndVisible()
                    print(dict)
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
    
    //MARK:- MapView Delegate
     
     func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
       self.reverseGeocodeCoordinate(coordinate)
       mapView.clear()
       let marker = GMSMarker()
       marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude:coordinate.longitude)
       let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

       location.fetchCityAndCountry { city, country,state, error in
         guard let city = city, let country = country,let state = state, error == nil else { return }
         marker.title = "\(city),\(state)"
         marker.snippet = country
       }
       marker.snippet = self.selectedLocation
       marker.map = mapView
       marker.appearAnimation = .pop
     }
     
     private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {

       let geocoder = GMSGeocoder()
    
       geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
         guard let address = response?.firstResult(), let lines = address.lines else {
           return
         }
        
         self.selectedLocation = lines.joined(separator: "\n")
        addressString = self.selectedLocation
        self.textAddress.text = addressString
         print(self.selectedLocation)
         
         UIView.animate(withDuration: 0.25) {
           self.view.layoutIfNeeded()
         }
       }
     }
     
     //MARK:- Location Delegate
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       let locValue:CLLocationCoordinate2D = manager.location!.coordinate
       print("locations = \(locValue.latitude) \(locValue.longitude)")
       let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
       if !isCurrent{
         isCurrent = true
         mapView.clear()
         let marker = GMSMarker()
         marker.position = CLLocationCoordinate2D(latitude: locValue.latitude, longitude:locValue.longitude)
         let camera = GMSCameraPosition.camera(withLatitude:locValue.latitude, longitude:locValue.longitude, zoom: 13)
         self.mapView.animate(to: camera)
         self.reverseGeocodeCoordinate(locValue)
         location.fetchCityAndCountry { city, country,state, error in
           guard let city = city, let country = country,let state = state, error == nil else { return }
           print("\(city)..\(state)")
           marker.title = "\(city),\(state)"
           
         }
         marker.snippet = self.selectedLocation
         marker.map = self.mapView
         marker.appearAnimation = .pop
       }
      
       locationManager.stopUpdatingLocation()
     }
     
     func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
       print("tap....")
     }
     
     func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
       print("hdgsdf")
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error::: \(error)")
         locationManager.stopUpdatingLocation()
     }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    
    //MARK:- Btn Cliks
    
    @IBAction func acntionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionRegister(_ sender: Any) {
        if textEmail.text!.count != 0 && lblSelectedArea.text! != "Select Area" && lblSelectedCity.text != "Select City" && textName.text!.count != 0 && textMobileNo.text!.count != 0 && textPin.text!.count != 0 && textAddress.text!.count != 0 && textPassword.text!.count != 0 && textConformPassword.text!.count != 0{
            if textConformPassword.text! == textPassword.text!{
                if btnCheckMark.isSelected{
                    if isValidEmail(textEmail.text!){
                        if textMobileNo.text!.count == 10{
                            if textPin.text?.count == 6{
                               self.registerUser()
                            }else{
                                AppHelper.shared.showToast(message: Const.Please_Enter_Valid_Pincode, sender: self)
                            }
                            
                        }else{
                            AppHelper.shared.showToast(message: Const.Enter_Valid_Number, sender: self)
                        }
                        
                    }else{
                        AppHelper.shared.showToast(message: Const.Please_Enter_Valid_Email, sender: self)
                    }
                    
                }else{
                    AppHelper.shared.showToast(message: Const.Select_Checkbox, sender: self)
                }
                
            }else{
                AppHelper.shared.showToast(message: Const.Same_pass, sender: self)
            }
        }else{
            AppHelper.shared.showToast(message: Const.Enter_All_Details, sender: self)
        }
    }
    
    @IBAction func actionSelectCity(_ sender: UIButton) {
        if self.city_list.count > 0{
            KTOptionMenu(sender: sender, options: self.city_list, action: { index in
                self.lblSelectedCity.text = self.city_list[index]
                self.getArea(city_id: self.citys[index]["id"].stringValue)
            })
        }else{
            AppHelper.shared.showToast(message: Const.No_Cities, sender: self)
        }
        
    }
    
    @IBAction func actionSelectArea(_ sender: UIButton) {
        if self.area_list.count > 0{
            KTOptionMenu(sender: sender, options:self.area_list, action: { index in
                self.lblSelectedArea.text = self.area_list[index]
                self.area_id = self.area_json[index]["id"].stringValue
            })
        }else{
            AppHelper.shared.showToast(message: "No Areas are available..", sender: self)
        }
      
    }
    
    @IBAction func actionCheckMark(_ sender: UIButton) {
        btnCheckMark.isSelected = sender.isSelected ? false : true
    }
    
    @IBAction func actionUpdateLocation(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
