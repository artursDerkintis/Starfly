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
    var closeTabButton : UIButton?
    var overLayer : CALayer?
    var delegate : SFTabDelegate?
    var loadingIndicator : CALayer?
    var webVC : SFWebVC?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        addSubview(icon!)
        setLoader()
        label = UILabel(frame: CGRect(x: self.frame.height * 0.85, y: 0, width: self.frame.width - (self.frame.height * 1.6), height: self.frame.height))
      
        label!.text = "Loading..."
        label?.font = UIFont.systemFontOfSize(13, weight: UIFontWeightMedium)
        label?.textColor = UIColor.whiteColor()
        label!.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        label!.layer.shadowOffset = CGSize(width: 0, height: lineWidth())
        label!.layer.shadowRadius = 0
        label!.layer.shadowOpacity = 1.0
        label!.layer.rasterizationScale = UIScreen.mainScreen().scale
        label!.layer.shouldRasterize = true
        addSubview(label!)
        
        closeTabButton = UIButton(type: UIButtonType.Custom)
        closeTabButton?.frame = CGRect(x: frame.width - frame.height * 1.25, y: -(frame.height * 0.25), width: frame.height * 1.5, height: frame.height * 1.5)
        closeTabButton?.autoresizingMask =  UIViewAutoresizing.FlexibleLeftMargin
        closeTabButton?.setImage(UIImage(named: Images.closeTab), forState: UIControlState.Normal)
        closeTabButton?.setImage(UIImage(named: Images.closeTab)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        closeTabButton?.contentEdgeInsets = UIEdgeInsets(top: 21, left: 21, bottom: 21, right: 21)
        closeTabButton?.addTarget(self, action: "closeTab", forControlEvents: UIControlEvents.TouchDown)
        addSubview(closeTabButton!)
        
        loadingIndiSwitch(on : false)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "closeTab")
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }
    func setUpObservers(){
        if let web = webVC?.webView{
            web.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.New, context: nil)
            web.addObserver(self, forKeyPath: "loading", options: NSKeyValueObservingOptions.New, context: nil)
            webVC?.addObserver(self, forKeyPath: "favicon", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "title"{
            label?.text = webVC?.webView?.title
        }
        if keyPath == "loading"{
            loadingIndiSwitch(on: webVC!.webView!.loading)
            
        }
        if keyPath == "favicon"{
            icon?.image = webVC?.favicon
        }
    }
    
  
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        overLayer?.frame = layer.bounds
        overLayer?.cornerRadius = frame.height * 0.5
        layer.cornerRadius = frame.height * 0.5
    }
    
    //Closes this tab
    func closeTab(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = CGPoint(x: self.center.x, y: self.center.y - 100)
            }) { (ss) -> Void in
            self.delegate?.closeTab(self)
        }
       
    }
    
    //Incrase Touch area
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(CGRectInset(self.bounds, -10, -5), point){
            return true
        }
        return false
    }
    
    
    //Selection and Unselection Animations
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
    
    //Show/Hide Spinner Loading indicator
    func loadingIndiSwitch(on on : Bool){
        
        let basicAnim = CABasicAnimation(keyPath: "opacity")
        basicAnim.fromValue = on ? 0.0 : 1.0
        basicAnim.toValue = on ? 1.0 : 0.0
        basicAnim.duration = 0.6
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.removedOnCompletion = false
        self.loadingIndicator?.addAnimation(basicAnim, forKey: "animate")
        
    }
    
    func setLoader(){
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRectInset(icon!.frame, -1, -1)

        replicatorLayer.instanceCount = 15
        replicatorLayer.instanceDelay = CFTimeInterval(1 / 15.0)
        replicatorLayer.preservesDepth = true
        replicatorLayer.instanceColor = UIColor.whiteColor().CGColor
        
        replicatorLayer.instanceRedOffset = 0.0
        replicatorLayer.instanceGreenOffset = 0.0
        replicatorLayer.instanceBlueOffset = 0.0
        replicatorLayer.instanceAlphaOffset = 0.0
        
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
        
        let instanceLayer = CALayer()
        let layerWidth: CGFloat = 2.0
        instanceLayer.cornerRadius = 1.0
        let midX = CGRectGetMidX(icon!.frame) - layerWidth / 2.0
        instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 3.0)
        instanceLayer.backgroundColor = UIColor.whiteColor().CGColor
        replicatorLayer.addSublayer(instanceLayer)
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 1
        fadeAnimation.repeatCount = Float(Int.max)
        
        instanceLayer.opacity = 0.0
        instanceLayer.addAnimation(fadeAnimation, forKey: "FadeAnimation")
        instanceLayer.rasterizationScale = UIScreen.mainScreen().scale
        instanceLayer.shouldRasterize = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        if let web = webVC?.webView{
            web.removeObserver(self, forKeyPath: "title")
            web.removeObserver(self, forKeyPath: "loading")
            webVC!.removeObserver(self, forKeyPath: "favicon")
        }
    }
    
}


