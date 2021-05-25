//
//  SuccessfullyVC.swift
//  ABSHR
//
//  Created by mac on 29/10/20.
//  Copyright © . All rights reserved.
//

import UIKit

class SuccessfullyVC: UIViewController {
    
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
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
    }
//MARK:- Btn Cliks
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actionContinueShop(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func actionViewDetails(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentVC") as! ContentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
