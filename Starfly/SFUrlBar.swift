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

class SFUrlBar: UIViewController, UIGestureRecognizerDelegate, SFUrlBarManagment {
    
    var navigation : SFNavigationView?
    var chrome : SFChromeView?
    var textView : SFTextView?
    var main : UIStackView?
    var menuVisible = false
    
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
        
    }
    func setup(){
        navigation = SFNavigationView()
        navigation?.setup()
        chrome = SFChromeView()
        chrome?.setup()
        textView = SFTextView()
        textView?.setup()
        
        main = UIStackView(arrangedSubviews: [navigation!, textView!, chrome!])
        main?.distribution = .FillProportionally
        addSubviewSafe(main)
        main?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.right.left.equalTo(0)
            make.height.equalTo(45)
        })
        navigation?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(self.view).multipliedBy(0.24)
        })
        chrome?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(self.view).multipliedBy(0.17)
        })
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeEx", name: "CLOSE", object: nil)
    }

    func shareScreen(){
        if let current = currentWebVC where current.modeOfWeb != .home{
            let dictionary = NSMutableDictionary()
            if current.webView!.URL != nil && current.favicon != nil && current.webView!.title != nil{
            dictionary.setObject(current.webView!.URL!.absoluteString, forKey: "url")
            dictionary.setObject(current.webView!.title!, forKey: "title")
            dictionary.setObject(current.favicon!, forKey: "image")
            let image = current.webView?.scrollView.takeSnapshotForFavorites(90)
            dictionary.setObject(image!, forKey: "imageScreenShoot")
            }
            if dictionary.count > 0{
                let share = SFShare(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.window!.frame.height))
                self.view.window?.rootViewController!.view.addSubview(share)
                share.setUpME(dictionary)
            }
        }
        
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    
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
            self.view.window?.removeGestureRecognizer(sender)
      
        }
    }
   
    
    func closeEx(){
        closeMenu()
        textView?.hideCompletions()
    }
    func showMenu(){
        if textView!.textField!.isFirstResponder(){return}
        if !menuVisible{
            menuVisible = true
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
            menuVisible = false
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
    func setWebVC(webVC : SFWebVC?){
        if webVC != nil{
            currentWebVC = webVC
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.frame.width == 320{
            chrome?.clock?.superview?.hidden = true
            navigation?.forwardButton?.hidden = true
            navigation?.homeButton?.hidden = true
            chrome?.menuButton?.hidden = true
        }else if view.frame.width == 507{
            chrome?.clock?.superview?.hidden = true
            navigation?.forwardButton?.hidden = false
            navigation?.homeButton?.hidden = true
            chrome?.menuButton?.hidden = false
        }else if view.frame.width == 694{
            chrome?.clock?.superview?.hidden = true
            navigation?.forwardButton?.hidden = false
            navigation?.homeButton?.hidden = true
            chrome?.menuButton?.hidden = false
        }else if view.frame.width == 438{
            chrome?.clock?.superview?.hidden = true
            navigation?.forwardButton?.hidden = false
            navigation?.homeButton?.hidden = true
            chrome?.menuButton?.hidden = false
        }else{
            chrome?.clock?.superview?.hidden = false
            navigation?.forwardButton?.hidden = false
            navigation?.homeButton?.hidden = false
            chrome?.menuButton?.hidden = false
        }
        
        delay(0.3) { () -> () in
           //// print(self.textField!.bounds)
            ///self.textFieldMask!.frame = self.textField!.bounds
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
