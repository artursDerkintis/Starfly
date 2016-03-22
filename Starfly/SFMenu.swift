//
//  SFMenu.swift
//  Starfly
//
//  Created by Arturs Derkintis on 10/11/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFMenu: UIView {
    
    var settings : SFSettings!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        backgroundColor = UIColor.clearColor()
        layer.masksToBounds = true
        
        settings = SFSettings(frame: CGRect.zero)
        addSubview(settings!)
        settings?.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.bottom.right.left.equalTo(0)
            
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
