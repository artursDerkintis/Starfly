//
//  SFSettings.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/30/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFSettings: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(frame: CGRect.zero)
        stackView.distribution = .FillEqually
        stackView.spacing = 35
        
        let privateSwitch = SFSettingsSwitch(frame: CGRect(x: 0, y: 0, width: 150, height : 40))
       
        privateSwitch.switcher?.tag = NSUserDefaults.standardUserDefaults().boolForKey("pr") == true ? 1 : 0
        privateSwitch.switcher?.setTitle("Private", forState: UIControlState.Normal)
        privateSwitch.switcher?.backgroundColor = NSUserDefaults.standardUserDefaults().boolForKey("pr") == true ? UIColor(white: 0.5, alpha: 0.5) :UIColor.clearColor()
        
        privateSwitch.switcher?.addTarget(self, action: "privateMode:", forControlEvents: UIControlEvents.TouchDown)
        
        stackView.addArrangedSubview(privateSwitch)
        let savePasswordsSwitch = SFSettingsSwitch(frame: CGRect(x:0, y: 0, width: 150, height : 40))
        
        savePasswordsSwitch.switcher?.tag = NSUserDefaults.standardUserDefaults().boolForKey("savePASS") == true ? 1 : 0
        savePasswordsSwitch.switcher?.setTitle("Enable Fillr", forState: UIControlState.Normal)
        savePasswordsSwitch.switcher?.backgroundColor = NSUserDefaults.standardUserDefaults().boolForKey("savePASS") == true ? UIColor(white: 0.5, alpha: 0.5) :UIColor.clearColor()
        
        savePasswordsSwitch.switcher?.addTarget(self, action: "passwordMode:", forControlEvents: UIControlEvents.TouchDown)
        
        stackView.addArrangedSubview(savePasswordsSwitch)
        let showTouches = SFSettingsSwitch(frame: CGRect(x:0, y: 0, width: 150, height : 40))
        
        showTouches.switcher?.tag = NSUserDefaults.standardUserDefaults().boolForKey("showT") == true ? 1 : 0
        showTouches.switcher?.setTitle("Show touches", forState: UIControlState.Normal)
        showTouches.switcher?.backgroundColor = NSUserDefaults.standardUserDefaults().boolForKey("showT") == true ? UIColor(white: 0.5, alpha: 0.5) :UIColor.clearColor()
        
        showTouches.switcher?.addTarget(self, action: "touch:", forControlEvents: UIControlEvents.TouchDown)
        
        stackView.addArrangedSubview(showTouches)
        let restoreTabs = SFSettingsSwitch(frame: CGRect(x:0, y: 0, width: 150, height : 40))
        
        restoreTabs.switcher?.tag = NSUserDefaults.standardUserDefaults().boolForKey("rest") == true ? 1 : 0
        restoreTabs.switcher?.setTitle("Restore tabs", forState: UIControlState.Normal)
        restoreTabs.switcher?.backgroundColor = NSUserDefaults.standardUserDefaults().boolForKey("rest") == true ? UIColor(white: 0.5, alpha: 0.5) :UIColor.clearColor()
        
        restoreTabs.switcher?.addTarget(self, action: "restoreTabs:", forControlEvents: UIControlEvents.TouchDown)
        
        stackView.addArrangedSubview(restoreTabs)
        addSubview(stackView)
        stackView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.height.equalTo(40)
            make.right.equalTo(self).inset(25)
        }
        let colorPlate = SFColorPlate(frame: CGRect.zero)
        addSubview(colorPlate)
        colorPlate.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(20)
        }
        
        layer.cornerRadius = 45 / 2
        layer.masksToBounds = true
        

    }
    func restoreTabs(sender : UIButton){
        NSUserDefaults.standardUserDefaults().setBool(sender.tag == 1 ? false : true, forKey: "rest")
        sender.backgroundColor = NSUserDefaults.standardUserDefaults().boolForKey("rest") == true ? UIColor(white: 0.5, alpha: 0.5) :UIColor.clearColor()
        sender.tag = NSUserDefaults.standardUserDefaults().boolForKey("rest") == true ? 1 : 0
        

    }
    func touch(sender : UIButton){
        NSUserDefaults.standardUserDefaults().setBool(sender.tag == 1 ? false : true, forKey: "showT")
        sender.backgroundColor = NSUserDefaults.standardUserDefaults().boolForKey("showT") == true ? UIColor(white: 0.5, alpha: 0.5) :UIColor.clearColor()
        sender.tag = NSUserDefaults.standardUserDefaults().boolForKey("showT") == true ? 1 : 0
        
    }
    func privateMode(sender : UIButton){
        NSUserDefaults.standardUserDefaults().setBool(sender.tag == 1 ? false : true, forKey: "pr")
        sender.backgroundColor = NSUserDefaults.standardUserDefaults().boolForKey("pr") == true ? UIColor(white: 0.5, alpha: 0.5) :UIColor.clearColor()
        
        NSNotificationCenter.defaultCenter().postNotificationName("PRIVATE", object: nil)
        sender.tag = NSUserDefaults.standardUserDefaults().boolForKey("pr") == true ? 1 : 0
    }
    func passwordMode(sender : UIButton){
        NSUserDefaults.standardUserDefaults().setBool(sender.tag == 1 ? false : true, forKey: "savePASS")
        sender.backgroundColor = NSUserDefaults.standardUserDefaults().boolForKey("savePASS") == true ? UIColor(white: 0.5, alpha: 0.5) :UIColor.clearColor()
        Fillr.sharedInstance().setEnabled(sender.tag == 1 ? false : true)
        sender.tag = NSUserDefaults.standardUserDefaults().boolForKey("savePASS") == true ? 1 : 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
class SFSettingsSwitch : UIView{
    var switcher : UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        switcher = UIButton(type: UIButtonType.Custom)
        switcher?.frame = bounds
        switcher?.layer.cornerRadius = 10
        switcher?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        switcher?.tag = 0
        switcher?.layer.borderColor = UIColor.lightGrayColor().CGColor
        switcher?.layer.borderWidth = 2
        switcher?.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        switcher?.titleLabel!.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        switcher?.titleLabel!.layer.shadowOffset = CGSize(width: 0, height: lineWidth())
        switcher?.titleLabel!.layer.shadowRadius = 0
        switcher?.titleLabel!.layer.shadowOpacity = 1.0
        switcher?.titleLabel!.layer.rasterizationScale = UIScreen.mainScreen().scale
        switcher?.titleLabel!.layer.shouldRasterize = true
        addSubview(switcher!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SFColorPlate: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(frame: CGRect.zero)
        stackView.distribution = .FillEqually
        stackView.spacing = 5
       
        addSubview(stackView)
        stackView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp_bottom).inset(3)
            make.left.equalTo(15)
            make.right.equalTo(self.snp_right).inset(15)
            make.top.equalTo(0)
        }
        for i in 0..<SFColors.allColors.count{
            let button = UIButton(type: UIButtonType.Custom)
            button.backgroundColor = SFColors.allColors[i]
            button.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            button.addTarget(self, action: "changeColor:", forControlEvents: UIControlEvents.TouchDown)
            button.tag = i
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.whiteColor().CGColor
            stackView.addArrangedSubview(button)
            
        }
        
    }
    
    func changeColor(sender : UIButton){
        NSUserDefaults.standardUserDefaults().setColor(SFColors.allColors[sender.tag], forKey: "COLOR2")
        NSNotificationCenter.defaultCenter().postNotificationName("ColorChanges", object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}