//
//  UIKit+Extension.swift
//
//
//  Created by mac on 03/09/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift
var parentView = UIView()

var mainAction: ((Int) -> Void)?

extension UIViewController {
    
    func KTOptionMenu(sender:UIButton,options:[String], action: @escaping (Int) -> Void) {
        
        parentView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let dismissButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dismissButton.addTarget(self, action: #selector(dissmissViewAction), for: .touchUpInside)
        parentView.addSubview(dismissButton)
        
        let buttonLocation = sender.convert(sender.bounds, to: self.view)
        print(buttonLocation)
        
        let mainView = UIView()
        mainView.layer.cornerRadius = 5
        mainView.frame = CGRect.init(x: (buttonLocation.origin.x + sender.frame.width) - 150, y: buttonLocation.origin.y, width: 150, height: CGFloat(50 * options.count))
        mainView.backgroundColor = UIColor.white
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowOpacity = 0.1
        mainView.layer.masksToBounds = false
        
        
        for i in 0..<options.count {
            
            let button = UIButton.init(frame: CGRect.init(x: 16, y: 50 * i, width: 150 - 32, height: 50))
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitle(options[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.contentHorizontalAlignment = .left
            button.tag = i
            mainAction = action
            button.addTarget(self, action: #selector(didPress(_:)), for: .touchUpInside)
            mainView.addSubview(button)
        }
        parentView.addSubview(mainView)
        self.view.addSubview(parentView)
        
        parentView.isHidden = false
        
    }
    
    @objc func didPress(_ sender:UIButton) {
        dismissOptionMenu()
        mainAction?(sender.tag)
    }
    
    
    
    func dismissOptionMenu() {
        for view in parentView.subviews {
            view.removeFromSuperview()
        }
        
        parentView.isHidden = true
    }
    
    @objc func dissmissViewAction() {
        
        dismissOptionMenu()
        
    }
    
}


extension UIView {
  
  func borderWithCorner(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
    self.layer.cornerRadius = cornerRadius
    self.layer.borderWidth = borderWidth
    self.layer.borderColor = borderColor.cgColor
  }
  
  @IBInspectable var borderColor: UIColor? {
    get {
      return layer.borderColor.map { UIColor(cgColor: $0) }
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  func aspectRation(_ ratio: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0)
  }
  
  func aspectRation1(_ ratio: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
  }
  
  public func createImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
    defer { UIGraphicsEndImageContext()
      
    }
    if let context = UIGraphicsGetCurrentContext() {
      self.layer.render(in: context)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      return image!
      
    }
    return UIImage()
    
  }
  
  func subViews<T : UIView>(type : T.Type) -> [T]{
    var all = [T]()
    for view in self.subviews {
      if let aView = view as? T{
        all.append(aView)
      }
    }
    return all
  }
  
  func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
    var all = [T]()
    func getSubview(view: UIView) {
      if let aView = view as? T{
        all.append(aView)
      }
      guard view.subviews.count>0 else { return }
      view.subviews.forEach{ getSubview(view: $0) }
    }
    getSubview(view: self)
    return all
  }
  
  func animShow(){
    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                   animations: {
                    self.center.y -= self.bounds.height
                    self.layoutIfNeeded()
    }, completion: nil)
    self.isHidden = false
  }
  func animHide(){
    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                   animations: {
                    self.center.y += self.bounds.height
                    self.layoutIfNeeded()
                    
    },  completion: {(_ completed: Bool) -> Void in
      self.isHidden = true
    })
  }
  
  func applyGradient(colours: [UIColor],width:CGFloat) {
    let gradient = CAGradientLayer()
    gradient.colors = colours.map { $0.cgColor }
    gradient.locations = [0.0,0.5,1.0]
    gradient.frame = CGRect(x: 0, y: 0, width:width, height:self.bounds.height)
    gradient.startPoint = CGPoint(x: 0, y: 1)
    gradient.endPoint = CGPoint(x: 1, y: 1)
    self.layer.insertSublayer(gradient, at: 0)
  }
    
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  func shadow() {
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.lightGray.cgColor
    self.layer.shadowOpacity = 0.5
    self.layer.shadowOffset =  CGSize(width: 0, height: 2)
    self.layer.shadowRadius = 1.5
  }
    
    func shadow1() {
      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor.lightGray.cgColor
      self.layer.shadowOpacity = 1
      self.layer.shadowOffset =  CGSize(width: 0, height: 1)
      self.layer.shadowRadius = 1.0
    }
    
    func applyGradient(isVertical: Bool, colorArray: [UIColor],frame:CGRect) {
       layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
        
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = colorArray.map({ $0.cgColor })
       if isVertical {
           //top to bottom
           gradientLayer.locations = [0.0, 1.0]
       } else {
           //left to right
           gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
           gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
       }
       
       backgroundColor = .clear
       gradientLayer.frame = bounds
       layer.insertSublayer(gradientLayer, at: 0)
   }
  
}

extension UIImageView{
  func load(url: URL) {
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
    }
  }
}

