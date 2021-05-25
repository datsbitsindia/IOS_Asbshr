//
//  DrowerCell.swift
//  Shareit
//
//  Created by jksol on 24/07/20.
//  Copyright © 2020 jksol. All rights reserved.
//

import UIKit

class DrowerCell: UITableViewCell {
  
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var imgIcon2: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
