//
//  SFView.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
var currentColor : UIColor?

//Self coloring UIView
class SFView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        currentColor = NSUserDefaults.standardUserDefaults().colorForKey("COLOR2") == nil ? SFColors.green : NSUserDefaults.standardUserDefaults().colorForKey("COLOR2")
        UIApplication.sharedApplication().delegate?.window!?.tintColor = currentColor
        backgroundColor = currentColor
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeColor", name: "ColorChanges", object: nil)
    }
    
    func changeColor(){
        currentColor = NSUserDefaults.standardUserDefaults().colorForKey("COLOR2") == nil ? SFColors.green : NSUserDefaults.standardUserDefaults().colorForKey("COLOR2")

        backgroundColor = currentColor
        UIApplication.sharedApplication().delegate?.window!?.tintColor = currentColor
        
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ColorChanges", object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
