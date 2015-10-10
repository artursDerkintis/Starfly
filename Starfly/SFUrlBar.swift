//
//  SFUrlBar.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
protocol SFUrlBarManagment{
    func setObservers(webVC : SFWebVC?)
}

class SFUrlBar: UIViewController, SFUrlBarManagment, UIGestureRecognizerDelegate {
    var nav1, nav2 : UIView?
    var back, forward, stop, reload, home, share, menu : UIButton?
    
    var textField : UITextField?
    var gradient : CAGradientLayer?
    var sizeOfPro : CGSize = CGSize(width: 1, height: lineWidth())
    var percent : CGFloat = 0.0
    var clock : SFClock?
    var mask : CALayer?
    var currentWebVC : SFWebVC?
    var outsideListener : UITapGestureRecognizer?
    var search : SFSearchTable?
    var keyboardHeight : CGFloat = 0
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
        back?.setImage(UIImage(named: Images.back), forState: UIControlState.Normal)
        back?.setImage(UIImage(named: Images.back)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        back?.setImage(UIImage(named: Images.back)?.imageWithColor(UIColor(white: 0.9, alpha: 1.0)), forState: UIControlState.Disabled)
       
        back?.contentEdgeInsets = edge
        
        forward = UIButton(type: UIButtonType.Custom)
        forward?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        forward?.setImage(UIImage(named: Images.forward), forState: UIControlState.Normal)
        forward?.setImage(UIImage(named: Images.forward)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        forward?.setImage(UIImage(named: Images.forward)?.imageWithColor(UIColor(white: 0.9, alpha: 1.0)), forState: UIControlState.Disabled)
        forward?.contentEdgeInsets = edge
        
        
        reload = UIButton(type: UIButtonType.Custom)
        reload?.frame = CGRect(x: 0, y: 0, width: 46, height: 45)
        reload?.setImage(UIImage(named: Images.reload), forState: UIControlState.Normal)
        reload?.setImage(UIImage(named: Images.reload)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        reload?.contentEdgeInsets = edge
        
        stop = UIButton(type: UIButtonType.Custom)
        stop?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        stop?.setImage(UIImage(named: Images.stop), forState: UIControlState.Normal)
        stop?.setImage(UIImage(named: Images.stop)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        stop?.contentEdgeInsets = edge
        stop?.hidden = true
        
        home = UIButton(type: UIButtonType.Custom)
        home?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        home?.setImage(UIImage(named: Images.home), forState: UIControlState.Normal)
        home?.setImage(UIImage(named: Images.home)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        home?.contentEdgeInsets = edge
        
        nav1?.addSubview(back!)
        nav1?.addSubview(forward!)
        nav1?.addSubview(reload!)
        nav1?.addSubview(stop!)
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
        textField?.attributedPlaceholder = NSAttributedString(string: "Search or Type URL", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.8)])
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
        textField?.addTarget(self, action: "textEnter", forControlEvents: UIControlEvents.EditingDidEndOnExit)
        textField?.addTarget(self, action: "textFieldEditing", forControlEvents: UIControlEvents.EditingChanged)
        view.addSubview(textField!)
        setLoader(textField!)
        let doubleTap = UITapGestureRecognizer(target: self, action: "showFullURL")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.accessibilityValue = "double"
        doubleTap.delegate = self
        textField!.addGestureRecognizer(doubleTap)
        
        
        nav2 = UIView(frame: CGRect(x: self.view.frame.width * 0.8, y: 0, width: self.view.frame.width * 0.1, height: self.view.frame.height))
        view.addSubview(nav2!)
        share = UIButton(type: UIButtonType.Custom)
        share?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        share?.setImage(UIImage(named: Images.bookmark), forState: UIControlState.Normal)
        share?.setImage(UIImage(named: Images.bookmark)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        share?.setImage(UIImage(named: Images.bookmarkFill), forState: UIControlState.Selected)
        share?.contentEdgeInsets = edge
        share?.tag = 0
        share?.addTarget(self, action: "shareSreen:", forControlEvents: UIControlEvents.TouchDown)
        menu = UIButton(type: UIButtonType.Custom)
        menu?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        menu?.setImage(UIImage(named: Images.menu), forState: UIControlState.Normal)
        menu?.setImage(UIImage(named: Images.menu)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        menu?.setImage(UIImage(named: Images.closeTab), forState: UIControlState.Selected)
        menu?.contentEdgeInsets = edge
        menu?.tag = 0
        menu?.addTarget(self, action: "showMenu:", forControlEvents: UIControlEvents.TouchDown)
        nav2?.addSubview(menu!)
        nav2?.addSubview(share!)
        
        view.addSubview(nav2!)
        clock = SFClock(frame: CGRect(x: 0, y: 0, width: 43, height: 43))
        view.addSubview(clock!)
        addTargets()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeEx", name: "CLOSE", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "UPDATE", object: nil)
    }
    func showFullURL(){
        let url = currentWebVC?.webView?.URL?.absoluteString
        if let u = url {
            textField?.text = u
        }
    }
    func shareSreen(sender: SFButton){
        if let current = currentWebVC where current.modeOfWeb != .home{
            
            
            let dictionary = NSMutableDictionary()
            if current.webView!.URL != nil && current.favicon != nil && current.webView!.title != nil{
            dictionary.setObject(current.webView!.URL!.absoluteString, forKey: "url")
            dictionary.setObject(current.webView!.title!, forKey: "title")
            dictionary.setObject(current.favicon!, forKey: "image")
            let image = current.webView?.scrollView.takeSnapshotForHomePage()
            dictionary.setObject(image!, forKey: "imageScreenShoot")
            }
            if dictionary.count > 0{
                let share = SFShare(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.window!.frame.height))
                self.view.window?.rootViewController!.view.addSubview(share)
                share.setUpME(dictionary)
            }
        }
        
    }
    func closeEx(){
        expand(false, height: 0)
        
        if textField!.isFirstResponder(){
            textField?.resignFirstResponder()
        }
    }
    func expand(on : Bool, height : CGFloat){
        if self.view.viewWithTag(100000)  != nil{
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseInOut,  animations: { () -> Void in
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: on ? height + 45 : 45)
                self.view.viewWithTag(100000)?.frame.size.height = on ? height : 0
                
                }) { (e) -> Void in
                    
                    if !on {
                        self.menu?.tag = 0
                        self.share?.tag = 0
                        self.menu?.selected = false
                        self.view.viewWithTag(100000)?.removeFromSuperview()
                        self.search?.removeFromSuperview()
                        self.search = nil
                        if self.outsideListener != nil{
                            self.view.window?.removeGestureRecognizer(self.outsideListener!)
                        }
                        
                    }else{
                        self.outsideListener = UITapGestureRecognizer(target: self, action: "close:")
                        
                        self.view.window?.addGestureRecognizer(self.outsideListener!)
                        self.outsideListener!.delegate = self
                    }
            }
        }
        
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.accessibilityValue == "double"{
            return true
        }
        let loc = gestureRecognizer.locationInView(self.view.superview)
        if !CGRectContainsPoint(self.view.frame, loc){
            return false
        }
        return true
    }
    func close(sender: UITapGestureRecognizer){
        let loc = sender.locationInView(self.view.superview)
        if !CGRectContainsPoint(self.view.frame, loc){
            expand(false, height: 0)
            menu?.tag = 0
            share?.tag = 0
            menu?.selected = false
            self.view.window?.removeGestureRecognizer(sender)
      
        }
    }
   
    
    func keyboardWillHide(not : NSNotification){
        expand(false, height: 1)
        
    }
    func keyboardWillShow(notification: NSNotification) {
        if textField!.isFirstResponder(){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            keyboardHeight = keyboardSize.height

            }}
    }
    func showMenu(sender : SFButton){
        if textField!.isFirstResponder() {return}
        
        if sender.tag == 0{
            
            sender.selected = true
            sender.tag = 1
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let hostView = UIView(frame: CGRect(x: 0, y: 45, width: self.view.frame.width, height: 0))
                hostView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
                hostView.layer.cornerRadius = 20
                hostView.backgroundColor = UIColor.clearColor()
                hostView.layer.masksToBounds = true
                self.view.addSubview(hostView)
                let history = SFHistory(frame: CGRect.zero)
                let bookmarks = SFBookmarksTable(frame: CGRect.zero)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    history.load()
                    bookmarks.load()
                })
                
