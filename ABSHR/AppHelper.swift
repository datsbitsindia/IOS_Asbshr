//
//  Apphelper.swift
//  
//
//  Created by mac on 03/09/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

public class AppHelper {
    
    public static let shared = AppHelper()
    var timer = Timer()
    
    private init() {
        
    }
    func showAlert(title: String, message: String, completion:( (_ result: Bool) -> Void)?) {
        let window :UIWindow = UIApplication.shared.keyWindow!
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: Const.ok, style: .default, handler: { (action) -> Void in
            completion!(false)
        })
        alert.addAction(ok)
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let window :UIWindow = UIApplication.shared.keyWindow!
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: Const.ok, style: .default, handler: nil)
        alert.addAction(ok)
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showLogoutAlert(title: String, message: String, completion:( (_ result: Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            completion!(true)
        }))
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController?.present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String, ok: String, cancel: String, completion:( (_ result: Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancel != "" {
            alert.addAction(UIAlertAction(title: cancel, style: .default, handler: nil))
        }
        if ok != "" {
            alert.addAction(UIAlertAction(title: ok, style: .default, handler: { (action) -> Void in
                completion!(true)
            }))
        }
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController?.present(alert, animated: true)
    }
    
    func showToast(message:String,sender:UIViewController) {
        let toastLabel = UILabel(frame: CGRect(x: sender.view.frame.size.width/2 - 150, y: sender.view.frame.size.height-100, width: 300, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.font = UIFont.systemFont(ofSize: 15)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 17
        toastLabel.clipsToBounds  =  true
        sender.view.addSubview(toastLabel)
        //        UIApplication.shared.windows[UIApplication.shared.windows.count - 1].addSubview(toastLabel)
        UIView.animate(withDuration: 5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

