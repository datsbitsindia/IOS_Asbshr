//
//  TrackOrderCell.swift
//  ABSHR
//
//  Created by mac on 21/10/20.
//  Copyright © . All rights reserved.
//

import UIKit

class TrackOrderCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnViewDetails: UIButton!
    
    @IBOutlet weak var btnOrderPlaced: UIButton!
    @IBOutlet weak var btnOrderProcessed: UIButton!
    @IBOutlet weak var btnOrderShipped: UIButton!
    @IBOutlet weak var btnOrderDelivered: UIButton!
    
    @IBOutlet weak var lblOrderPlaced: UILabel!
    @IBOutlet weak var lblOrderProcessed: UILabel!
    @IBOutlet weak var lblOrderShipped: UILabel!
    @IBOutlet weak var lblOrderDelivered: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewStatusHeight: NSLayoutConstraint!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData[tableView.tag]["items"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrackOrderTCV
        cell.lblProductName.text = listData[tableView.tag]["items"][indexPath.row]["name"].stringValue
        cell.lblCount.text = "Qty: \(listData[tableView.tag]["items"][indexPath.row]["quantity"].stringValue) \(listData[tableView.tag]["items"][indexPath.row]["unit"].stringValue)"
        let price = Int(listData[tableView.tag]["items"][indexPath.row]["quantity"].stringValue)! * listData[tableView.tag]["items"][indexPath.row]["price"].intValue
        cell.lblPrice.text = "QAR \(price).0"
        cell.lblVia.text = "Via \(listData[tableView.tag]["payment_method"].stringValue.uppercased())"
        cell.lblStatus.text = listData[tableView.tag]["items"][indexPath.row]["active_status"].stringValue.capitalized
        cell.imgProduct.sd_setImage(with: URL.init(string: listData[tableView.tag]["items"][indexPath.row]["image"].stringValue), placeholderImage: UIImage.init(named: "placeholder"), options:[.refreshCached], context: nil)
        
        if listData[tableView.tag]["items"][indexPath.row]["active_status"].stringValue.capitalized == "Cancelled"{
            cell.lblStatus.textColor = UIColor.red
        }else{
            cell.lblStatus.textColor = UIColor.darkGray
        }
//        tableViewHeight.constant = tableView.contentSize.height
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


class TrackOrderTCV: UITableViewCell {
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblVia: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    
}