extension UIImage {
  func tinted(with color: UIColor) -> UIImage? {
    UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
      color.set()
      withRenderingMode(.alwaysTemplate).draw(at: .zero)
    }
  }
  
  func imageWithInsets(insetDimen: CGFloat) -> UIImage {
    return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
  }
  
  func imageWithInset(insets: UIEdgeInsets) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(
      CGSize(width: self.size.width + insets.left + insets.right,
             height: self.size.height + insets.top + insets.bottom), false, self.scale)
    let origin = CGPoint(x: insets.left, y: insets.top)
    self.draw(at: origin)
    let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return imageWithInsets!
  }
  
}



extension UILabel {
  func textWidth() -> CGFloat {
    return UILabel.textWidth(label: self)
  }
  
  class func textWidth(label: UILabel) -> CGFloat {
    return textWidth(label: label, text: label.text!)
  }
  
  class func textWidth(label: UILabel, text: String) -> CGFloat {
    return textWidth(font: label.font, text: text)
  }
  
  class func textWidth(font: UIFont, text: String) -> CGFloat {
    let myText = text as NSString
    
    let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    return ceil(labelSize.width)
  }
    
    func setLocalize(){
        if self.textAlignment != .center && Localize.currentLanguage() == "ar-SA"{
            self.textAlignment = .right
        }
        self.text = text?.localized()
    }
    
    func translateToarabic(){
        let trans = TranslatorManager()
        if getCurrentLang() == "ar-SA"{
            if self.textAlignment != .center && Localize.currentLanguage() == "ar-SA"{
                self.textAlignment = .right
            }
            trans.translateText(text: self.text ?? "") { (str) in
                self.text = str
            }
//            TranslatorManager.shared.translateText(text: self.text ?? "") { (str) in
//                self.text = str
//            }
        }
    }
}

extension UITextField{
    func setLocalize(){
        if self.textAlignment != .center && Localize.currentLanguage() == "ar-SA"{
            self.textAlignment = .right
        }
        self.placeholder = placeholder?.localized()
    }
    func translateToarabic(){
        
        let trans = TranslatorManager()
        
        if getCurrentLang() == "ar-SA"{
            if self.textAlignment != .center && Localize.currentLanguage() == "ar-SA"{
                self.textAlignment = .right
            }
//            TranslatorManager.shared.translateText(text: self.placeholder ?? "") { (str) in
//                self.placeholder = str
//            }
            trans.translateText(text: self.placeholder ?? "") { (str) in
                self.placeholder = str
            }
        }
    }
}
extension UITextView{
    func setLocalize(){
        if self.textAlignment != .center && Localize.currentLanguage() == "ar-SA"{
            self.textAlignment = .right
        }
        self.text = text?.localized()
    }
    func translateToarabic(){
        
        let trans = TranslatorManager()
        
        if getCurrentLang() == "ar-SA"{
            if self.textAlignment != .center && Localize.currentLanguage() == "ar-SA"{
                self.textAlignment = .right
            }
//            TranslatorManager.shared.translateText(text: self.text ?? "") { (str) in
//                self.text = str
//            }
            trans.translateText(text: self.text ?? "") { (str) in
                self.text = str
            }
        }
    }
}
extension UIButton{
    func setLocalize(){
        if self.contentHorizontalAlignment != .center && Localize.currentLanguage() == "ar-SA"{
            self.contentHorizontalAlignment = .right
        }
        self.setTitle(self.titleLabel?.text?.localized() ?? "", for: .normal)
    }
    
