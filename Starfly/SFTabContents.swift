//
//  SFTabContents.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/16/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFTabContents: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SFColors.grey
        let webVC = SFWebVC()
        webVC.view.frame = self.view.bounds
        webVC.view.backgroundColor = UIColor.clearColor()
        
        webVC.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        view.addSubview(webVC.view)
    }
}
