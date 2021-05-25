//
//  SliderVC.swift
//  ABSHR
//
//  Created by mac on 06/11/20.
//  Copyright © . All rights reserved.
//

import UIKit
import ImageSlideshow
import AlamofireImage

class SliderVC: UIViewController,ImageSlideshowDelegate{

    @IBOutlet weak var slideShow: ImageSlideshow!
    
    var slider1 = [AlamofireSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlideShow()
        // Do any additional setup after loading the view.
    }
    
    func setupSlideShow(){
//        var slider = self.slider1
        
        slideShow.layer.cornerRadius = 12
        slideShow.clipsToBounds = true
        slideShow.inputView?.layer.cornerRadius = 12
        slideShow.slideshowInterval = 5.0
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = App_Color
        pageControl.pageIndicatorTintColor = UIColor.gray
        slideShow.pageIndicator = pageControl
        
        slideShow.activityIndicator = DefaultActivityIndicator()
        slideShow.delegate = self
        slideShow.setImageInputs(self.slider1)
        
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
