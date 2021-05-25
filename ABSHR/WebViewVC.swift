//
//  WebViewVC.swift
//  ABSHR
//
//  Created by mac on 19/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class WebViewVC: UIViewController,WKNavigationDelegate{
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnBackGo: UIButton!
    
    var fileURL = String()
    var titleName = String()
    var type = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

//        lblTitle.setLocalize()
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
        initView()
    }
    
    func initView(){
        DispatchQueue.main.async {
            if !UIDevice.current.hasNotch{
                self.viewHeaderHeight.constant = 66
            }
        }
        lblTitle.text = titleName.localized()
        if type == 1{
            self.getData(type: "get_privacy")
        }else if type == 2{
            self.getData(type: "get_terms")
        }else if type == 3{
//            https://zikzok.me/pages_web/faq.php
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.navigationDelegate = self
//             webView.load(URLRequest(url: "url"))
            if let url = URL(string: FAQ) {
                SVProgressHUD.show()
                webView.load(URLRequest(url: url))
            }
        }else if type == 4{
            self.getData(type: "get_about_us")
        }else if type == 5{
            self.getData(type: "get_contact")
        }else{
            
        }
        
    }
    
    func getData(type:String){
        SVProgressHUD.show()
        let header:HTTPHeaders = [.authorization(bearerToken: TOKEN)]
        let dictRequest = ["accesskey":90336,"settings":1,type:1] as [String : Any]
        print(dictRequest)
        
        AF.request("https://my.abshr.online/api-firebase/settings.php", method:.post,parameters: dictRequest, headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let dict = JSON(value)
                SVProgressHUD.dismiss()
                if dict["error"].stringValue == "false"{
                    if type == "get_privacy"{
                        self.webView.loadHTMLString("<html><body>\(dict["privacy"].stringValue)</body></html>", baseURL: nil)
                    }else if type == "get_terms"{
                        self.webView.loadHTMLString("<html><body>\(dict["terms"].stringValue)</body></html>", baseURL: nil)
                    }else if type == "get_about_us"{
                        self.webView.loadHTMLString("<html><body>\(dict["about"].stringValue)</body></html>", baseURL: nil)
                    }else{
                        self.webView.loadHTMLString("<html><body>\(dict["contact"].stringValue)</body></html>", baseURL: nil)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        print("Finished navigating to url \(webView.url)")
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
