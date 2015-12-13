//
//  ViewController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var tabsContentController : SFTabsContentController?
    var urlBar : SFUrlBar?
    var tabBar : SFTabsController?
    var blur : UIVisualEffectView?
    var overlayerView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tabsContentController = SFTabsContentController()
        addChildViewController(tabsContentController!)
       
        view.addSubview(tabsContentController!.view)
        tabsContentController?.view.snp_makeConstraints { (make) -> Void in
            make.top.left.right.bottom.equalTo(0)
        }
        blur = UIVisualEffectView(frame: CGRect.zero)
       
        blur?.layer.masksToBounds = true
        blur?.effect = UIBlurEffect(style: NSUserDefaults.standardUserDefaults().boolForKey("pr") ? UIBlurEffectStyle.Dark : UIBlurEffectStyle.Light)
        
       view.addSubview(blur!)
        blur?.snp_makeConstraints{ (make) -> Void in
            make.left.top.right.equalTo(0)
            make.height.equalTo(68)
        }

        urlBar = SFUrlBar()
        addChildViewController(urlBar!)
        view.addSubview(urlBar!.view)
        urlBar?.view.snp_makeConstraints { (make) -> Void in
            make.top.height.equalTo(45)
            make.right.left.equalTo(0)
            
        }
        tabBar = SFTabsController()
        tabBar?.tabContentDelegate = tabsContentController
        tabBar?.urlBarManagment = urlBar
        addChildViewController(tabBar!)
        
        view.addSubview(tabBar!.view)
        tabBar?.view.snp_makeConstraints { (make) -> Void in
            make.right.top.equalTo(0)
            make.left.equalTo(3)
            make.height.equalTo(45)
        }
        //tabContent?.tabDelegate = tabBar
        
        
        view.backgroundColor = UIColor(rgba: "#F7F7F7")
       
        let intro = SFIntroViewController()
        addChildViewController(intro)
        addSubviewSafe(intro.view)
        intro.view.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.view)
            make.center.equalTo(self.view)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "privateMode", name: "PRIVATE", object: nil)
    }
    func privateMode(){
         blur?.effect = UIBlurEffect(style: NSUserDefaults.standardUserDefaults().boolForKey("pr") ? UIBlurEffectStyle.Dark : UIBlurEffectStyle.Light)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     
            }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

