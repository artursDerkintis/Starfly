//
//  SFChromeViewController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 11/22/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFChromeView: UIView {
    var shareButton, menuButton : UIButton?
    var clock : SFClock?
    func setup(){
        
        shareButton = UIButton(type: UIButtonType.Custom)
        shareButton?.setImage(UIImage(named: Images.bookmark), forState: UIControlState.Normal)
        shareButton?.setImage(UIImage(named: Images.bookmark)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        shareButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(shareButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(shareButton!)
        }
        shareButton?.tag = SFTags.share.hashValue
        shareButton?.addTarget(self, action: "buttonHasTapped:", forControlEvents: UIControlEvents.TouchDown)
        
        
        menuButton = UIButton(type: UIButtonType.Custom)
        menuButton?.setImage(UIImage(named: Images.menu), forState: UIControlState.Normal)
        menuButton?.setImage(UIImage(named: Images.menu)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        menuButton?.setImage(UIImage(named: Images.closeTab), forState: UIControlState.Selected)
        menuButton?.tag = SFTags.menu.hashValue
        menuButton?.addTarget(self, action: "buttonHasTapped:", forControlEvents: UIControlEvents.TouchDown)
        menuButton?.imageView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(menuButton!.snp_height).multipliedBy(0.4)
            make.center.equalTo(menuButton!)
        }
        
        
        clock = SFClock(frame: CGRect(x: 0, y: 1, width: 43, height: 43))
        let clockView = UIView(frame: CGRect.zero)
        
        clockView.addSubview(clock!)
        
        clock?.frame.origin.x = clockView.frame.width - 44
        clock?.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        
        
        let stackView = UIStackView(arrangedSubviews: [shareButton!, menuButton!, clockView])
        stackView.distribution = .FillEqually
        
        addSubviewSafe(stackView)
        stackView.snp_makeConstraints { (make) -> Void in
            make.top.right.bottom.left.equalTo(0)
        }
        
    }
    func buttonHasTapped(sender: UIButton){
        switch sender.tag{
        case SFTags.menu.hashValue:
            if firstViewController()!.respondsToSelector("showMenu"){
                firstViewController()?.performSelector("showMenu")
            }
            break
        case SFTags.share.hashValue:
            if firstViewController()!.respondsToSelector("shareScreen"){
                firstViewController()?.performSelector("shareScreen")
            }
            break
        default:
            break
        }
    }
}
