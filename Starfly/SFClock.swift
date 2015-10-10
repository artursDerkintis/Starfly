//
//  Clock.swift
//  StarflyV2
//
//  Created by Neal Caffrey on 3/5/15.
//  Copyright (c) 2015 Neal Caffrey. All rights reserved.
//

import UIKit

class SFClock: UIView {
    let HOURS_HAND_LENGTH : CGFloat = 0.6
    let MIN_HAND_LENGTH : CGFloat   = 0.85
    let SEC_HAND_LENGTH : CGFloat  = 1
    let HOURS_HAND_WIDTH : CGFloat = 2
    let MIN_HAND_WIDTH : CGFloat   = 2
    let SEC_HAND_WIDTH : CGFloat   = 1
    var timer: NSTimer?
    var containerLayer, hourLayer, minLayer, secLayer : CALayer?
    var digitalClock : UILabel?
    var batteryLevel : Battery?
    var state : SFClockFace?
    override init(frame: CGRect) {
        super.init(frame: frame)
        if NSUserDefaults.standardUserDefaults().integerForKey("clockFace") == 0{
            NSUserDefaults.standardUserDefaults().setInteger(SFClockFace.analog.rawValue, forKey: "clockFace")
        }else{
            state = SFClockFace(rawValue: NSUserDefaults.standardUserDefaults().integerForKey("clockFace"))
        }
        setup()
        start()
        let tap = UITapGestureRecognizer(target: self, action: "changeFace")
        addGestureRecognizer(tap)
    }
    func start(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateClock", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
            }
   
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func changeFace(){
        let integer = NSUserDefaults.standardUserDefaults().integerForKey("clockFace")
        switch integer{
        case 1:
             NSUserDefaults.standardUserDefaults().setInteger(SFClockFace.digital.rawValue, forKey: "clockFace")
            break
        case 2:
             NSUserDefaults.standardUserDefaults().setInteger(SFClockFace.battery.rawValue, forKey: "clockFace")
            break
        case 3:
             NSUserDefaults.standardUserDefaults().setInteger(SFClockFace.analog.rawValue, forKey: "clockFace")
            break
        default:
            break
        }
        updateFace()
    }
    func updateFace(){
        let integer = NSUserDefaults.standardUserDefaults().integerForKey("clockFace")
        switch SFClockFace(rawValue: integer)!{
        case SFClockFace.analog:
            let ani = CABasicAnimation(keyPath: "opacity")
            ani.removedOnCompletion = false
            ani.fillMode = kCAFillModeForwards;
            ani.duration = 0.3
            ani.fromValue = 0.01
            ani.toValue = 1
            containerLayer?.addAnimation(ani, forKey: "s")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.batteryLevel?.label?.alpha = 0.0001
                self.digitalClock?.alpha = 0.0001
            })
            break
        case SFClockFace.battery:
            containerLayer?.opacity = 0.0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.batteryLevel?.label?.alpha = 1.0
                self.digitalClock?.alpha = 0.0001
            })
            
            break
        case SFClockFace.digital:
            let ani = CABasicAnimation(keyPath: "opacity")
            ani.removedOnCompletion = false
            ani.fillMode = kCAFillModeForwards;
            ani.duration = 0.3
            ani.fromValue = containerLayer!.opacity
            ani.toValue = 0.01
            containerLayer?.addAnimation(ani, forKey: "s")

            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.batteryLevel?.label?.alpha = 0.0001
                self.digitalClock?.alpha = 1.0
            })
            break
        default:
            break
        }
    }
    func setup(){
        let color = UIColor.whiteColor()
        containerLayer = CALayer()
        hourLayer = CALayer()
        minLayer = CALayer()
        secLayer = CALayer()
        secLayer?.backgroundColor = color.CGColor
        minLayer?.backgroundColor = color.CGColor
        minLayer?.cornerRadius = 1
        hourLayer?.backgroundColor = color.CGColor
        hourLayer?.cornerRadius = 1
        layer.borderWidth = 2
        layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.3).CGColor
        layer.cornerRadius = frame.height * 0.5
        containerLayer?.addSublayer(hourLayer!)
        containerLayer?.addSublayer(minLayer!)
        containerLayer?.addSublayer(secLayer!)
        layer.addSublayer(containerLayer!)
        containerLayer?.shouldRasterize = true
        containerLayer?.rasterizationScale = UIScreen.mainScreen().scale
        secLayer?.shouldRasterize = true
        secLayer?.rasterizationScale = UIScreen.mainScreen().scale
        minLayer?.shouldRasterize = true
        minLayer?.rasterizationScale = UIScreen.mainScreen().scale
        hourLayer?.rasterizationScale = UIScreen.mainScreen().scale
        hourLayer?.shouldRasterize = true
        let dot = CALayer()
        dot.frame = CGRectMake(frame.width * 0.5 - 1.5, frame.height * 0.5 - 1.5, 3, 3)
        dot.backgroundColor = color.CGColor
        dot.cornerRadius = 1.5
        dot.rasterizationScale = UIScreen.mainScreen().scale
        dot.shouldRasterize = true
        
        containerLayer?.addSublayer(dot)
        
        digitalClock = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        digitalClock?.textAlignment = NSTextAlignment.Center
        digitalClock?.font = UIFont.systemFontOfSize(13)
        digitalClock?.textColor = UIColor.whiteColor()
        addSubview(digitalClock!)
        batteryLevel = Battery(frame: self.bounds)
        addSubview(batteryLevel!)
        updateFace()
        updateClock()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerLayer?.frame = CGRectMake(0, 0, frame.width, frame.height)
        let length = min(frame.width, frame.height) * 0.5
        let c = CGPointMake(frame.width * 0.5, frame.height * 0.5)
        hourLayer?.position = c
        minLayer?.position = c
        secLayer?.position = c
        var w, h : CGFloat?
        w = HOURS_HAND_WIDTH
        h = length * HOURS_HAND_LENGTH
        hourLayer?.bounds = CGRectMake(0, 0, w!, h!)
        w = MIN_HAND_WIDTH
        h = length * MIN_HAND_LENGTH
        minLayer?.bounds = CGRectMake(0, 0, w!, h!)
        w = SEC_HAND_WIDTH
        h = length * SEC_HAND_LENGTH
        secLayer?.bounds = CGRectMake(0, 0, w!, h!)
        containerLayer?.anchorPoint = CGPointMake(0.5, 0.5)
        
        secLayer?.anchorPoint = CGPointMake(0.5, 0.14)
        minLayer?.anchorPoint = CGPointMake(0.5, 0.07)
        hourLayer?.anchorPoint = CGPointMake(0.5, 0.07)
        
        
        
    }
    func updateClock(){
        let dateComp = NSCalendar.currentCalendar().components(([NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]), fromDate: NSDate())
        let seconds : NSInteger  = dateComp.second
        let minutes : NSInteger  = dateComp.minute
        var hours : NSInteger   = dateComp.hour
        digitalClock?.text = String(hours) + ":" + String(format: "%02d", minutes)
        if hours > 12{
            hours -= 12
        }
        
        let secAngle : CGFloat = DegreesToRadians(CGFloat(seconds) / 60 * 360)
        
        let minAngle : CGFloat = DegreesToRadians(CGFloat(minutes) / 60 * 360)
        let hourAngle: CGFloat = DegreesToRadians(CGFloat(hours) / 12 * 360) + minAngle / 12
        let prevSecAngle : CGFloat = DegreesToRadians((CGFloat(seconds) - 1) / 60.0 * 360)
        //println("SEC \(secAngle), PRE \(prevSecAngle)")
        let ani = CABasicAnimation(keyPath: "transform")
        ani.removedOnCompletion = false
        ani.fillMode = kCAFillModeForwards;
        ani.duration = 1.0
        ani.fromValue =  NSValue(CATransform3D: CATransform3DMakeRotation(prevSecAngle+CGFloat(M_PI), 0, 0, 1))
        ani.toValue   = NSValue(CATransform3D: CATransform3DMakeRotation (secAngle+CGFloat(M_PI), 0, 0, 1))
       secLayer?.removeAllAnimations()
        secLayer?.addAnimation(ani, forKey: "transform")
       // secLayer?.transform = CATransform3DMakeRotation (secAngle+CGFloat(M_PI), 0, 0, 1);
        minLayer?.transform = CATransform3DMakeRotation (minAngle+CGFloat(M_PI), 0, 0, 1)
        hourLayer?.transform = CATransform3DMakeRotation (hourAngle+CGFloat(M_PI), 0, 0, 1);
        

        
    }
   
    func DegreesToRadians(degrees : CGFloat) -> CGFloat{
        //println(degrees)
        return degrees * CGFloat(M_PI) / 180
    }
}
class Battery: UIView {
    var color = UIColor.whiteColor()
    var label : UILabel?
    var timer : NSTimer?
    var currentLevel : Float? = 45
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        layer.cornerRadius = frame.width * 0.5
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        currentLevel = UIDevice.currentDevice().batteryLevel
        label = UILabel(frame: bounds)
        label?.textAlignment = NSTextAlignment.Center
        label?.font = UIFont.systemFontOfSize(13)
        label?.textColor = color
        addSubview(label!)
        layer.rasterizationScale = UIScreen.mainScreen().scale
        layer.shouldRasterize = true
        
