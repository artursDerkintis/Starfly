//
//  SFUrlBar.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
protocol SFUrlBarManagment{
    func setWebVC(webVC : SFWebVC?)
}

class SFUrlBar: UIViewController, SFUrlBarManagment, UIGestureRecognizerDelegate {
    
    
    var main, left, right : UIStackView?
    var backButton, forwardButton, stopButton, reloadButton, homeButton, shareButton, menuButton : UIButton?
    
    
    
    var textField : UITextField?
    var textFieldMask : CALayer?
    var progressGradient : CAGradientLayer?
    var sizeOfProgress : CGSize = CGSize(width: 1, height: lineWidth())
    
    
    var clock : SFClock?
    
    
    var currentWebVC : SFWebVC?
    
    
    var outsideListener : UITapGestureRecognizer?
    var search : SFSearchTable?
    
    var menuView : SFMenu?
    
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
        backButton = UIButton(type: UIButtonType.Custom)
        backButton?.setImage(UIImage(named: Images.back), forState: UIControlState.Normal)
        backButton?.setImage(UIImage(named: Images.back)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        backButton?.setImage(UIImage(named: Images.back)?.imageWithColor(UIColor(white: 0.9, alpha: 1.0)), forState: UIControlState.Disabled)
        backButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(backButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(backButton!)
        }
        
        forwardButton = UIButton(type: UIButtonType.Custom)
       
        forwardButton?.setImage(UIImage(named: Images.forward), forState: UIControlState.Normal)
        forwardButton?.setImage(UIImage(named: Images.forward)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        forwardButton?.setImage(UIImage(named: Images.forward)?.imageWithColor(UIColor(white: 0.9, alpha: 1.0)), forState: UIControlState.Disabled)
        forwardButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(forwardButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(forwardButton!)
        }

        
        
        reloadButton = UIButton(type: UIButtonType.Custom)
        
        reloadButton?.setImage(UIImage(named: Images.reload), forState: UIControlState.Normal)
        reloadButton?.setImage(UIImage(named: Images.reload)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        reloadButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(reloadButton!.snp_height).multipliedBy(0.4)
            make.width.equalTo(reloadButton!.snp_height).multipliedBy(0.42)
            make.center.equalTo(reloadButton!)
        }
        
        stopButton = UIButton(type: UIButtonType.Custom)
       
        stopButton?.setImage(UIImage(named: Images.stop), forState: UIControlState.Normal)
        stopButton?.setImage(UIImage(named: Images.stop)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        stopButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(stopButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(stopButton!)
        }
        //stop?.hidden = true
       
        homeButton = UIButton(type: UIButtonType.Custom)
        
        homeButton?.setImage(UIImage(named: Images.home), forState: UIControlState.Normal)
        homeButton?.setImage(UIImage(named: Images.home)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        homeButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(homeButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(homeButton!)
        }
        
       
        
        
        textField = UITextField(frame: CGRect.zero)
        textField?.layer.cornerRadius = 35 * 0.5
        textField?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.4).CGColor
        textField?.layer.shadowOffset = CGSize(width: 0, height: lineWidth())
        textField?.layer.shadowOpacity = 0.6
        textField?.layer.shadowRadius = 0
        textField?.keyboardType = UIKeyboardType.WebSearch
        textField?.keyboardAppearance = UIKeyboardAppearance.Light
        textField?.autocapitalizationType = UITextAutocapitalizationType.None
        textField?.autocorrectionType = UITextAutocorrectionType.No
        
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
        
        main = UIStackView(frame: CGRect.zero)
        main?.distribution = .FillProportionally
        main?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(main!)
        
        left = UIStackView(frame: CGRect.zero)
        left?.distribution = .FillEqually
        left?.translatesAutoresizingMaskIntoConstraints = false
        left?.addArrangedSubview(backButton!)
        left?.addArrangedSubview(forwardButton!)
        left?.addArrangedSubview(reloadButton!)
        left?.addArrangedSubview(stopButton!)
        left?.addArrangedSubview(homeButton!)
        main!.addArrangedSubview(left!)
        left?.snp_makeConstraints { (make) -> Void in
            make.left.top.equalTo(0)
            make.width.equalTo(self.view).multipliedBy(0.24)
        }

        main?.snp_makeConstraints { (make) -> Void in
            make.top.right.left.equalTo(0)
            make.height.equalTo(45)
            
        }
        textField?.translatesAutoresizingMaskIntoConstraints = false
        let textFieldHolder = UIView(frame: CGRect.zero)
        textFieldHolder.addSubview(textField!)
        main!.addArrangedSubview(textFieldHolder)
        
        textField?.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.left.equalTo(0)
            make.width.equalTo(textFieldHolder)
            make.bottom.equalTo(textFieldHolder).inset(5)
        }
        setLoader(textField!)
        let doubleTap = UITapGestureRecognizer(target: self, action: "showFullURL")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.accessibilityValue = "double"
        doubleTap.delegate = self
        textField!.addGestureRecognizer(doubleTap)
        
        
        right = UIStackView(frame: CGRect.zero)
        right?.distribution = .FillEqually
        right?.translatesAutoresizingMaskIntoConstraints = false
        main!.addArrangedSubview(right!)
        right?.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.view).multipliedBy(0.17)
            
        }
        
