//
//  SFNavigationController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 11/21/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFNavigationView: UIView{
    var backButton, forwardButton, reloadButton, stopButton, homeButton : UIButton?
   
    func setup(){
        backButton = UIButton(type: UIButtonType.Custom)
        backButton?.setImage(UIImage(named: Images.back), forState: UIControlState.Normal)
        backButton?.setImage(UIImage(named: Images.back)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        backButton?.setImage(UIImage(named: Images.back)?.imageWithColor(UIColor(white: 0.9, alpha: 1.0)), forState: UIControlState.Disabled)
        backButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(backButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(backButton!)
        }
        backButton?.tag = SFTags.goBack.hashValue
        
        forwardButton = UIButton(type: UIButtonType.Custom)
        
        forwardButton?.setImage(UIImage(named: Images.forward), forState: UIControlState.Normal)
        forwardButton?.setImage(UIImage(named: Images.forward)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        forwardButton?.setImage(UIImage(named: Images.forward)?.imageWithColor(UIColor(white: 0.9, alpha: 1.0)), forState: UIControlState.Disabled)
        forwardButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(forwardButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(forwardButton!)
        }
        
        forwardButton?.tag = SFTags.goForward.hashValue
     
        reloadButton = UIButton(type: UIButtonType.Custom)
        reloadButton?.setImage(UIImage(named: Images.reload), forState: UIControlState.Normal)
        reloadButton?.setImage(UIImage(named: Images.reload)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        reloadButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(reloadButton!.snp_height).multipliedBy(0.4)
            make.width.equalTo(reloadButton!.snp_height).multipliedBy(0.42)
            make.center.equalTo(reloadButton!)
        }
        reloadButton?.tag = SFTags.reload.hashValue
        
        stopButton = UIButton(type: UIButtonType.Custom)
        stopButton?.setImage(UIImage(named: Images.stop), forState: UIControlState.Normal)
        stopButton?.setImage(UIImage(named: Images.stop)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        stopButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(stopButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(stopButton!)
        }
        stopButton?.tag = SFTags.stop.hashValue
        
        let holderView = UIView(frame: CGRect.zero)
        holderView.addSubviewSafe(stopButton)
        holderView.addSubviewSafe(reloadButton)
        stopButton?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.right.left.bottom.equalTo(0)
        })
        reloadButton?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.right.left.bottom.equalTo(0)
        })
        
        homeButton = UIButton(type: UIButtonType.Custom)
        
        homeButton?.setImage(UIImage(named: Images.home), forState: UIControlState.Normal)
        homeButton?.setImage(UIImage(named: Images.home)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        homeButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(homeButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(homeButton!)
        }
        homeButton?.tag = SFTags.home.hashValue
        for button in [backButton, homeButton, stopButton, reloadButton, forwardButton]{
            button?.addTarget(self, action: "buttonHasTapped:", forControlEvents: UIControlEvents.TouchDown)
        }
        let stackView = UIStackView(arrangedSubviews: [backButton!, forwardButton!, holderView, homeButton!])
        stackView.distribution = .FillEqually
        addSubviewSafe(stackView)
        stackView.snp_makeConstraints { (make) -> Void in
            make.top.right.left.bottom.equalTo(0)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "UPDATE", object: nil)
        
    }
    
    func buttonHasTapped(sender : UIButton){
        //Notifies current webView to do something
        NSNotificationCenter.defaultCenter().postNotificationName("ACTION", object: getAction(SFTags(rawValue: sender.tag)!))
        
    }
    
    func update(notification : NSNotification){
        if let webVC = notification.object{
            if webVC.isKindOfClass(SFWebController){
                updateInstantly(webVC as! SFWebController)
            }
        }
    }
    
    func updateInstantly(webViewVC : SFWebController){
            backButton?.enabled = webViewVC.webView!.canGoBack
            forwardButton?.enabled = webViewVC.webView!.canGoForward
            let l =  webViewVC.webView!.loading
            stopButton?.hidden = l ? false : true
            reloadButton?.hidden = l ? true : false
    }
    



}
