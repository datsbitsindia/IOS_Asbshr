//
//  cvcStoreList.swift
//  ABSHR
//
//  Created by Kishan Suthar on 15/01/21.
//  Copyright © 2021 skyinfos. All rights reserved.
//

import UIKit

class cvcStoreList: UICollectionViewCell {
    
    
    @IBOutlet weak var btnCatName: UIButton!
    @IBOutlet weak var lblCatName: UILabel!
    @IBOutlet weak var ivSlider: UIImageView!
  
    
    override func awakeFromNib() {
        ivSlider.layer.cornerRadius = ivSlider.frame.height / 2
        ivSlider.clipsToBounds = true
        btnCatName.layer.cornerRadius = btnCatName.frame.height / 2
    }
    
}
