//
//  SFButton.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/28/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = currentColor
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeColor", name: "ColorChanges", object: nil)
    }
    func changeColor(){
        backgroundColor = currentColor
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ColorChanges", object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(CGRectInset(self.bounds, -10, -10), point){
            return true
        }
        return false
    }
}
