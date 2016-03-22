//
//  Models.swift
//  Starfly
//
//  Created by Arturs Derkintis on 3/16/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import Foundation

public struct Item{
    var url         : String
    var title       : String
    var favicon     : UIImage
    var screenshot  : UIImage?
    
    init(url : String, title : String, favicon : UIImage, screenshot : UIImage? = nil){
        self.url = url
        self.title = title
        self.favicon = favicon
        self.screenshot = screenshot
    }
}
