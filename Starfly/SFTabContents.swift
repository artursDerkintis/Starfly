//
//  SFTabContents.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/16/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
protocol SFTabManagment{
    func addNewTab(complete : SFTabWeb)
    func removeTab(webVC : SFWebVC)
    func switchToTab(webVC : SFWebVC)
    func addTabWithURL(url : NSURL)
    func openURLInCurentTab(url : NSURL)
    func bringHomeInFront()
}
var labelColor = UIColor.blueColor()
class SFTabContents: UIViewController, SFTabManagment {
    var tabDelegate : SFTabDelegate?
    var homeVC : SFHomeVC?
    var currentWebVC : SFWebVC?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clearColor()
        self.addHome()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openURL:", name: "OPEN", object: nil)
        
        
    }
    func bringHomeInFront() {
        if let home = homeVC{
            self.view.bringSubviewToFront(home.view)
    
            
            
        }
    }
    func openURL(not : NSNotification){
        let url = not.userInfo!["url"] as! String
        print(url)
        openURLInCurentTab(NSURL(string: parseUrl(url)!)!)
        NSNotificationCenter.defaultCenter().postNotificationName("CLOSE", object: nil)
    }
    func addHome(){
        homeVC = SFHomeVC()
        addChildViewController(homeVC!)
        homeVC?.view.frame = self.view.bounds
        homeVC?.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        view.addSubview(homeVC!.view!)
    }
    func addNewTab(complete : SFTabWeb){
        
        let webVC = SFWebVC()
        webVC.tabManagment = self
        webVC.view.frame = self.view.bounds
        webVC.view.backgroundColor = UIColor.clearColor()
        addChildViewController(webVC)
        webVC.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        view.addSubview(webVC.view)
        currentWebVC = webVC
        complete(webVC)
    }
   func addTabWithURL(url : NSURL){
        tabDelegate?.addNewTabWithURL(url)
    }
    func removeTab(webVC : SFWebVC){
        webVC.removeFromParentViewController()
        webVC.view.removeFromSuperview()
    }
    func switchToTab(webVC : SFWebVC){
        currentWebVC = webVC
        self.view.bringSubviewToFront(webVC.view)
        if webVC.modeOfWeb == .home{
            bringHomeInFront()
        }
    }
    func openURLInCurentTab(url: NSURL) {
        if let current = currentWebVC{
            
            self.view.bringSubviewToFront(current.view)
            current.openURL(url)
            
        }
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "OPEN", object: nil);
    }
    
}
