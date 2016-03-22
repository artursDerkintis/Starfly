//
//  DateFormatter.swift
//  MirrorRSSFeed
//
//  Created by Arturs Derkintis on 3/7/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class DateFormatter: NSObject {
    
    class var sharedInstance: DateFormatter {
        struct Singleton {
            static let instance = DateFormatter()
        }
        return Singleton.instance
    }
    
    var dateFormatter : NSDateFormatter!
    
    required override init() {
        super.init()
        dateFormatter = NSDateFormatter()
    }
    
    var readableFormat = "dd/MM/yyyy"
    
    func readableDate(date : NSDate) -> String{
        dateFormatter.dateFormat = readableFormat
        return dateFormatter.stringFromDate(date)
    }
    
}
