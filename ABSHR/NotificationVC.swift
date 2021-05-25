//
//  NotificationVC.swift
//  ABSHR
//
//  Created by mac on 27/10/20.
//  Copyright © . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
class NotificationVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
    var list = JSON.null
    
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
        getNotificationList()
//        checkData()
    }
    
    func checkData(){
      if listData.count == 0{
          collectionView.isHidden = true
      }else{
          collectionView.isHidden = false
      }
    }
    
    func getNotificationList(){
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"get-notifications":1] as [String : Any]
        print(dictRequest)
        
        AF.request(SECTIONS, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    self.list = dict["data"]
                    
                }else{
//                    AppHelper.shared.showToast(message: dict["message"].stringValue, sender: self)
                }
                self.collectionView.reloadData()
                self.checkData()
                print(dict)
            case .failure(let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                AppHelper.shared.showToast(message: Const.tryAgain, sender: self)
                self.collectionView.reloadData()
                self.checkData()
            }
        }
    }
    
    //MARK:- Btn Cliks
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    //MARK:- CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NotificationCell
        cell.viewContent.frame.size.width = (collectionView.frame.size.width-8)
        cell.viewContent.frame.size.height = 90
        cell.lblTitle.text = list[indexPath.row]["title"].stringValue
        cell.lblMessage.text = list[indexPath.row]["message"].stringValue
        cell.shadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (collectionView.frame.size.width-8), height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
