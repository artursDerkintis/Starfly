//
//  SFUrlBar.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFUrlBar: UIViewController {
    var nav1, nav2 : UIView?
    var back, forward, stop, reload, home, share, menu : UIButton?
    
    var textField : UITextField?
    var gradient : CAGradientLayer?
    var sizeOfPro : CGSize = CGSize(width: 1, height: lineWidth())
    var percent : CGFloat = 0.0
    var clock : SFClock?
    var mask : CALayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = SFView(frame: view.bounds)
        
        self.view.layer.cornerRadius = 45 * 0.5
        self.view.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        self.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.view.layer.shadowRadius = 2
        self.view.layer.shadowOpacity = 1.0
        
        
        
         setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        print(" setup ")
        nav1 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.26, height: self.view.frame.height))
        

        view.addSubview(nav1!)
        let edge = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        back = UIButton(type: UIButtonType.Custom)
        back?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        back?.setImage(UIImage(named: NavImages.back), forState: UIControlState.Normal)
        back?.setImage(UIImage(named: NavImages.back)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        back?.addTarget(self, action: "fire", forControlEvents: UIControlEvents.TouchDown)
        back?.contentEdgeInsets = edge
        
        
        forward = UIButton(type: UIButtonType.Custom)
        forward?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        forward?.setImage(UIImage(named: NavImages.forward), forState: UIControlState.Normal)
        forward?.setImage(UIImage(named: NavImages.forward)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        forward?.contentEdgeInsets = edge
        
        
        reload = UIButton(type: UIButtonType.Custom)
        reload?.frame = CGRect(x: 0, y: 0, width: 46, height: 45)
        reload?.setImage(UIImage(named: NavImages.reload), forState: UIControlState.Normal)
        reload?.setImage(UIImage(named: NavImages.reload)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        reload?.contentEdgeInsets = edge
        
        stop = UIButton(type: UIButtonType.Custom)
        stop?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        stop?.setImage(UIImage(named: NavImages.stop), forState: UIControlState.Normal)
        stop?.setImage(UIImage(named: NavImages.stop)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        stop?.contentEdgeInsets = edge
        
        home = UIButton(type: UIButtonType.Custom)
        home?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        home?.setImage(UIImage(named: NavImages.home), forState: UIControlState.Normal)
        home?.setImage(UIImage(named: NavImages.home)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        home?.contentEdgeInsets = edge
        
        nav1?.addSubview(back!)
        nav1?.addSubview(forward!)
        nav1?.addSubview(reload!)
        //nav1?.addSubview(stop!)
        nav1?.addSubview(home!)
        
        
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.52, height: 35))
        textField?.layer.cornerRadius = 35 * 0.5
        textField?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        textField?.layer.shadowOffset = CGSize(width: 0, height: lineWidth())
        textField?.layer.shadowOpacity = 0.6
        textField?.layer.shadowRadius = 0
        textField?.keyboardType = UIKeyboardType.WebSearch
        textField?.keyboardAppearance = UIKeyboardAppearance.Light
        textField?.autocapitalizationType = UITextAutocapitalizationType.None
        textField?.autocorrectionType = UITextAutocorrectionType.No
        //NSAttributedString(string: ss, attributes: [NSForegroundColorAttributeName : color.colorWithAlphaComponent(0.5)])
        textField?.attributedPlaceholder = NSAttributedString(string: "Search or Type URL", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.6)])
        textField?.layer.borderWidth = 1
        textField?.layer.borderColor = UIColor.whiteColor().CGColor
        textField?.layer.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.01).CGColor
        textField?.tintColor = UIColor.whiteColor()
        textField?.layer.masksToBounds = false
        textField?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightMedium)
        textField?.textColor = UIColor.whiteColor()
        textField?.leftView = UIView(frame: CGRectMake(0, 0, 15, 30))
        textField?.leftViewMode = UITextFieldViewMode.Always
        textField?.addTarget(self, action: "textFieldStart", forControlEvents: UIControlEvents.EditingDidBegin)
        textField?.addTarget(self, action: "textFieldEnd", forControlEvents: [UIControlEvents.EditingDidEnd, UIControlEvents.EditingDidEndOnExit])
        view.addSubview(textField!)
        setLoader(textField!)
        
        
        nav2 = UIView(frame: CGRect(x: self.view.frame.width * 0.8, y: 0, width: self.view.frame.width * 0.1, height: self.view.frame.height))
        view.addSubview(nav2!)
        share = UIButton(type: UIButtonType.Custom)
        share?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        share?.setImage(UIImage(named: NavImages.bookmark), forState: UIControlState.Normal)
        share?.setImage(UIImage(named: NavImages.bookmark)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        share?.contentEdgeInsets = edge
        
        menu = UIButton(type: UIButtonType.Custom)
        menu?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        menu?.setImage(UIImage(named: NavImages.menu), forState: UIControlState.Normal)
        menu?.setImage(UIImage(named: NavImages.menu)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        menu?.contentEdgeInsets = edge
        
        nav2?.addSubview(menu!)
        nav2?.addSubview(share!)
        
        view.addSubview(nav2!)
        clock = SFClock(frame: CGRect(x: 0, y: 0, width: 43, height: 43))
        view.addSubview(clock!)
       


    }
    func setLoader(viewToAd : UIView){
        gradient = CAGradientLayer()
        gradient?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        gradient?.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient?.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient!.colors =  [UIColor.whiteColor().colorWithAlphaComponent(0.7).CGColor, UIColor.whiteColor().CGColor, UIColor.whiteColor().colorWithAlphaComponent(0.9).CGColor]
        gradient?.cornerRadius = viewToAd.frame.height * 0.05
        gradient!.locations = [0.0, 1.0, 1.0]
        gradient!.frame = CGRect(x: 0, y: 0, width: 1, height: viewToAd.frame.height * 0.08)
        mask = CALayer()
        mask!.frame = viewToAd.bounds
        mask!.cornerRadius = mask!.frame.height * 0.5
        mask!.masksToBounds = true
        mask!.name = "Mask"
        viewToAd.layer.addSublayer(mask!)
        mask!.addSublayer(gradient!)
        showHideProgressBar(on: false)
    }
    func setProgress(percent : CGFloat){
        if sizeOfPro.height == lineWidth(){
            sizeOfPro = CGSize(width: 1, height: textField!.frame.height * 0.08)
           
            showHideProgressBar(on: true)
            
        }
        let progress = textField!.bounds.width * percent
        let duration = (percent + 1.0) - (sizeOfPro.width / textField!.frame.width)
        print(duration)
        let basicAnim = CABasicAnimation(keyPath: "bounds.size.width")
        basicAnim.fromValue = sizeOfPro.width
        basicAnim.toValue = progress
        basicAnim.duration = CFTimeInterval(duration)
        basicAnim.removedOnCompletion = false
        basicAnim.fillMode = kCAFillModeForwards
        gradient?.addAnimation(basicAnim, forKey: "progress")
        
        sizeOfPro = CGSize(width: progress, height: textField!.frame.height * 0.08)
        if percent == 1.0{
            delay(NSTimeInterval(duration), closure: { () -> () in
                self.showHideProgressBar(on: false)
               self.sizeOfPro = CGSize(width: 1, height: lineWidth())

            })
                    }
    }
    func showHideProgressBar(on on : Bool){
        let basicAnim = CABasicAnimation(keyPath: "bounds.size")
       
        basicAnim.fromValue = on ? NSValue(CGSize: CGSize(width: sizeOfPro.width, height: lineWidth())) : NSValue(CGSize: CGSize(width: sizeOfPro.width, height: sizeOfPro.height))
        basicAnim.toValue = on ? NSValue(CGSize: CGSize(width: sizeOfPro.width, height: sizeOfPro.height)) : NSValue(CGSize: CGSize(width: sizeOfPro.width, height: lineWidth()))
        basicAnim.duration = 0.3
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.removedOnCompletion = false
        self.gradient!.addAnimation(basicAnim, forKey: "j")
    }
    func textFieldStart(){
        let basicAnim0 = CABasicAnimation(keyPath: "backgroundColor")
        basicAnim0.fromValue = self.view.backgroundColor!.colorWithAlphaComponent(0.0001).CGColor
        basicAnim0.toValue = self.view.backgroundColor!.CGColor
        basicAnim0.duration = 0.01
        basicAnim0.fillMode = kCAFillModeForwards
        basicAnim0.removedOnCompletion = false
        textField?.layer.addAnimation(basicAnim0, forKey: "shadow24")
        let basicAnim = CABasicAnimation(keyPath: "shadowRadius")
        basicAnim.toValue = 6
        basicAnim.duration = 0.2
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.removedOnCompletion = false
        textField?.layer.addAnimation(basicAnim, forKey: "shadow")
        let basicAnim1 = CABasicAnimation(keyPath: "shadowColor")
        basicAnim1.fromValue = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        basicAnim1.toValue = UIColor.whiteColor().colorWithAlphaComponent(1).CGColor
        basicAnim1.duration = 0.2
        basicAnim1.fillMode = kCAFillModeForwards
        basicAnim1.removedOnCompletion = false
        textField?.layer.addAnimation(basicAnim1, forKey: "shadow2")
        let basicAnim2 = CABasicAnimation(keyPath: "shadowOffset")
        basicAnim2.fromValue = NSValue(CGSize: CGSize(width: 0, height: lineWidth()))
        basicAnim2.toValue = NSValue(CGSize: CGSize(width: 0, height: 0))
        basicAnim2.duration = 0.2
        basicAnim2.fillMode = kCAFillModeForwards
        basicAnim2.removedOnCompletion = false
        textField?.layer.addAnimation(basicAnim2, forKey: "shadow3")
    }
    func textFieldEnd(){
        
        let basicAnim0 = CABasicAnimation(keyPath: "backgroundColor")
        basicAnim0.fromValue = self.view.backgroundColor!.CGColor
        basicAnim0.toValue = self.view.backgroundColor!.colorWithAlphaComponent(0.001).CGColor
        basicAnim0.duration = 0.01
        basicAnim0.fillMode = kCAFillModeForwards
        basicAnim0.removedOnCompletion = false
        textField?.layer.addAnimation(basicAnim0, forKey: "shadow24")
        let basicAnim = CABasicAnimation(keyPath: "shadowRadius")
        basicAnim.fromValue = 6
        basicAnim.toValue = 0
        basicAnim.duration = 0.2
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.removedOnCompletion = false
        textField?.layer.addAnimation(basicAnim, forKey: "shadow")
        let basicAnim1 = CABasicAnimation(keyPath: "shadowColor")
        basicAnim1.fromValue = UIColor.whiteColor().colorWithAlphaComponent(1).CGColor
        basicAnim1.toValue = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        basicAnim1.duration = 0.2
        basicAnim1.fillMode = kCAFillModeForwards
        basicAnim1.removedOnCompletion = false
        textField?.layer.addAnimation(basicAnim1, forKey: "shadow2")
        let basicAnim2 = CABasicAnimation(keyPath: "shadowOffset")
        basicAnim2.fromValue = NSValue(CGSize: CGSize(width: 0, height: 0))
        basicAnim2.toValue = NSValue(CGSize: CGSize(width: 0, height: lineWidth()))
        basicAnim2.duration = 0.2
        basicAnim2.fillMode = kCAFillModeForwards
        basicAnim2.removedOnCompletion = false
        textField?.layer.addAnimation(basicAnim2, forKey: "shadow3")
        
        
    }
    func fire(){
        print("tap")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let nav = nav1 {
        
        if view.frame.width == 320{
            menu?.hidden = true
            forward?.hidden = true
            home?.hidden = true
            clock?.hidden = true
            nav.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.26, height: self.view.frame.height)
            nav2?.frame = CGRect(x: self.view.frame.width * 0.82, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 0, width: self.view.frame.width * 0.59, height: 35)
            
            textField?.center.y = nav.frame.height * 0.5
            
            var points = [CGPoint]()
            for i in 1...3{
                points.append(CGPoint(x: ((nav.frame.width - 28) / 4) * CGFloat(i) + 28, y: 45 * 0.5))
            }
            print(points)
            back?.center = CGPoint(x: 28, y: 45 * 0.5)
            forward?.center = points[0]
            reload?.center = points[1]
            stop?.center = points[1]
            home?.center = points[2]
            share?.center = CGPoint(x: 28, y: 45 * 0.5)
            menu?.center = points[1]
            

        }else if view.frame.width == 507{
            clock?.hidden = true
            menu?.hidden = false
            forward?.hidden = false
            home?.hidden = false
            nav.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.26, height: self.view.frame.height)
            nav2?.frame = CGRect(x: self.view.frame.width * 0.85, y: 0, width: self.view.frame.width * 0.1, height: self.view.frame.height)
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 0, width: self.view.frame.width * 0.61, height: 35)
            textField?.center.y = nav.frame.height * 0.5
            clock?.center = CGPoint(x: self.view.frame.width - (45 * 0.5) - 1, y: nav.frame.height * 0.5)
            var points = [CGPoint]()
            for i in 1...3{
            points.append(CGPoint(x: ((nav.frame.width - 28) / 4) * CGFloat(i) + 28, y: 45 * 0.5))
            }
            back?.center = CGPoint(x: 28, y: 45 * 0.5)
            forward?.center = points[0]
            reload?.center = points[1]
            stop?.center = points[1]
            home?.center = points[2]
            share?.center = CGPoint(x: 28, y: 45 * 0.5)
            menu?.center = CGPoint(x: points[0].x + 3, y: 45 * 0.5)
            
            
        }else if view.frame.width == 694{
            clock?.hidden = true
            forward?.hidden = false
            menu?.hidden = false
            home?.hidden = false
            nav.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.26, height: self.view.frame.height)
            nav2?.frame = CGRect(x: self.view.frame.width * 0.87, y: 0, width: self.view.frame.width * 0.1, height: self.view.frame.height)
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 0, width: self.view.frame.width * 0.64, height: 35)
            textField?.center.y = nav.frame.height * 0.5
            clock?.center = CGPoint(x: self.view.frame.width - (45 * 0.5) - 1, y: nav.frame.height * 0.5)
            var points = [CGPoint]()
            for i in 1...3{
                points.append(CGPoint(x: ((nav.frame.width - 28) / 4) * CGFloat(i) + 28, y: 45 * 0.5))
            }
            back?.center = CGPoint(x: 28, y: 45 * 0.5)
            forward?.center = points[0]
            reload?.center = points[1]
            stop?.center = points[1]
            home?.center = points[2]
            share?.center = CGPoint(x: 28, y: 45 * 0.5)
            menu?.center = points[0]
            
            
        }else if view.frame.width == 438{
            clock?.hidden = true
            menu?.hidden = true
            forward?.hidden = false
            home?.hidden = false
            nav.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.26, height: self.view.frame.height)
            nav2?.frame = CGRect(x: self.view.frame.width * 0.87, y: 0, width: self.view.frame.width * 0.1, height: self.view.frame.height)
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 0, width: self.view.frame.width * 0.65, height: 35)
            textField?.center.y = nav.frame.height * 0.5
            clock?.center = CGPoint(x: self.view.frame.width - (45 * 0.5) - 1, y: nav.frame.height * 0.5)
            var points = [CGPoint]()
            for i in 1...3{
                points.append(CGPoint(x: ((nav.frame.width - 28) / 4) * CGFloat(i) + 28, y: 45 * 0.5))
            }
            back?.center = CGPoint(x: 28, y: 45 * 0.5)
            forward?.center = points[0]
            reload?.center = points[1]
            stop?.center = points[1]
            home?.center = points[2]
            share?.center = CGPoint(x: 28, y: 45 * 0.5)
            menu?.center = points[0]

            }
        else{
            menu?.hidden = false
            clock?.hidden = false
            forward?.hidden = false
            home?.hidden = false
            nav.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.26, height: self.view.frame.height)
            nav2?.frame = CGRect(x: self.view.frame.width * 0.83, y: 0, width: self.view.frame.width * 0.1, height: self.view.frame.height)
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 0, width: self.view.frame.width * 0.59, height: 35)
            textField?.center.y = nav.frame.height * 0.5
            clock?.center = CGPoint(x: self.view.frame.width - (45 * 0.5) - 1, y: nav.frame.height * 0.5)
            var points = [CGPoint]()
            for i in 1...3{
                points.append(CGPoint(x: ((nav.frame.width - 28) / 4) * CGFloat(i) + 28, y: 45 * 0.5))
            }
            back?.center = CGPoint(x: 28, y: 45 * 0.5)
            forward?.center = points[0]
            reload?.center = points[1]
            stop?.center = points[1]
            home?.center = points[2]
            share?.center = CGPoint(x: 28, y: 45 * 0.5)
            menu?.center = points[0]

            }
        }
        mask!.frame = textField!.bounds
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
