//
//  SFHomeSwitcher.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/20/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFHomeSwitcher: UIControl {
    
    var floater : SFView?
    var items = ["Bookmarks", "Home", "History"]
    var centers = [CGPoint]()
    var oldX : CGFloat = 0
    var dragging = false
    var currentPage : Int = 1
    var ImDoingSomething = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let count = CGFloat(items.count)
        backgroundColor = UIColor.lightGrayColor()
        let background = SFView(frame: bounds)
        background.alpha = 0.5
        background.layer.cornerRadius = frame.height * 0.5
        background.layer.masksToBounds = true
        addSubview(background)
        background.userInteractionEnabled  = false
        layer.cornerRadius = frame.height * 0.5
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1.0
        layer.shouldRasterize = true
        layer.borderWidth = 0
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.rasterizationScale = UIScreen.mainScreen().scale

        floater = SFView(frame: CGRect(x: 0, y: 0, width: frame.width / count, height: frame.height))
        floater?.layer.cornerRadius = floater!.frame.height * 0.5
        floater?.layer.borderWidth = 0
        floater?.layer.borderColor = UIColor.whiteColor().CGColor
        floater?.userInteractionEnabled = false
        addSubview(floater!)
        
        for item in items{
            let label = UILabel(frame: CGRect(x: (frame.width / count) * CGFloat(items.indexOf(item)!), y: 0, width: frame.width / count, height: frame.height))
            label.textColor = .whiteColor()
            label.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
            label.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
            label.layer.shadowOffset = CGSize(width: 0, height: lineWidth())
            label.layer.shadowRadius = 0
            label.userInteractionEnabled = false
            label.layer.shadowOpacity = 1.0
            label.layer.rasterizationScale = UIScreen.mainScreen().scale
            label.layer.shouldRasterize = true
            label.textAlignment = NSTextAlignment.Center
            label.text = item
            addSubview(label)
            centers.append(label.center)
        }
        
        
    }
    
    func liveScroll(point : CGPoint){
        if !ImDoingSomething{
            floater?.frame.origin = point
        }
    }
    
    func setPage(current : Int){
        if !ImDoingSomething{
        currentPage = current
        ImDoingSomething = true
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.floater?.center = CGPoint(x: self.centers[current].x, y: self.floater!.center.y)
            
            }) { (done) -> Void in
                self.ImDoingSomething = false
        }
        }
        
    }
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let loc = touch.locationInView(self)
        if CGRectContainsPoint(floater!.frame, loc){
            oldX = touch.locationInView(floater!).x
            
            dragging = true
            return true
        }
        
        var closestX : CGFloat = CGFloat.infinity
        var point : CGPoint?
        for cente in centers{
            let distance = cente.distanceToPoint(loc)
            if closestX >= distance{
                closestX = distance
                point = cente
                currentPage = centers.indexOf(cente)!
            }
        }
        ImDoingSomething = true
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.floater?.center = CGPoint(x: point!.x, y: self.floater!.center.y)
            }) { (done) -> Void in
                self.ImDoingSomething = false
        
        
        }
        sendActionsForControlEvents(UIControlEvents.TouchUpInside)

        return false
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let loc = touch.locationInView(self)
        if dragging{
            if floater!.frame.origin.x >= 0 && floater!.frame.origin.x <= frame.width - floater!.frame.width{
            floater?.frame = CGRect(x: loc.x - oldX, y: 0, width: floater!.frame.width, height: floater!.frame.height)
            }
        }
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        var closestX : CGFloat = CGFloat.infinity
        var point : CGPoint?
        for cente in centers{
            let distance = cente.distanceToPoint(floater!.center)
            if closestX >= distance{
                closestX = distance
                point = cente
                currentPage = centers.indexOf(cente)!
            }
        }
        ImDoingSomething = true
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.floater?.center = CGPoint(x: point!.x, y: self.floater!.center.y)
            }) { (done) -> Void in
                self.ImDoingSomething = false
                
                
        }
        sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        dragging = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
