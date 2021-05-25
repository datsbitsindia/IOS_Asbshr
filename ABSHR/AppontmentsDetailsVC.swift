//
//  AppontmentsDetailsVC.swift
//  ABSHR
//
//  Created by mac on 27/10/20.
//  Copyright © . All rights reserved.
//

import UIKit
import SwiftyJSON
class AppontmentsDetailsVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
    var user = User()
    var app_details = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView(){
        DispatchQueue.main.async {
            if !UIDevice.current.hasNotch{
                self.viewHeaderHeight.constant = 66
            }
        }
        let placesData1 = UserDefaults.standard.object(forKey: KEY_USER) as? NSData
        if let placesData = placesData1 {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? User
            if let placesArray = placesArray {
                self.user = placesArray
            }
            
        }
        
        lblName.text = self.app_details["person_name"].stringValue
        lblEmail.text = self.app_details["email"].stringValue
        lblMobile.text = self.app_details["mobile_no"].stringValue
        lblPetName.text = self.app_details["name"].stringValue
        lblDescription.text = self.app_details["description"].stringValue
        
    }
    
    
    //MARK:- Btn Action
      @IBAction func actionBack(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
      }

}