        shareButton = UIButton(type: UIButtonType.Custom)
        shareButton?.setImage(UIImage(named: Images.bookmark), forState: UIControlState.Normal)
        shareButton?.setImage(UIImage(named: Images.bookmark)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        shareButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(shareButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(shareButton!)
        }
        shareButton?.tag = 0
        shareButton?.addTarget(self, action: "shareSreen:", forControlEvents: UIControlEvents.TouchDown)
        menuButton = UIButton(type: UIButtonType.Custom)
        menuButton?.setImage(UIImage(named: Images.menu), forState: UIControlState.Normal)
        menuButton?.setImage(UIImage(named: Images.menu)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        menuButton?.setImage(UIImage(named: Images.closeTab), forState: UIControlState.Selected)
        menuButton?.tag = 0
        menuButton?.addTarget(self, action: "showMenu:", forControlEvents: UIControlEvents.TouchDown)
        right?.addArrangedSubview(shareButton!)
        right?.addArrangedSubview(menuButton!)
        menuButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(menuButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(menuButton!)
        }
        
        clock = SFClock(frame: CGRect(x: 0, y: 1, width: 43, height: 43))
        let clockView = UIView(frame: CGRect.zero)
        
        clockView.addSubview(clock!)
        
        right?.addArrangedSubview(clockView)
        clock?.frame.origin.x = clockView.frame.width - 44
        clock?.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        addTargets()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeEx", name: "CLOSE", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "UPDATE", object: nil)
    }
    func showFullURL(){
        let url = currentWebVC?.webView?.URL?.absoluteString
        if let u = url {
            if !u.containsString("file:///"){
                textField?.text = u
            }
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
        
        
        if textField!.isFirstResponder(){
            textField?.resignFirstResponder()
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
            closeMenu()
            menuButton?.tag = 0
            shareButton?.tag = 0
            menuButton?.selected = false
            self.view.window?.removeGestureRecognizer(sender)
      
        }
    }
   
    
    
    func showMenu(sender : SFButton){
        if textField!.isFirstResponder() {return}
        if sender.tag == 0{
            sender.selected = true
            sender.tag = 1
            menuView = SFMenu(frame: CGRect.zero)
            view.addSubview(menuView!)
            menuView?.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(main!.snp_bottomMargin)
                make.width.equalTo(self.view.snp_width)
                make.left.right.bottom.equalTo(0)
                
            }
            view.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(567)
            }
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.menuView?.layoutIfNeeded()
                })
            self.outsideListener = UITapGestureRecognizer(target: self, action: "close:")
            
