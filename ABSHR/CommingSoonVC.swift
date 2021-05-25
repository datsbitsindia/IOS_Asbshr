//
//  CommingSoonVC.swift
//  ABSHR
//
//  Created by mac on 29/10/20.
//  Copyright © . All rights reserved.
//

import UIKit

class CommingSoonVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  //MARK:- Btn Cliks
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
