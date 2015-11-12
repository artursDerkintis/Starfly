//
//  SFMenu.swift
//  Starfly
//
//  Created by Arturs Derkintis on 10/11/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFMenu: UIView {
    
    var history : SFHistory?
    var bookmarks : SFBookmarks?
    var settings : SFSettings?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        backgroundColor = UIColor.clearColor()
        layer.masksToBounds = true
        
        history = SFHistory(frame: CGRect.zero)
        history?.shadowView?.hidden = true
        history?.blur?.hidden = true
        history!.tableView?.layer.borderWidth = 1
        history!.tableView?.layer.borderColor = UIColor.whiteColor().CGColor
        history!.tableView?.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
        history?.updateFrames(UIEdgeInsetsMake(0, 0, 0, 0))
        history?.alpha = 0.0
        
        bookmarks = SFBookmarks(frame: CGRect.zero)
        bookmarks?.shadowView?.hidden = true
        bookmarks?.blur?.hidden = true
        bookmarks!.tableView?.layer.borderWidth = 1
        bookmarks!.tableView?.layer.borderColor = UIColor.whiteColor().CGColor
        bookmarks?.tableView?.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
        bookmarks!.updateFrames(UIEdgeInsetsMake(0, 0, 0, 0))
        bookmarks?.alpha = 0.0
        
        let stackView = UIStackView(arrangedSubviews: [bookmarks!, history!])
        stackView.spacing = 35
        stackView.distribution = .FillEqually
        addSubview(stackView)
        stackView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(30)
            make.left.equalTo(15)
            make.right.equalTo(self.snp_rightMargin).inset(15)
            
            make.height.equalTo(self.snp_height).multipliedBy(0.77).priority(99)
        }
        
        
        settings = SFSettings(frame: CGRect.zero)
        addSubview(settings!)
        settings?.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(stackView.snp_bottomMargin).priority(100)
            make.bottom.right.left.equalTo(0)
            
        }
        UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.history?.alpha = 1.0
                self.bookmarks?.alpha = 1.0
            }) { (fin) -> Void in
                self.history?.load()
                self.bookmarks?.load()
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
