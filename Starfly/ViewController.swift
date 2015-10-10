//
//  ViewController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tabContent : SFTabContents?
    var urlBar : SFUrlBar?
    var tabBar : SFTabs?
    var blur : UIVisualEffectView?
    var overlayerView : UIView?
    let image = UIImageView(image: UIImage(named: "splash"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabContent = SFTabContents()
        addChildViewController(tabContent!)
        tabContent?.view.frame = self.view.bounds
        tabContent?.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        view.addSubview(tabContent!.view)
        blur = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90 - (45 * 0.5)))
       
        blur?.layer.masksToBounds = true
        blur?.effect = UIBlurEffect(style: NSUserDefaults.standardUserDefaults().boolForKey("pr") ? UIBlurEffectStyle.Dark : UIBlurEffectStyle.Light)
        blur!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        view.addSubview(blur!)
       

        urlBar = SFUrlBar()
        addChildViewController(urlBar!)
        urlBar?.view.frame = CGRect(x: 0, y: 45, width: self.view.frame.width, height: 45)
        urlBar?.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        view.addSubview(urlBar!.view)
        
        tabBar = SFTabs()
        tabBar?.tabManagment = tabContent
        tabBar?.urlBarManagment = urlBar
        
        addChildViewController(tabBar!)
        tabBar!.view.frame = CGRect(x: 3, y: 0, width: self.view.frame.width, height: 45)
        tabBar!.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        view.addSubview(tabBar!.view)
        tabContent?.tabDelegate = tabBar
        view.backgroundColor = UIColor(rgba: "#F7F7F7")
        overlayerView = UIView(frame: CGRect.zero)
        view.addSubview(overlayerView!)
        overlayerView?.snp_makeConstraints { (make) -> Void in
            make.left.top.bottom.right.equalTo(0)
            make.width.height.equalTo(self.view)
            
        }
        overlayerView?.backgroundColor = UIColor.whiteColor()
        overlayerView?.addSubview(image)
        image.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(236)
            make.width.equalTo(240)
            make.center.equalTo(overlayerView!)
        }
        delay(0.5) { () -> () in
            UIView.animateWithDuration(0.05, animations: { () -> Void in
                
                
                self.image.transform = CGAffineTransformMakeScale(1.05, 1.05)
                }, completion: { (m) -> Void in
                    UIView.animateWithDuration(0.35, animations: { () -> Void in
                        self.overlayerView?.alpha = 0.0
                         self.image.transform = CGAffineTransformMakeScale(0.001, 0.001)
                        }, completion: { (fin) -> Void in
                             self.overlayerView?.removeFromSuperview()
                    })
               
                   
                    
                    
            })
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

