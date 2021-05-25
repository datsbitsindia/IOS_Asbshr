//
//  ViewController.swift
//  ABSHR
//
//  Created by mac on 05/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class SplashVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var i = Int()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        getCurrentLocation()
        
        lblTitle.setLocalize()
    }
    
    func getCurrentLocation(){
//      let generator = UIImpactFeedbackGenerator(style: .heavy)
//      generator.impactOccurred()

//      self.locationManager.requestAlwaysAuthorization()

//      self.locationManager.requestWhenInUseAuthorization()

      if CLLocationManager.locationServicesEnabled() {
          locationManager.delegate = self
//          locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//          locationManager.startUpdatingLocation()
      }
      
    }
    
    func initView(){
        self.navigationController?.navigationBar.isHidden = true
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.i = self.i + 1
            print(self.i)
            if self.i >= 3{
                timer.invalidate()
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
//                let nav1 = UINavigationController(rootViewController: vc)
//                appDelegate.window?.rootViewController = nav1
//                appDelegate.window?.makeKeyAndVisible()
                if userdefault.bool(forKey: KEY_FIRSTTIME){
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectCategoryVC") as! SelectCategoryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
//                    let nav1 = UINavigationController(rootViewController: vc)
//                    appDelegate.window?.rootViewController = nav1
//                    appDelegate.window?.makeKeyAndVisible()

                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
    }
    
    //MARK:- Location Delegate
     
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        print(location)
        lat = "\(locValue.latitude)"
        long = "\(locValue.longitude)"
        locationManager.stopUpdatingLocation()
    }
    
}

