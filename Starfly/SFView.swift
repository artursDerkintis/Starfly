//
//  SFView.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
var currentColor : UIColor?
class SFView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentColor = SFColors.orange
        backgroundColor = currentColor
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
