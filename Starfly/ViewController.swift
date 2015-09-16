//
//  ViewController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var urlBar : SFUrlBar?
    var tabBar : SFTabs?
    var blur : UIVisualEffectView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        blur = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        blur?.effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        blur!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        view.addSubview(blur!)
        urlBar = SFUrlBar()
        addChildViewController(urlBar!)
        urlBar?.view.frame = CGRect(x: 0, y: 45, width: self.view.frame.width, height: 45)
        urlBar?.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        view.addSubview(urlBar!.view)
        
        tabBar = SFTabs()
        addChildViewController(tabBar!)
        tabBar!.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45)
        tabBar!.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        view.addSubview(tabBar!.view)
        view.backgroundColor = UIColor(rgba: "#F7F7F7")
        
            }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