    func translateToarabic(){
        
        let trans = TranslatorManager()
        
        if self.contentHorizontalAlignment != .center && Localize.currentLanguage() == "ar-SA"{
            self.contentHorizontalAlignment = .right
        }
        //        TranslatorManager.shared.translateText(text: self.titleLabel?.text ?? "") { (str) in
        //            self.setTitle(str, for: .normal)
        //        }
        trans.translateText(text: self.titleLabel?.text ?? "") { (str) in
            self.setTitle(str, for: .normal)
        }
    }
    }

extension Date {
  static var yesterday: Date { return Date().dayBefore }
  static var tomorrow:  Date { return Date().dayAfter }
  var dayBefore: Date {
    return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
  }
  var dayAfter: Date {
    return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
  }
  var noon: Date {
    return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
  }
  var month: Int {
    return Calendar.current.component(.month,  from: self)
  }
  var isLastDayOfMonth: Bool {
    return dayAfter.month != month
  }
  
  func toMillis() -> Int64! {
    return Int64(self.timeIntervalSince1970 * 1000)
  }
  
}

extension Int {
  
  func secondsToTime() -> String {
    
    let (h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    
    let h_string = h < 10 ? "0\(h)" : "\(h)"
    let m_string =  m < 10 ? "0\(m)" : "\(m)"
    let s_string =  s < 10 ? "0\(s)" : "\(s)"
    if h == 0{
      return "\(m_string):\(s_string)"
    }else{
      return "\(h_string):\(m_string):\(s_string)"
    }
    
  }
}


extension FileManager {
  
  enum ContentDate {
    case created, modified, accessed
    
    var resourceKey: URLResourceKey {
      switch self {
      case .created: return .creationDateKey
      case .modified: return .contentModificationDateKey
      case .accessed: return .contentAccessDateKey
      }
    }
  }
  
  func contentsOfDirectory(atURL url: URL, sortedBy: ContentDate, ascending: Bool = true, options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]) throws -> [URL]? {
    
    let key = sortedBy.resourceKey
    
    var files = try contentsOfDirectory(at: url, includingPropertiesForKeys: [key], options: options)
    
    try files.sort {
      
      let values1 = try $0.resourceValues(forKeys: [key])
      let values2 = try $1.resourceValues(forKeys: [key])
      
      if let date1 = values1.allValues.first?.value as? Date, let date2 = values2.allValues.first?.value as? Date {
        
        return date1.compare(date2) == (ascending ? .orderedAscending : .orderedDescending)
      }
      return true
    }
    return files.map { $0.absoluteURL }
  }
}
extension URL {
    var creationDate: Date? {
        return (try? resourceValues(forKeys: [.creationDateKey]))?.creationDate
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIColor {
    convenience init?(hexString: String, alphaValue: Float = 1.0) {
        let chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        alpha = CGFloat(alphaValue)
        red   = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
        green = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
        blue  = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
    
    static var hibiscus     = #colorLiteral(red: 0.7411764706, green: 0.2, blue: 0.4431372549, alpha: 1) // BD3371
    static var minsk        = #colorLiteral(red: 0.2392156863, green: 0.1568627451, blue: 0.4901960784, alpha: 1) // 3D287D
    static var vanillaIce   = #colorLiteral(red: 0.9568627451, green: 0.8431372549, blue: 0.8941176471, alpha: 1) // F4D7E4
    static var prelude      = #colorLiteral(red: 0.8235294118, green: 0.7882352941, blue: 0.9333333333, alpha: 1) // D2C9EE
    static var tundora      = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1) // 404040
    static var emperor      = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1) // 505050
    static var doveGray     = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1) // 707070
    static var whiteLilac   = #colorLiteral(red: 0.9529411765, green: 0.937254902, blue: 0.9843137255, alpha: 1) // F3EFFB
    static var cinnabar     = #colorLiteral(red: 0.9215686275, green: 0.2980392157, blue: 0.2980392157, alpha: 1) // EB4C4C
}

 extension CALayer {
    func addGradienBorder(colors:[UIColor],width:CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.cornerRadius = 8
        gradientLayer.mask = shapeLayer
        shapeLayer.cornerRadius = 8
        self.addSublayer(gradientLayer)
    }

}

extension UIDevice {

    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
           return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
   }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
