//
//  LanguageVC.swift
//  ABSHR
//
//  Created by mac on 06/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class LanguageVC: UIViewController {
    
    @IBOutlet weak var lblLogo: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    var isFromHome = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
       initView()
        lblLogo.setLocalize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblLanguage.setLocalize()
    }
    
    func initView(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:-  Btn Action
    
    @IBAction func actionEnglish(_ sender: Any) {
        userdefault.set(false, forKey: KEY_ISARABIC)
        DispatchQueue.main.async {
            setCurrentLang(str: "en")
        }
        if isFromHome{
            setVC()
//             self.navigationController?.popToRootViewController(animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectCategoryVC") as! SelectCategoryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setVC() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        let nav1 = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = nav1
        appDelegate.window?.makeKeyAndVisible()
        
    }
    

    @IBAction func actionArabic(_ sender: Any) {
        userdefault.set(true, forKey: KEY_ISARABIC)
        DispatchQueue.main.async {
            setCurrentLang(str: "ar-SA")
        }
        if isFromHome{
            setVC()
//            self.navigationController?.popToRootViewController(animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectCategoryVC") as! SelectCategoryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