        label!.text = String(format: "%.f%%", currentLevel! * 100)
        backgroundColor = UIColor.clearColor()
        refreshTimer()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "firetimer", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
    }
    func firetimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "refreshTimer", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    func refreshTimer(){
        currentLevel = UIDevice.currentDevice().batteryLevel
        label!.text = String(format: "%.f%%", currentLevel! * 100)
        if currentLevel! * 100 <= 10{
            color = UIColor.redColor()
        }else{
            color = UIColor.whiteColor()
        }
        check()
        setNeedsDisplay()
    }
    func check()
    {
        switch (UIDevice.currentDevice().batteryState){
            
        case UIDeviceBatteryState.Unplugged:
            layer.backgroundColor = UIColor.clearColor().CGColor
            break;
            
        case UIDeviceBatteryState.Charging:
            layer.backgroundColor = UIColor.darkerColorForColor(color, rateDown: 0.1).colorWithAlphaComponent(0.1).CGColor
            break;
            
        case UIDeviceBatteryState.Full:
            layer.backgroundColor = UIColor.darkerColorForColor(color, rateDown: 0.05).colorWithAlphaComponent(0.1).CGColor
            break;
            
        default:
            layer.backgroundColor = UIColor.clearColor().CGColor
            break;
            
        }
        
    }
    
    override func drawRect(rect: CGRect) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        
        //// Oval Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, rect.width * 0.5, rect.height * 0.5)
        CGContextRotateCTM(context, -90 * CGFloat(M_PI) / 180)
        let ovalRect = CGRectMake(-(rect.width * 0.475), -(rect.height * 0.475), rect.width * 0.95, rect.height * 0.95)
        let ovalPath = UIBezierPath()
        let bbc =  CGFloat(360 * currentLevel!)
        
        ovalPath.addArcWithCenter(CGPointMake(ovalRect.midX, ovalRect.midY), radius: ovalRect.width / 2, startAngle: 0 * CGFloat(M_PI)/180, endAngle: bbc * CGFloat(M_PI)/180, clockwise: true)
        ovalPath.lineCapStyle = CGLineCap.Round
        UIColor.clearColor().setFill()
        ovalPath.fill()
        color.setStroke()
        ovalPath.lineWidth = 2
        ovalPath.stroke()
        
        CGContextRestoreGState(context)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}