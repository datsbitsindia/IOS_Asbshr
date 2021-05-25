//
//  TreackOrderVC.swift
//  ABSHR
//
//  Created by mac on 21/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import PageMenu
import Alamofire
import SwiftyJSON
import SVProgressHUD
class TreackOrderVC: UIViewController,CAPSPageMenuDelegate {
    
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
    var controllerArray : [UIViewController] = []
    var pageMenu : CAPSPageMenu!
    var tabbarList = ["All","In-Process","Shipped","Delivered"]
    var listData = [JSON.null]
    var listDataAll = JSON.null
    var listDataInProcess = JSON.null
    var listDataShipped = JSON.null
    var listDataDelivered = JSON.null
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
                self.getOrderList()
            }
            
        }
        
    }
    
    func setupView(){
        for i in 0..<4{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentVC") as! ContentVC
            vc.title = tabbarList[i]
            controllerArray.append(vc)
        }
        
    // Initialize scroll menu
        
        let parameters: [CAPSPageMenuOption] = [
            .selectedMenuItemLabelColor(App_Color),
            .menuMargin(0),
            .menuItemSeparatorWidth(0),
            .menuItemWidth(viewInner.frame.size.width/4),
            .menuItemFont(UIFont.boldSystemFont(ofSize: 15)),
            .menuItemSeparatorRoundEdges(false),
            .enableHorizontalBounce(false),
            .selectionIndicatorColor(App_Color),
            .menuHeight(45)]
        
        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.viewInner.frame.width, height: self.viewInner.frame.height), pageMenuOptions: parameters)
        
        self.pageMenu.delegate = self
        viewInner.addSubview(self.pageMenu!.view)
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            for i in 0..<self.controllerArray.count{
                self.controllerArray[i].view.frame = CGRect(x: 0.0, y: 45, width: self.viewInner.frame.width, height: self.viewInner.frame.height-(45) )
            }
            self.viewInner.layoutIfNeeded()
        })
    }
    
    func getOrderList(){
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"get_orders":"1","user_id":self.user.user_id] as [String : Any]
        print(dictRequest)
        
        AF.request(ORDER_PROCESS, method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    self.listDataAll = dict["data"]
                    for i in 0..<self.listDataAll.count{
                        if self.listDataAll[i]["active_status"] == "received"{
//                            self.listData.append(self.listDataAll[i])
                        }else if self.listDataAll[i]["active_status"] == "received"{
                            
                        }else if self.listDataAll[i]["active_status"] == "received"{
                            
                        }else{
                            
                        }
                    }
                    self.setupView()
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
    
    //MARK:- Btn Cliks
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
