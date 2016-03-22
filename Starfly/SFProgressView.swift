//
//  SFProgressVC.swift
//  Starfly
//
//  Created by Arturs Derkintis on 11/22/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFProgressView: UIView {
    let durationFull : NSTimeInterval = 5.0
    var progressLayer = UIView()
    var oldProgress : Double = 0
    var newProgress : Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        progressLayer.backgroundColor = UIColor.whiteColor()
        addSubviewSafe(progressLayer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProgress:", name: "PROGRESS", object: nil)
    }
    
    func updateProgress(not : NSNotification){
        let progress = not.object! as! Double
        //print(progress)
        newProgress = progress
        UIView.animateWithDuration(durationFull * NSTimeInterval(progress - oldProgress), animations: { () -> Void in
            self.progressLayer.frame = CGRect(x: 0, y:0, width: self.frame.width * CGFloat(self.newProgress), height: self.frame.height)
            }) { (fin) -> Void in
                delay(0.2, closure: { () -> () in
                    self.alpha = self.newProgress == 1.0 ? 0.0 : 1.0
                    self.progressLayer.frame = CGRect(x: 0, y:0, width: self.newProgress == 1.0 ? 0.0 : self.progressLayer.frame.size.width, height: self.frame.height)
                    
                })
        }
        oldProgress = progress
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.layer.cornerRadius = frame.height * 0.5
        progressLayer.frame = CGRect(x: 0, y: progressLayer.frame.origin.y, width: self.frame.width * CGFloat(newProgress), height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
