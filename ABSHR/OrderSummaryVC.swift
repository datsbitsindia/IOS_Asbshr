//
//  OrderSummaryVC.swift
//  ABSHR
//
//  Created by mac on 16/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
class OrderSummaryVC: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblPay: UILabel!
    @IBOutlet weak var lblDele: UILabel!
    @IBOutlet weak var BtnUpd: UIButton!
    @IBOutlet weak var btnEdit: UIView!
    @IBOutlet weak var lblCurr: UILabel!
    @IBOutlet weak var lblPromo: UILabel!
    @IBOutlet weak var lblDel: UILabel!
    @IBOutlet weak var lblsum: UILabel!
    @IBOutlet weak var lblsubtotal: UILabel!
    @IBOutlet weak var lbltax: UILabel!
    @IBOutlet weak var lblpromo: UILabel!
    @IBOutlet weak var lbldele: UILabel!
    @IBOutlet weak var btnApp: UIButton!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lbltotal: UILabel!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblMyLoc: UILabel!
    @IBOutlet weak var btnconfirm: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblStateAndCity: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var btnMyLocation: UIButton!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDelivaryCharge: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var txtPromoCode: UITextField!
    
    var cart_list = [CartItem]()
    var user = User()
    
    let locationManager = CLLocationManager()
    var isCurrent = Bool()
    var currentLocation = CLLocation()
    var selectedLocation = String()
    var promoDiscount = 0.0
    var totalAmount = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLocationHeight.constant = 0
        
        lblNavTitle.translateToarabic()
        getCurrentLocation()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setData()
    }
    func setlang(){
        [lblDel,lblPay,lblDele,lblAddress,lblStateAndCity,lblMobileNo,lblHome,lblWork,lblMyLoc,lblPromo,lblsum,lblsubtotal,lblSubTotal].forEach{
            $0.translateToarabic()
        }
        [lbltax,lblName,lblTax,lblpromo,lblPromoCode,lbldele,lblDelivaryCharge,lbltotal,lblTotalAmount,lbltitle].forEach{
            $0.translateToarabic()
        }
        [btnApp,btnconfirm].forEach{
            $0.translateToarabic()
        }
        [txtPromoCode].forEach{
            $0.translateToarabic()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        tableViewHeight.constant = tableView.contentSize.height + 40
    }
    
    func initView(){
        DispatchQueue.main.async {
            if !UIDevice.current.hasNotch{
                self.viewHeaderHeight.constant = 66
            }
        }
        let placesData = UserDefaults.standard.object(forKey: KEY_USER) as? NSData
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? User
            if let placesArray = placesArray {
                self.user = placesArray
            }
            
        }
        self.setData()
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
    
    func setData(){
        lblName.text = user.name
        lblAddress.text = "\(user.area_name),"
        lblStateAndCity.text = "\(user.street),\(user.city_name)"
        lblMobileNo.text = "\("Mobile No : ".localized())\(user.mobile)"
        self.lblCurrentLocation.text = addressString
        
        var total = Double()
        for i in 0..<cart_list.count{
            total = total + (Double(self.cart_list[i].price)! * Double(self.cart_list[i].count)!)
        }
        
        if promoDiscount > 0{
            self.lblPromoCode.text = "- QAR \(promoDiscount.rounded(toPlaces: 2))"
        }else{
            self.lblPromoCode.text = "- QAR \(promoDiscount.rounded(toPlaces: 2))"
        }
        
        if total > 500 {
            lblSubTotal.text = "QAR \(total.rounded(toPlaces: 1))"
            lblDelivaryCharge.text = "+ QAR 0.00"
            lblTax.text = "+ QAR \(Double(total)*0.1.rounded(toPlaces: 1))"
            self.totalAmount = total+(Double(total)*0.1.rounded(toPlaces: 1))
            lblTotalAmount.text = "\(total+(Double(total)*0.1.rounded(toPlaces: 1)) - promoDiscount)"
        }else{
            lblSubTotal.text = "QAR \(total.rounded(toPlaces: 1))"
            lblDelivaryCharge.text = "QAR 30.00"
            lblTax.text = "+ QAR \(Double(total)*0.1.rounded(toPlaces: 1))"
            self.totalAmount = total+(Double(total)*0.1)+30
            let amount = total+(Double(total)*0.1)+30-promoDiscount
            lblTotalAmount.text = "QAR \(amount.rounded(toPlaces: 1))"
        }
        setlang()
        
    }
    
    func checkPromoCode(code:String,total:Double){
        SVProgressHUD.show()
        //validate_promo_code = 1
        //user_id=user_id
        //promo_code=promo_code
        //total=total
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,
                           "user_id":user.user_id,
                           "validate_promo_code":1,
                           "promo_code":code,
                           "total":total] as [String : Any]
        print(dictRequest)
        
        AF.request(PROMO_CODE, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    let dis = dict["discount"].doubleValue
                    self.promoDiscount = dis
                    AppHelper.shared.showToast(message: "Promo Code Apply Successfully..", sender: self)
//                    self.setData()
                }else{
                    self.lblPromoCode.text = ""
                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                }
                self.setData()
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
            self.lblCurrentLocation.text = addressString
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
    
    //MARK:- Tableview Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cart_list.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OrderSummary
        cell.lblProductName.text = self.cart_list[indexPath.row].name
        cell.lblPrice.text = "QAR \(self.cart_list[indexPath.row].price)"
        cell.lblProductCount.text = self.cart_list[indexPath.row].count
        cell.lblTotalPrice.text = "QAR \((Int(self.cart_list[indexPath.row].price)! * Int(self.cart_list[indexPath.row].count)!)).00"
        [cell.lblProductName,cell.lblTotalPrice,cell.lblPrice,cell.lblProductCount].forEach{
            $0?.translateToarabic()
        }
        return cell
       }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 35)
        headerView.backgroundColor = UIColor.clear
        
        let lblTotal = UILabel.init(frame: CGRect.init(x: tableView.frame.width-80, y: 0, width: 80, height: 35))
        lblTotal.text = "Subtotal".localized()
        lblTotal.font = .systemFont(ofSize: 15)
        lblTotal.textColor = UIColor.darkGray
        lblTotal.textAlignment = .center
        
        let lblPrice = UILabel.init(frame: CGRect.init(x: tableView.frame.width-(80+60), y: 0, width: 55, height: 35))
        lblPrice.text = "Price".localized()
        lblPrice.font = .systemFont(ofSize: 15)
        lblPrice.textColor = UIColor.darkGray
        lblPrice.textAlignment = .center
        
        let lblCount = UILabel.init(frame: CGRect.init(x: tableView.frame.width-(80+55+45), y: 0, width: 35, height: 35))
        lblCount.text = "Qty".localized()
        lblCount.font = .systemFont(ofSize: 15)
        lblCount.textColor = UIColor.darkGray
        lblCount.textAlignment = .center
        
        let lblName = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width-(80+55+35), height: 35))
        lblName.text = "Product Name".localized()
        lblName.font = .systemFont(ofSize: 15)
        lblName.textColor = UIColor.darkGray
        lblName.textAlignment = .left
        
        headerView.addSubview(lblTotal)
        headerView.addSubview(lblPrice)
        headerView.addSubview(lblCount)
        headerView.addSubview(lblName)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
       
    
    //MARK:- Btn Actions
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionHome(_ sender: UIButton) {
        btnWork.isSelected = false
        btnHome.isSelected = sender.isSelected ? false : true
    }
    
    @IBAction func actionWork(_ sender: UIButton) {
        btnHome.isSelected = false
        btnWork.isSelected = sender.isSelected ? false : true
    }
    
    @IBAction func actionMyLocation(_ sender: UIButton) {
        btnMyLocation.isSelected = sender.isSelected ? false : true
        viewLocationHeight.constant = sender.isSelected ? 275 : 0
    }
    
    @IBAction func actionUpdateLocation(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionEditAddress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        if user.user_id.count > 0 && user.area_name.count > 0 && user.mobile.count > 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProccedOrderVC") as! ProccedOrderVC
            vc.cart_list = self.cart_list
            if btnMyLocation.isSelected{
               vc.address = addressString
            }else{
                vc.address = "\(lblAddress.text!) \n \(lblStateAndCity.text!)"
            }
            vc.promoDiscount = self.promoDiscount
            vc.promoCode = self.txtPromoCode.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            AppHelper.shared.showToast(message: "Please fill Profile Details", sender: self)
        }
        
    }
    
    @IBAction func actioPromoCode(_ sender: Any) {
        if txtPromoCode.text!.count > 0{
            self.promoDiscount = 0.0
            self.checkPromoCode(code:txtPromoCode.text! , total: self.totalAmount)
        }else{
            AppHelper.shared.showToast(message: "Please Enter Valid Code.", sender: self)
        }
    }
    
    @IBAction func actionRefresh(_ sender: Any) {
        self.lblPromoCode.text = ""
        self.promoDiscount = 0.0
        self.setData()
    }
    
    
}
