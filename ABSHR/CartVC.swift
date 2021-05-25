//
//  CartVC.swift
//  ABSHR
//
//  Created by mac on 08/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class CartVC: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet weak var lbltot: UILabel!
    @IBOutlet weak var lblsub: UILabel!
    @IBOutlet weak var lblCheckout: UILabel!
    @IBOutlet weak var lblDel: UILabel!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblUrcart: UILabel!
    @IBOutlet weak var lblkets: UILabel!
    @IBOutlet weak var btnshop: UIButton!
    @IBOutlet weak var lblSubPrice: UILabel!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalItems: UILabel!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    
    @IBOutlet weak var btnBackGo: UIButton!
    
    var cart_list = [CartItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        if getCurrentLang() == "ar-SA" {
            btnBackGo.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let placesData = NSKeyedArchiver.archivedData(withRootObject: self.cart_list)
        userdefault.set(placesData, forKey: KEY_CART)
        userdefault.synchronize()
    }
    
    func initView(){
        [lblUrcart,lblkets,lblTitle].forEach{
            $0?.setLocalize()
        }
        [btnshop].forEach{
            $0?.setLocalize()
        }
        DispatchQueue.main.async {
            if !UIDevice.current.hasNotch{
                self.viewHeaderHeight.constant = 66
            }
        }
        
        let placesData = UserDefaults.standard.object(forKey: KEY_CART) as? NSData
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [CartItem]
            if let placesArray = placesArray {
                self.cart_list = placesArray
            }
            
        }
        collectionView.register(UINib.init(nibName: "ProductCell1", bundle: nil), forCellWithReuseIdentifier: "cell")
        viewBottom.shadow()
        self.setupData()
    }
    
    func setupData(){
        var total = Int()
        for i in 0..<cart_list.count{
            total = total + (Int(self.cart_list[i].price)! * Int(self.cart_list[i].count)!)
        }
        
        if total > 500 {
            lblSubPrice.text = "QAR \(total).00"
            lblDeliveryCharge.text = "QAR 0.00"
            lblTotalPrice.text = "QAR \(total).00"
        }else{
            lblSubPrice.text = "QAR \(total).00"
            lblDeliveryCharge.text = "QAR 30.00"
            lblTotalPrice.text = "QAR \(total + 30).00"
        }
        lblTotalItems.text = "Total \(cart_list.count) Item QAR \(total).00"
        
        if cart_list.count > 0{
            viewEmpty.isHidden = true
        }else{
            viewEmpty.isHidden = false
        }
        [lblTotalPrice,lbltot,lblDel,lblDeliveryCharge,lblsub,lblSubPrice,lblCheckout,lblTotalItems].forEach{
            $0?.translateToarabic()
        }
    }
    
    @objc func actionPlus(_ sender:UIButton){
        let total = Int(self.cart_list[sender.tag].count)! + 1
        self.cart_list[sender.tag].count = "\(total)"
        self.setupData()
        self.collectionView.reloadData()
    }
    
    @objc func actionMinus(_ sender:UIButton){
        if Int(self.cart_list[sender.tag].count)! > 1{
            let total = Int(self.cart_list[sender.tag].count)! - 1
            self.cart_list[sender.tag].count = "\(total)"
            self.setupData()
            self.collectionView.reloadData()
        }
    }
    
    @objc func actionClose(_ sender:UIButton){
        let alert = UIAlertController(title: "Remove Product".localized(), message: "Are you sure,you want to remove this product from cart?".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: .default, handler: { _ in
            self.cart_list.remove(at: sender.tag)
            self.collectionView.reloadData()
            self.setupData()
            let placesData = NSKeyedArchiver.archivedData(withRootObject: self.cart_list)
            userdefault.set(placesData, forKey: KEY_CART)
            userdefault.synchronize()
        }))
        alert.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCheckout(_ sender: Any) {
        if !userdefault.bool(forKey: KEY_ISLOGIN){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav1 = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = nav1
            appDelegate.window?.makeKeyAndVisible()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderSummaryVC") as! OrderSummaryVC
            vc.cart_list = self.cart_list
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    @IBAction func actionShopNow(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK:- Collectionview Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cart_list.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell1
        cell.viewContent.frame.size.width = collectionView.frame.size.width-8
        cell.viewContent.frame.size.height = 130
        cell.imgProduct.sd_setImage(with: URL.init(string: self.cart_list[indexPath.row].image), placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached], context: nil)
        cell.lblTitle.text = self.cart_list[indexPath.row].name
        cell.lblDescription.text = "\(self.cart_list[indexPath.row].mesurment) QAR \(self.cart_list[indexPath.row].price).00"
        cell.lblCount.text = "X \(self.cart_list[indexPath.row].count)"
        let t_price = Int(self.cart_list[indexPath.row].price)! * Int(self.cart_list[indexPath.row].count)!
        cell.lblTotalPrice.text = "QAR \(t_price).00"
        if self.cart_list[indexPath.row].discount.count > 1{
            cell.viewDiscount.isHidden = false
            cell.lblDiscount.text = self.cart_list[indexPath.row].discount
        }else{
            cell.viewDiscount.isHidden = true
        }
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(actionPlus(_:)), for: .touchUpInside)
        cell.btnMinus.tag = indexPath.row
        cell.btnMinus.addTarget(self, action: #selector(actionMinus(_:)), for: .touchUpInside)
        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(actionClose(_:)), for: .touchUpInside)
        [cell.lblDescription,cell.lblDiscount,cell.lblCount,cell.lblTitle,cell.lblTotalPrice].forEach{
            $0.translateToarabic()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (collectionView.frame.size.width-8), height: 130)
    }

}
