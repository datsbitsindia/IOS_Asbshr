//
//  OrderSummary.swift
//  ABSHR
//
//  Created by mac on 16/10/20.
//  Copyright © . All rights reserved.
//

import UIKit

class OrderSummary: UITableViewCell {
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductCount: UILabel!
    @IBOutlet weak var lblProductName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
