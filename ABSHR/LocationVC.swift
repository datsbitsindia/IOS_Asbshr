//
//  LocationVC.swift
//  ABSHR
//
//  Created by mac on 15/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

class LocationVC: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{
   

    @IBOutlet weak var btnBackGo: UIButton!
    @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var toolBarHeight: NSLayoutConstraint!
  @IBOutlet weak var viewMap: UIView!
  @IBOutlet weak var btnAddLocation: UIButton!
  
  var cityList = [String]()
  var dic = [[String : Any]]()
  var mapView = GMSMapView()
  let locationManager = CLLocationManager()
  var isCurrent = Bool()
  var currentLocation = CLLocation()
  var selectedLocation = String()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if getCurrentLang() == "ar-SA" {
        btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
    }
    
    getCurrentLocation()
    self.initView()
    
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
  
  func initView(){
    DispatchQueue.main.async {
        if !UIDevice.current.hasNotch{
            self.toolBarHeight.constant = 66
        }
    }
    btnAddLocation.layer.cornerRadius = 15
    mapView.frame = self.view.frame
    self.btnAddLocation.isHidden = false
    mapView.delegate = self
    mapView.isMyLocationEnabled = true
    self.viewMap.addSubview(mapView)
    self.view.layoutIfNeeded()
    btnAddLocation.setLocalize()
  }
    
    //MARK:- Btn Clicks
    
  @IBAction func btnClicks(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func actionAddLocation(_ sender: UIButton) {
//    locationAddress = selectedLocation
     NotificationCenter.default.post(name: Notification.Name("refresh"), object: nil)
    self.navigationController?.popViewController(animated: true)
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
        print(coordinate.latitude)
        print(coordinate.longitude)
        lat = "\(coordinate.latitude)"
        long = "\(coordinate.longitude)"
        addressString = self.selectedLocation
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

}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?,_ state: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country,$0?.first?.administrativeArea, $1) }
    }
}
