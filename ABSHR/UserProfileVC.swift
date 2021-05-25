//
//  UserProfileVC.swift
//  ABSHR
//
//  Created by mac on 18/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import GoogleMaps
import CoreLocation
import MapKit

class UserProfileVC:UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var lblSelectedCity: UILabel!
    @IBOutlet weak var lblSelectedArea: UILabel!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textMobileNo: UITextField!
    @IBOutlet weak var textPin: UITextField!
    @IBOutlet weak var textAddress: UITextView!
    @IBOutlet weak var textDateofBrith: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var cityDropDown: UIView!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnLogout: UIButton!
    
    
    @IBOutlet weak var btnBackGo: UIButton!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnUpdateLocation: UIButton!
    @IBOutlet weak var lblPersonalInfo: UILabel!
    @IBOutlet weak var lblDateBirth: UILabel!
    
    @IBOutlet weak var lblPinCode: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSelectArea: UILabel!
    @IBOutlet weak var lblSelectCity: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
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
    var isTap = Bool()
    let datePicker = UIDatePicker()
    var isSocial = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh(notification:)), name: Notification.Name("refresh"), object: nil)
        
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
            
            textEmail.textAlignment = .right
            textName.textAlignment = .right
            textMobileNo.textAlignment = .right
            textPin.textAlignment = .right
            textAddress.textAlignment = .right
            textDateofBrith.textAlignment = .right
        }else {
            textEmail.textAlignment = .left
            textName.textAlignment = .left
            textMobileNo.textAlignment = .left
            textPin.textAlignment = .left
            textAddress.textAlignment = .left
            textDateofBrith.textAlignment = .left
        }
        
        btnBackGo.setLocalize()
        lblProfile.setLocalize()
        btnChangePassword.setLocalize()
        btnUpdateLocation.setLocalize()
        lblPersonalInfo.setLocalize()
        lblDateBirth.setLocalize()
        btnRegister.setLocalize()
        lblPinCode.setLocalize()
        lblAddress.setLocalize()
        lblSelectArea.setLocalize()
        lblSelectCity.setLocalize()
        lblMobileNo.setLocalize()
        lblEmail.setLocalize()
        lblName.setLocalize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isTap = false
        self.navigationController?.navigationBar.isHidden = true
        getCurrentLocation()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
//        isSocial = userdefault.bool(forKey: KEY_SOCIAL)
        
        if isSocial{
            btnLogout.isHidden = true
        }else{
            btnLogout.isHidden = false
        }
    }
    
    @objc func refresh(notification: Notification) {
       self.textAddress.text = addressString
    }
    
    func initView(){
        getCity()
        let placesData1 = UserDefaults.standard.object(forKey: KEY_USER) as? NSData
        if let placesData = placesData1 {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? User
            if let placesArray = placesArray {
                self.user = placesArray
            }
            
        }
        setData()
        showDatePicker()
    }
    
    func setData(){
        self.textName.text = user.name
        self.textEmail.text = user.email
        self.textMobileNo.text = user.mobile
        if user.city_name.count > 0{
            self.lblSelectedCity.text = user.city_name
        }
        if user.area_name.count > 0{
            self.lblSelectedArea.text = user.area_name
        }
        
        textAddress.text = user.street
        
        if user.city_id.count > 0{
            self.getArea(city_id: user.city_id)
        }
        
        if user.area_name.count > 0{
            self.lblSelectedArea.text = self.user.area_name
        }
        if user.city_name.count > 0{
            self.lblSelectedCity.text = self.user.city_name
        }
        textPin.text = user.pincode
        
    }
    
    func getCurrentLocation(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
//        self.locationManager.requestAlwaysAuthorization()
//        
//        self.locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
        
    }
    
    func showDatePicker(){
       //Formate Date
       datePicker.datePickerMode = .date

      //ToolBar
      let toolbar = UIToolbar();
      toolbar.sizeToFit()
      let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
     let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

    toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

     textDateofBrith.inputAccessoryView = toolbar
     textDateofBrith.inputView = datePicker

    }
    
    @objc func donedatePicker(){

      let formatter = DateFormatter()
      formatter.dateFormat = "dd/MM/yyyy"
      textDateofBrith.text = formatter.string(from: datePicker.date)
      self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
                self.area_json = dict["data"]
                if dict["error"].stringValue == "false"{
                    self.area_list.removeAll()
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
    
    func updateUserData(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,
                           "type":"edit-profile",
                           "id":user.user_id,
                           "name":textName.text!,
                           "email":textEmail.text!,
                           "mobile":textMobileNo.text!,
                           "city_id": lblSelectedCity.text!,
                           "area_id": lblSelectedCity.text!,
                           "street": textAddress.text!,
                           "dob":textDateofBrith.text!,
                           "pincode": textPin.text!] as [String : Any]
        print(dictRequest)
        
        AF.request(REGISTRATION, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    
                    self.user.name = self.textName.text!
                    self.user.email = self.textEmail.text!
                    self.user.mobile = self.textMobileNo.text!
                    self.user.city_name = self.lblSelectedCity.text!
                    self.user.city_id = self.city_id
                    self.user.area_id = self.area_id
                    self.user.area_name = self.lblSelectedArea.text!
                    self.user.street = self.textAddress.text!
                    self.user.dob = self.textDateofBrith.text!
                    self.user.pincode = self.textPin.text!
                    let placesData = NSKeyedArchiver.archivedData(withRootObject: self.user)
                    userdefault.set(placesData, forKey: KEY_USER)
                    userdefault.synchronize()
                    if self.isSocial{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
                        let nav1 = UINavigationController(rootViewController: vc)
                        appDelegate.window?.rootViewController = nav1
                        appDelegate.window?.makeKeyAndVisible()
                    }else{
                        AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                    }
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
        isTap = true
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
            if self.isTap{
               self.textAddress.text = addressString
            }
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
    
    
    //MARK:- Btn Cliks
    
    @IBAction func actionRegister(_ sender: Any) {
        if textEmail.text!.count != 0 && lblSelectedArea.text! != "Select Area" && lblSelectedCity.text != "Select City" && textName.text!.count != 0 && textMobileNo.text!.count != 0 && textPin.text!.count != 0 && textAddress.text!.count != 0 {
            if isValidEmail(textEmail.text ?? ""){
                if textMobileNo.text!.count == 10{
                    if textPin.text?.count == 6{
                       self.updateUserData()
                    }else{
                        AppHelper.shared.showToast(message: "Please Enter Valid Pincode...", sender: self)
                    }
                    
                }else{
                     AppHelper.shared.showToast(message: Const.Enter_Valid_Number, sender: self)
                }
                
            }else{
                AppHelper.shared.showToast(message: "Please Enter Valid Email...", sender: self)
            }
            
        }else{
            AppHelper.shared.showToast(message: "Please Enter All Details...", sender: self)
        }
    }
    
    @IBAction func actionSelectCity(_ sender: UIButton) {
        if self.city_list.count > 0{
            KTOptionMenu(sender: sender, options: self.city_list, action: { index in
                self.lblSelectedCity.text = self.city_list[index]
                self.getArea(city_id: self.citys[index]["id"].stringValue)
            })
        }else{
            AppHelper.shared.showToast(message: "No Cities are available..", sender: self)
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
    
    @IBAction func actionUpdateLocation(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionLogout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout?", message: "Are you sure to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "refresh"), object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionChangePassword(_ sender: Any) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