                let stackView = UIStackView(arrangedSubviews: [bookmarks, history])
                stackView.distribution = .FillEqually
                stackView.spacing = 35
                hostView.addSubview(stackView)
                history.tableView?.backgroundColor = UIColor(white: 0.9, alpha: 0.7)
                history.tableView?.frame = history.bounds
                history.tableView?.layer.borderWidth = 2
                history.tableView?.layer.borderColor = UIColor.whiteColor().CGColor
                history.blur?.hidden = true
                history.laye.hidden = true
                bookmarks.tableView?.frame = bookmarks.bounds
                bookmarks.backgroundColor = UIColor(white: 0.9, alpha: 0.7)
                bookmarks.tableView?.layer.borderWidth = 2
                bookmarks.tableView?.layer.borderColor =  UIColor.whiteColor().CGColor
                bookmarks.blur?.hidden = true
                bookmarks.laye.hidden = true
                let settings = SFSettings(frame: CGRect(x: 0, y: 510 - 45, width: self.view.frame.width, height: 90))
                
                hostView.tag = 100000
                hostView.addSubview(settings)
                stackView.snp_makeConstraints { (make) -> Void in
                    make.top.equalTo(30)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.bottom.equalTo(-90)
                }
                settings.snp_makeConstraints { (make) -> Void in
                    make.top.equalTo(stackView.snp_bottomMargin)
                    make.bottom.left.right.equalTo(0)
                }
                
