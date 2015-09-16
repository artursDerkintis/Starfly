//
//  SFTab.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/14/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFTab: SFView {
    
    var label : UILabel?
    var icon  : UIImageView?
    var closeTab : UIButton?
    var overLayer : CALayer?
    var delegate : SFCloseTab?
    var loadingIndicator : CALayer?
    var radial : SFRadialLayer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        //layer.backgroundColor = currentColor?.CGColor
        layer.cornerRadius = frame.height * 0.5
        layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.shadowOpacity = 1.0
        layer.rasterizationScale = UIScreen.mainScreen().scale
        layer.shouldRasterize = true
        overLayer = CALayer()
        overLayer?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        layer.addSublayer(overLayer!)
        icon = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.height * 0.4, height: frame.height * 0.4))
        icon?.layer.cornerRadius = frame.height * 0.2
        icon?.center = CGPoint(x: icon!.frame.height * 1.05, y: frame.height * 0.5)
        icon?.backgroundColor = lighterColorForColor(currentColor!, index: -0.2)
        icon?.image = UIImage(named: "g")
        icon?.layer.masksToBounds = true
        radial = SFRadialLayer()
        radial!.frame = icon!.bounds
        radial!.origin = CGPoint(x: radial!.frame.height * 0.5, y: radial!.frame.height * 0.5)
        radial!.locations = [0.0, 0.6, 0.6, 0.6, 0.6]
        radial?.opacity = 0.0
        radial!.radius = radial!.frame.height
        icon?.layer.addSublayer(radial!)
        
        addSubview(icon!)
        setLoader()
        label = UILabel(frame: CGRect(x: self.frame.height * 0.9, y: 0, width: self.frame.width - (self.frame.height * 1.5), height: self.frame.height))
      
        label!.text = "some long useless textmore tx"
        label?.font = UIFont.systemFontOfSize(13, weight: UIFontWeightMedium)
        label?.textColor = UIColor.whiteColor()
        label!.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        label!.layer.shadowOffset = CGSize(width: 0, height: lineWidth())
        label!.layer.shadowRadius = 0
        label!.layer.shadowOpacity = 1.0
        label!.layer.rasterizationScale = UIScreen.mainScreen().scale
        label!.layer.shouldRasterize = true
        addSubview(label!)
        
        closeTab = UIButton(type: UIButtonType.Custom)
        closeTab?.frame = CGRect(x: frame.width - frame.height * 1.25, y: -(frame.height * 0.25), width: frame.height * 1.5, height: frame.height * 1.5)
        closeTab?.autoresizingMask =  UIViewAutoresizing.FlexibleLeftMargin
        closeTab?.setImage(UIImage(named: NavImages.closeTab), forState: UIControlState.Normal)
        closeTab?.setImage(UIImage(named: NavImages.closeTab)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        closeTab?.contentEdgeInsets = UIEdgeInsets(top: 21, left: 21, bottom: 21, right: 21)
        closeTab?.addTarget(self, action: "closeTabF", forControlEvents: UIControlEvents.TouchDown)
        addSubview(closeTab!)
        loadingIndiSwitch(on : true)
        delay(5.0) { () -> () in
            self.loadingIndiSwitch(on: false)
        }
    }
    func loadingIndiSwitch(on on : Bool){
        radial!.setNeedsDisplay()
        let basicAnim = CABasicAnimation(keyPath: "opacity")
        basicAnim.fromValue = on ? 0.0 : 1.0
        basicAnim.toValue = on ? 1.0 : 0.0
        basicAnim.duration = 1.0
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.removedOnCompletion = false
        self.loadingIndicator?.addAnimation(basicAnim, forKey: "j")
        self.radial?.addAnimation(basicAnim, forKey: "j")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        overLayer?.frame = layer.bounds
        overLayer?.cornerRadius = frame.height * 0.5
        layer.cornerRadius = frame.height * 0.5
    }
    func closeTabF(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = CGPoint(x: self.center.x, y: self.center.y - 100)
            }) { (ss) -> Void in
            self.delegate?.closeTab(self)
        }
       
        
        
       
    }
     var selected : Bool = false{
        didSet{
            if selected != oldValue{
                if selected == false{
                let basicAnim0 = CABasicAnimation(keyPath: "backgroundColor")
                basicAnim0.fromValue = UIColor.clearColor().CGColor
                basicAnim0.toValue = UIColor.lightGrayColor().colorWithAlphaComponent(0.4).CGColor
                basicAnim0.duration = 0.2
                basicAnim0.fillMode = kCAFillModeForwards
                basicAnim0.removedOnCompletion = false
                overLayer!.addAnimation(basicAnim0, forKey: "shadow24")
                let basicAnim = CABasicAnimation(keyPath: "shadowRadius")
                basicAnim.fromValue = 2
                basicAnim.toValue = 0.5
                basicAnim.duration = 0.2
                basicAnim.fillMode = kCAFillModeForwards
                basicAnim.removedOnCompletion = false
                layer.addAnimation(basicAnim, forKey: "shadow")
                let basicAnim2 = CABasicAnimation(keyPath: "borderWidth")
                basicAnim2.fromValue = 0
                basicAnim2.toValue = lineWidth()
                basicAnim2.duration = 0.2
                basicAnim2.fillMode = kCAFillModeForwards
                basicAnim2.removedOnCompletion = false
                layer.addAnimation(basicAnim2, forKey: "shadows")
                let basicAnim1 = CABasicAnimation(keyPath: "shadowColor")
                basicAnim1.fromValue = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
                basicAnim1.toValue = UIColor.blackColor().colorWithAlphaComponent(0.0).CGColor
                basicAnim1.duration = 0.2
                basicAnim1.fillMode = kCAFillModeForwards
                basicAnim1.removedOnCompletion = false
                layer.addAnimation(basicAnim1, forKey: "shadow2")
            }else{
                let basicAnim0 = CABasicAnimation(keyPath: "backgroundColor")
                basicAnim0.fromValue =  UIColor.lightGrayColor().colorWithAlphaComponent(0.4).CGColor
                basicAnim0.toValue =  UIColor.clearColor().CGColor
                basicAnim0.duration = 0.2
                basicAnim0.fillMode = kCAFillModeForwards
                basicAnim0.removedOnCompletion = false
                    
                overLayer!.addAnimation(basicAnim0, forKey: "shadow24")
                let basicAnim2 = CABasicAnimation(keyPath: "borderWidth")
                basicAnim2.fromValue = lineWidth()
                basicAnim2.toValue = 0
                basicAnim2.duration = 0.2
                basicAnim2.fillMode = kCAFillModeForwards
                basicAnim2.removedOnCompletion = false
                layer.addAnimation(basicAnim2, forKey: "shadows")
                let basicAnim = CABasicAnimation(keyPath: "shadowRadius")
                basicAnim.fromValue = 0.5
                basicAnim.toValue = 2
                basicAnim.duration = 0.2
                basicAnim.fillMode = kCAFillModeForwards
                basicAnim.removedOnCompletion = false
                layer.addAnimation(basicAnim, forKey: "shadow")
                let basicAnim1 = CABasicAnimation(keyPath: "shadowColor")
                basicAnim1.fromValue = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
                basicAnim1.toValue = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
                basicAnim1.duration = 0.2
                basicAnim1.fillMode = kCAFillModeForwards
                basicAnim1.removedOnCompletion = false
                layer.addAnimation(basicAnim1, forKey: "shadow2")
                }}
        }
    }
    func setLoader(){
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRectInset(icon!.frame, -1, -1)
        // 2
        replicatorLayer.instanceCount = 15
        replicatorLayer.instanceDelay = CFTimeInterval(1 / 15.0)
        replicatorLayer.preservesDepth = true
        replicatorLayer.instanceColor = UIColor.whiteColor().CGColor
        
        // 3
        replicatorLayer.instanceRedOffset = 0.0
        replicatorLayer.instanceGreenOffset = 0.0
        replicatorLayer.instanceBlueOffset = 0.0
        replicatorLayer.instanceAlphaOffset = 0.0
        
        // 4
        let angle = Float(M_PI * 2.0) / 15
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        layer.addSublayer(replicatorLayer)
        loadingIndicator = replicatorLayer
        loadingIndicator?.opacity = 0.0
        let rotAtStart : Float? = loadingIndicator?.valueForKey("transform.rotation") as? Float
        let rotTrans = CATransform3DRotate(loadingIndicator!.transform, -CGFloat(M_PI * 2), 0.0, 0.0, 1.0)
        loadingIndicator?.transform = rotTrans
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.duration = 15.0
        rotation.fromValue = rotAtStart
        rotation.toValue = -Float(M_PI * 2)
        rotation.repeatCount = Float.infinity
        loadingIndicator?.addAnimation(rotation, forKey: "e")
        // 5
        let instanceLayer = CALayer()
        let layerWidth: CGFloat = 2.0
        let midX = CGRectGetMidX(icon!.frame) - layerWidth / 2.0
        instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 3.0)
        instanceLayer.backgroundColor = UIColor.whiteColor().CGColor
        replicatorLayer.addSublayer(instanceLayer)
        
        // 6
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 1
        fadeAnimation.repeatCount = Float(Int.max)
        
        // 7
        instanceLayer.opacity = 0.0
        instanceLayer.addAnimation(fadeAnimation, forKey: "FadeAnimation")
        instanceLayer.rasterizationScale = UIScreen.mainScreen().scale
        instanceLayer.shouldRasterize = true
        
    }
