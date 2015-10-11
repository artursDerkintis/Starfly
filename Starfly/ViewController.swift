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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabContent = SFTabContents()
        addChildViewController(tabContent!)
       
        view.addSubview(tabContent!.view)
        tabContent?.view.snp_makeConstraints { (make) -> Void in
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
        tabBar = SFTabs()
        tabBar?.tabManagment = tabContent
        tabBar?.urlBarManagment = urlBar
        
        addChildViewController(tabBar!)
        
        view.addSubview(tabBar!.view)
        tabBar?.view.snp_makeConstraints { (make) -> Void in
            make.right.top.equalTo(0)
            make.left.equalTo(3)
            make.height.equalTo(45)
        }
        tabContent?.tabDelegate = tabBar
        view.backgroundColor = UIColor(rgba: "#F7F7F7")
        overlayerView = UIView(frame: CGRect.zero)
        view.addSubview(overlayerView!)
        overlayerView?.snp_makeConstraints { (make) -> Void in
            make.left.top.bottom.right.equalTo(0)
            make.width.height.equalTo(self.view)
            
        }
        overlayerView?.backgroundColor = UIColor.whiteColor()
        let image = UIImageView(image: UIImage(named: "splash"))
        overlayerView?.addSubview(image)
        image.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(236)
            make.width.equalTo(240)
            make.center.equalTo(overlayerView!)
        }
        delay(0.5) { () -> () in
            UIView.animateWithDuration(0.05, animations: { () -> Void in
                
                
                image.transform = CGAffineTransformMakeScale(1.05, 1.05)
                }, completion: { (m) -> Void in
                    UIView.animateWithDuration(0.35, animations: { () -> Void in
                        self.overlayerView?.alpha = 0.0
                         image.transform = CGAffineTransformMakeScale(0.001, 0.001)
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