                self.expand(true, height: 555)

            })
            
        }else{
            sender.tag = 0
            sender.selected = false
            expand(false, height: 0)
            
            
            
        }
        
    }
    
    func addTargets(){
        back?.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchDown)
        forward?.addTarget(self, action: "goForward", forControlEvents: UIControlEvents.TouchDown)
        reload?.addTarget(self, action: "reloadPage", forControlEvents: UIControlEvents.TouchDown)
        stop?.addTarget(self, action: "stopPage", forControlEvents: UIControlEvents.TouchDown)
        home?.addTarget(self, action: "goHome", forControlEvents: UIControlEvents.TouchDown)
        
    }
    func goHome(){
        currentWebVC?.openURL(nil)
    }
    func goBack(){
        currentWebVC?.webView?.goBack()
    }
    func goForward(){
        currentWebVC?.webView?.goForward()
    }
    func reloadPage(){
        currentWebVC?.webView?.reload()
    }
    func stopPage(){
        currentWebVC?.webView?.stopLoading()
    }
    
    func setObservers(webVC : SFWebVC?){
        if webVC != nil{
        currentWebVC = webVC
        updateInstantly()
        }
    }
    
    func update(notification : NSNotification){
        if let webVC = notification.object{
            if webVC.isKindOfClass(SFWebVC){
                if (webVC as! SFWebVC) == currentWebVC{
                    updateInstantly()
                }
            }
        }
    }
    func updateInstantly(){
        if currentWebVC != nil{
            if !textField!.isFirstResponder(){
                textField?.text = shortURL(currentWebVC!.webView!.URL) as String
            }
        back?.enabled = currentWebVC!.webView!.canGoBack
        forward?.enabled = currentWebVC!.webView!.canGoForward
        let l = currentWebVC!.webView!.loading
        if l {
            setProgress(CGFloat(currentWebVC!.webView!.estimatedProgress))
        }else{
            showHideProgressBar(on: false, animated: false)
        }
        stop?.hidden = l ? false : true
        reload?.hidden = l ? true : false
        }
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
        showHideProgressBar(on: false, animated: false)
    }
    func setProgress(percent : CGFloat){
        if sizeOfPro.height == lineWidth(){
            sizeOfPro = CGSize(width: 1, height: textField!.frame.height * 0.08)
           
            showHideProgressBar(on: true, animated: true)
            
        }
        let progress = textField!.bounds.width * percent
        let duration = percent - (sizeOfPro.width / textField!.frame.width)
        
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
                self.showHideProgressBar(on: false, animated: true)
               self.sizeOfPro = CGSize(width: 1, height: lineWidth())

            })
                    }
    }
    func showHideProgressBar(on on : Bool, animated : Bool){
        let basicAnim = CABasicAnimation(keyPath: "bounds.size")
       
        basicAnim.fromValue = on ? NSValue(CGSize: CGSize(width: sizeOfPro.width, height: lineWidth())) : NSValue(CGSize: CGSize(width: sizeOfPro.width, height: sizeOfPro.height))
        basicAnim.toValue = on ? NSValue(CGSize: CGSize(width: sizeOfPro.width, height: sizeOfPro.height)) : NSValue(CGSize: CGSize(width: sizeOfPro.width, height: lineWidth()))
        basicAnim.duration = animated ? 0.3 : 0.0
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.removedOnCompletion = false
        self.gradient!.addAnimation(basicAnim, forKey: "j")
    }
    func textFieldStart(){
        delay(0.2) { () -> () in
            self.textField!.selectedTextRange = self.textField!.textRangeFromPosition(self.textField!.beginningOfDocument, toPosition: self.textField!.endOfDocument)
            self.showCompletions()
        }
        
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
    func showCompletions(){
        expand(false, height: 0)
        let stackView = UIStackView(frame: CGRect.zero)
        view.addSubview(stackView)
        
        stackView.distribution = .FillEqually
        stackView.spacing = 35
        stackView.tag = 100000
        stackView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(60)
            make.height.equalTo(0)
            make.width.equalTo(self.view)
        }
        search = SFSearchTable(frame: CGRect.zero)
        stackView.addArrangedSubview(search!)
        stackView.alpha = 0.0
        stackView.hidden = true
        
        
    }
    func textFieldEditing(){
        if let stackView = self.view.viewWithTag(100000){
        if stackView.hidden{
            stackView.hidden = false
            stackView.snp_removeConstraints()
            stackView.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(60)
                make.bottom.equalTo(-35)
                make.right.equalTo(-35)
                make.left.equalTo(35)
            }
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseInOut,  animations: { () -> Void in
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.window!.frame.height - self.keyboardHeight - 50)
                stackView.alpha = 1.0
                stackView.layoutIfNeeded()
            }) { (e) -> Void in
                
            }
            }}
        search?.getSuggestions(forText: textField!.text!)
    }
    func textEnter(){
       NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: nil, userInfo: ["url" : self.textField!.text!])
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
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 5, width: self.view.frame.width * 0.59, height: 35)
            
           
            
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
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 5, width: self.view.frame.width * 0.61, height: 35)

            clock?.frame = CGRect(x: self.view.frame.width - clock!.frame.width  * 1.05, y: 1, width: clock!.frame.width, height: clock!.frame.height)
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
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 5, width: self.view.frame.width * 0.64, height: 35)
        
            clock?.frame = CGRect(x: self.view.frame.width - clock!.frame.width  * 1.05, y: 1, width: clock!.frame.width, height: clock!.frame.height)
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
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 5, width: self.view.frame.width * 0.65, height: 35)

            clock?.frame = CGRect(x: self.view.frame.width - clock!.frame.width  * 1.05, y: 1, width: clock!.frame.width, height: clock!.frame.height)
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
            textField?.frame = CGRect(x: self.view.frame.width * 0.24, y: 5, width: self.view.frame.width * 0.59, height: 35)
          
            clock?.frame = CGRect(x: self.view.frame.width - clock!.frame.width  * 1.05, y: 1, width: clock!.frame.width, height: clock!.frame.height)
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
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