/*NSNumber *rotationAtStart = [myLayer valueForKeyPath:@"transform.rotation"];
CATransform3D myRotationTransform = CATransform3DRotate(myLayer.transform, myRotationAngle, 0.0, 0.0, 1.0);
myLayer.transform = myRotationTransform;
CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
myAnimation.duration = kMyAnimationDuration;
myAnimation.fromValue = rotationAtStart;
myAnimation.toValue = [NSNumber numberWithFloat:([rotationAtStart floatValue] + myRotationAngle)];
[myLayer addAnimation:myAnimation forKey:@"transform.rotation"];*/
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    }

class SFRadialLayer : CALayer {
    var origin: CGPoint?
    var radius: CGFloat?
    var locations: [CGFloat]?
    var colors: [UIColor]?
    
    override func drawInContext(ctx: CGContext) {
        super.drawInContext(ctx)
        colors = [currentColor!.colorWithAlphaComponent(0.0), currentColor!, currentColor!, currentColor!, currentColor!]
        if let colors = self.colors {
            if let locations = self.locations {
                if let origin = self.origin {
                    if let radius = self.radius {
                        var colorSpace: CGColorSpaceRef?
                        
                        var components = [CGFloat]()
                        for i in 0 ..< colors.count {
                            let colorRef = colors[i].CGColor
                            let colorComponents = CGColorGetComponents(colorRef)
                            let numComponents = CGColorGetNumberOfComponents(colorRef)
                            if colorSpace == nil {
                                colorSpace = CGColorGetColorSpace(colorRef)
                            }
                            for j in 0 ..< numComponents {
                                let componentIndex: Int = numComponents * i + j
                                let component = colorComponents[j]
                                components.append(component)
                            }
                        }
                        
                        if let colorSpace = colorSpace {
                            let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, locations.count)
                            CGContextDrawRadialGradient(ctx, gradient, origin, CGFloat(0), origin, radius, CGGradientDrawingOptions.DrawsAfterEndLocation)
                        }
                    }
                }
            }
        }
    }
}
