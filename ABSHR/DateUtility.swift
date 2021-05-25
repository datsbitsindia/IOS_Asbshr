//
//  DateUtility.swift
// 
//
//  Created by mac on 03/09/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation

enum DateFormat:String {
  
    case ymd = "yyyy-MM-dd"
    case ddmmyy = "dd MM yyyy"
    case mmmddyyyy = "MMM dd, yyyy"
    case mmmddyyyhhmm = "yyyy-MM-dd hh:mm:ss"
    case hhmmss = "hh:mm:ss"
    case hhmm = "hh:mm"
    
}

extension Date {

  func string(_ format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
//    dateFormatter.timeZone = TimeZone.current
    return dateFormatter.string(from: self)
  }
}

extension String {
    
  func toDate(_ format: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: self) ?? Date()
  }
    
}



