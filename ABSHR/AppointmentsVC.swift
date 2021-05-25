//
//  AppointmentsVC.swift
//  ABSHR
//
//  Created by mac on 26/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import Alamofire
import SwiftyJSON

class AppointmentsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    

    var appointmentsList = JSON.null
    var user = User()
    
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
                self.getAppointMents()
            }
            
        }
        collectionView.register(UINib.init(nibName: "AppointmentsCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    func checkData(){
        if appointmentsList.count > 0{
            self.collectionView.isHidden = false
        }else{
            self.collectionView.isHidden = true
        }
    }
    
    func getAppointMents(){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"get-appointment":1,"user_id":user.user_id] as [String : Any]
        print(dictRequest)
        
        AF.request(GET_DOCTORS, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    self.appointmentsList = dict["data"]
                    
                }else{
//                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                }
                self.checkData()
                self.collectionView.reloadData()
                print(dict)
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
            }
        }
    }
    
    //MARK:- CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointmentsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AppointmentsCell
        cell.viewContent.frame.size.width = (collectionView.frame.size.width-16)
        cell.viewContent.frame.size.height = 120
        cell.lblAppointmetsNo.text = self.appointmentsList[indexPath.row]["id"].stringValue
        cell.lblDate.text = self.appointmentsList[indexPath.row]["date_added"].stringValue
        cell.lblPatCategory.text = self.appointmentsList[indexPath.row]["name"].stringValue
        cell.lblStatus.text = self.appointmentsList[indexPath.row]["status"].stringValue
        cell.lblDescription.text = self.appointmentsList[indexPath.row]["description"].stringValue
        cell.shadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (collectionView.frame.size.width-16), height: 120)
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppontmentsDetailsVC") as! AppontmentsDetailsVC
        vc.app_details = self.appointmentsList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Btn Action
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