            self.view.window?.addGestureRecognizer(self.outsideListener!)
            self.outsideListener!.delegate = self
        }else{
            sender.tag = 0
            sender.selected = false
            closeMenu()
        }
        
    }
    func closeMenu(){
        view.snp_updateConstraints { (make) -> Void in
            make.height.equalTo(45)
        }
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.menuView?.layoutIfNeeded()
            }) { (fin) -> Void in
                if self.outsideListener != nil{
                    self.view.window?.removeGestureRecognizer(self.outsideListener!)
                }

                self.menuView?.removeFromSuperview()
        }
    }
    func addTargets(){
        backButton?.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchDown)
        forwardButton?.addTarget(self, action: "goForward", forControlEvents: UIControlEvents.TouchDown)
        reloadButton?.addTarget(self, action: "reloadPage", forControlEvents: UIControlEvents.TouchDown)
        stopButton?.addTarget(self, action: "stopPage", forControlEvents: UIControlEvents.TouchDown)
        homeButton?.addTarget(self, action: "goHome", forControlEvents: UIControlEvents.TouchDown)
        
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
    
    func setWebVC(webVC : SFWebVC?){
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
        backButton?.enabled = currentWebVC!.webView!.canGoBack
        forwardButton?.enabled = currentWebVC!.webView!.canGoForward
        let l = currentWebVC!.webView!.loading
        if l {
            setProgress(CGFloat(currentWebVC!.webView!.estimatedProgress))
        }else{
            showHideProgressBar(on: false, animated: false)
        }
        stopButton?.hidden = l ? false : true
        reloadButton?.hidden = l ? true : false
        }
    }
    
    func setLoader(viewToAd : UIView){
        progressGradient = CAGradientLayer()
        progressGradient?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        progressGradient?.startPoint = CGPoint(x: 0.0, y: 0.5)
        progressGradient?.endPoint = CGPoint(x: 1.0, y: 0.5)
        progressGradient!.colors =  [UIColor.whiteColor().colorWithAlphaComponent(0.7).CGColor, UIColor.whiteColor().CGColor, UIColor.whiteColor().colorWithAlphaComponent(0.9).CGColor]
        progressGradient?.cornerRadius = viewToAd.frame.height * 0.05
        progressGradient!.locations = [0.0, 1.0, 1.0]
        progressGradient!.frame = CGRect(x: 0, y: 0, width: 1, height: viewToAd.frame.height * 0.08)
        textFieldMask = CALayer()
        textFieldMask!.frame = viewToAd.bounds
        textFieldMask!.cornerRadius = 35 * 0.5
        textFieldMask!.masksToBounds = true
        textFieldMask!.name = "Mask"
        viewToAd.layer.addSublayer(textFieldMask!)
        textFieldMask!.addSublayer(progressGradient!)
        showHideProgressBar(on: false, animated: false)
    }
    func setProgress(percent : CGFloat){
        if sizeOfProgress.height == lineWidth(){
            sizeOfProgress = CGSize(width: 1, height: textField!.frame.height * 0.08)
           
            showHideProgressBar(on: true, animated: true)
            
        }
        let progress = textField!.bounds.width * percent
        let duration = percent - (sizeOfProgress.width / textField!.frame.width)
        
        let basicAnim = CABasicAnimation(keyPath: "bounds.size.width")
        basicAnim.fromValue = sizeOfProgress.width
        basicAnim.toValue = progress
        basicAnim.duration = CFTimeInterval(duration)
        basicAnim.removedOnCompletion = false
        basicAnim.fillMode = kCAFillModeForwards
        progressGradient?.addAnimation(basicAnim, forKey: "progress")
        
        sizeOfProgress = CGSize(width: progress, height: textField!.frame.height * 0.08)
        if percent == 1.0{
            delay(NSTimeInterval(duration), closure: { () -> () in
                self.showHideProgressBar(on: false, animated: true)
               self.sizeOfProgress = CGSize(width: 1, height: lineWidth())

            })
                    }
    }
    func showHideProgressBar(on on : Bool, animated : Bool){
        let basicAnim = CABasicAnimation(keyPath: "bounds.size")
       
        basicAnim.fromValue = on ? NSValue(CGSize: CGSize(width: sizeOfProgress.width, height: lineWidth())) : NSValue(CGSize: CGSize(width: sizeOfProgress.width, height: sizeOfProgress.height))
        basicAnim.toValue = on ? NSValue(CGSize: CGSize(width: sizeOfProgress.width, height: sizeOfProgress.height)) : NSValue(CGSize: CGSize(width: sizeOfProgress.width, height: lineWidth()))
        basicAnim.duration = animated ? 0.3 : 0.0
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.removedOnCompletion = false
        self.progressGradient!.addAnimation(basicAnim, forKey: "j")
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
        hideCompletions()
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
        search = SFSearchTable(frame: CGRect.zero)
        search?.hidden = true
        view.addSubview(search!)
        search?.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(60)
            make.height.equalTo(0)
            make.right.equalTo(-35)
            make.left.equalTo(35)
        }
       
        
    }
    func hideCompletions(){
        view.snp_updateConstraints { (make) -> Void in
            make.height.equalTo(45)
        }
        search?.snp_updateConstraints{ (make) -> Void in
            make.height.equalTo(0)
        }
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.search?.layoutIfNeeded()
            }, completion: { (fin) -> Void in
                self.search?.removeFromSuperview()
        })
        
    }

    func textFieldEditing(){
        if let sView = search{
        if sView.hidden{
            sView.hidden = false
            sView.snp_updateConstraints{ (make) -> Void in
                make.height.equalTo(220)
            }
            view.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(300)
            }
            UIView.animateWithDuration(0.5,  animations: { () -> Void in
                self.view.layoutIfNeeded()
                sView.alpha = 1.0
                sView.layoutIfNeeded()
            }) { (e) -> Void in
                
            }
            }
        }
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
        if view.frame.width == 320{
            clock?.superview?.hidden = true
            forwardButton?.hidden = true
            homeButton?.hidden = true
            menuButton?.hidden = true
        }else if view.frame.width == 507{
            clock?.superview?.hidden = true
            forwardButton?.hidden = false
            homeButton?.hidden = true
            menuButton?.hidden = false
        }else if view.frame.width == 694{
            clock!.superview?.hidden = true
            forwardButton?.hidden = false
            homeButton?.hidden = true
            menuButton?.hidden = false
        }else if view.frame.width == 438{
            clock?.superview?.hidden = true
            forwardButton?.hidden = false
            homeButton?.hidden = true
            menuButton?.hidden = false
        }else{
            clock?.superview?.hidden = false
            forwardButton?.hidden = false
            homeButton?.hidden = false
            menuButton?.hidden = false
        }
        
        delay(0.3) { () -> () in
            print(self.textField!.bounds)
            self.textFieldMask!.frame = self.textField!.bounds
        }
       
       
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
