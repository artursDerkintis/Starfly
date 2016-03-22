//
//  SaveINSideBarTopHitf.swift
//  StarflyV2
//
//  Created by Neal Caffrey on 4/9/15.
//  Copyright (c) 2015 Neal Caffrey. All rights reserved.
//

import UIKit

enum SaveIn{
    case bookmarks
    case homescreen
    case both
    case none
}

class SFShare:  UIView {

    var textField : UITextField?
    var urlLabel : UILabel?
    var iconImageView : UIImageView?
    var iconViewContainer : UIView?
    var containerView : SFView?
    var cancel, save : SFButton?
    var item : Item!
    var s, h : UIButton?
    var saveIn = SaveIn.bookmarks
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = UIColor(white: 0.1, alpha: 0.0)
        containerView = SFView(frame: CGRectMake(0, 0, 300, 300))
        containerView?.layer.borderColor = UIColor.whiteColor().CGColor
        containerView?.layer.borderWidth = 2
        containerView?.layer.cornerRadius = 150
        containerView?.layer.shadowRadius = 50
        containerView?.layer.shadowColor =  UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        containerView?.layer.shadowOpacity = 1.0
        containerView?.layer.shadowOffset = CGSizeMake(0,0)
        containerView?.layer.shouldRasterize = true
        containerView?.layer.rasterizationScale = UIScreen.mainScreen().scale
        iconViewContainer = UIView(frame: CGRectMake(110, 25, 80, 80))
        iconImageView = UIImageView(frame: CGRectMake(15, 15, 50, 50))
        
        iconViewContainer?.addSubview(iconImageView!)
        let share = UIButton(type: UIButtonType.Custom)
        share.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        share.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
        share.addTarget(self, action: "sharingIsCaring:", forControlEvents: UIControlEvents.TouchDown)
        share.setTitle("More", forState: UIControlState.Normal)
        share.frame = CGRect(x: 180, y: 60, width: 80, height: 20)
        containerView?.addSubview(share)
        textField = UITextField(frame: CGRectMake(20, 140, 260, 33))
        
        textField?.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField?.textColor = UIColor.whiteColor()
        textField?.tintColor = UIColor.whiteColor()
        textField?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightRegular)
        textField?.layer.borderWidth = 0
        textField?.leftView = UIView(frame: CGRectMake(0, 0, 5, 50))
        textField?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
     
        textField?.keyboardType = UIKeyboardType.WebSearch
        textField?.autocorrectionType = UITextAutocorrectionType.No
        textField?.autocapitalizationType = UITextAutocapitalizationType.None
        let ss = "Type your url"
        let placeholder = NSAttributedString(string: ss, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        textField?.attributedPlaceholder = placeholder
        containerView!.addSubview(textField!)
        urlLabel = UILabel(frame: CGRectMake(25, 180, 255, 33))
        urlLabel?.textColor = UIColor(white: 0.9, alpha: 1)
        urlLabel?.font = UIFont.systemFontOfSize(13)
        containerView?.addSubview(urlLabel!)
        containerView?.addSubview(iconViewContainer!)
        addSubview(containerView!)
        // Do any additional setup after loading the view.
        cancel = SFButton(frame: CGRectMake(70, 230, 80, 40))
        cancel?.setTitle("Cancel", forState: UIControlState.Normal)
        cancel?.addTarget(self, action: "cancelEv", forControlEvents: UIControlEvents.TouchUpInside)
        cancel?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancel!.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        save = SFButton(frame: CGRectMake(150, 230, 80, 40))
        save?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        save?.setTitle("Done", forState: UIControlState.Normal)
        
        save?.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        containerView?.addSubview(save!)
    
        containerView?.addSubview(cancel!)
        containerView?.layer.masksToBounds = false
        containerView?.clipsToBounds = false
        
        containerView?.center = CGPointMake(frame.width * 0.5, frame.height *  0.4)
        let label = UILabel(frame: CGRect(x: 60, y: 100, width: 100, height: 50))
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Home Screen"
        //conV?.addSubview(label)
        let home = SFSettingsSwitch(frame: CGRect(x:0, y: 0, width: 150, height : 40))
        s = home.switcher
        home.switcher?.tag = 0
        home.switcher?.setTitle("Home Screen", forState: UIControlState.Normal)
        home.switcher?.backgroundColor = UIColor.clearColor()
        
        home.switcher?.addTarget(self, action: "switcher:", forControlEvents: UIControlEvents.TouchDown)
        let books = SFSettingsSwitch(frame: CGRect(x:0, y: 0, width: 150, height : 40))
        h = books.switcher
        books.switcher?.tag = 1
        books.switcher?.setTitle("Bookmarks", forState: UIControlState.Normal)
        books.switcher?.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        books.switcher?.addTarget(self, action: "switcher:", forControlEvents: UIControlEvents.TouchDown)
        let stackView = UIStackView(frame: CGRect(x: 30, y: 100, width: 250, height: 25))
        stackView.addArrangedSubview(home)
        stackView.addArrangedSubview(books)
        stackView.distribution = .FillEqually
        stackView.spacing = 20
        containerView?.addSubview(stackView)
        
    }
    func sharingIsCaring(sender : UIButton){
        let objectsToShare = [NSURL(string: item.url)!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        let pop = activityVC.popoverPresentationController
        pop?.sourceRect = CGRect(x: 30, y: 15, width: 1, height: 1)
        pop?.sourceView = sender
        if let vc = self.superview!.nextResponder(){
                (vc as! UIViewController).presentViewController(activityVC, animated: true, completion: nil)
            
        }
    }
    func switcher(sender : SFSettingsSwitch){
        sender.backgroundColor = sender.tag == 0  ? UIColor(white: 0.5, alpha: 0.5) :UIColor.clearColor()
        sender.tag = sender.tag == 0 ? 1 : 0
        save?.enabled = true
        if s?.tag == 1 && h?.tag == 1 {
            saveIn = .both
        }else if s?.tag == 0 && h?.tag == 1{
            saveIn = .bookmarks
        }else if s?.tag == 1 && h?.tag == 0{
            saveIn = .homescreen
        }else if s?.tag == 0 && h?.tag == 0{
            saveIn = .none
        }
        if saveIn == .none{
            save?.enabled = false
    
        }
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let loc = touch.locationInView(self)
            if !CGRectContainsPoint(containerView!.frame, loc){
                cancelEv()
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelEv(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.containerView!.transform = CGAffineTransformMakeScale(0.01, 0.01)
            self.alpha = 0.01
            }, completion: { (done) -> Void in
               self.removeFromSuperview()
        })
    }
    
    func saveSomeWhere(){
        
        switch saveIn{
        case .none:
            //this most not be fired
            break
        case .both:
            saveInBookmark()
            saveInHomeHit()
            break
        case .homescreen:
            saveInHomeHit()
            break
        case .bookmarks:
            saveInBookmark()
            break
        }
    }
    func saveInHomeHit(){
        if let newTitle = textField?.text{
            item.title = newTitle
            SFDataHandler.sharedInstance.saveHomeItem(item)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 0.01
                self.containerView!.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }, completion: { (done) -> Void in
               
                    self.removeFromSuperview()
                
            })
        
        }
    }
    func saveInBookmark(){
        
        if let newTitle = textField?.text{
            item.title = newTitle
            SFDataHandler.sharedInstance.saveBookmarkItem(item)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 0.01
                self.containerView!.transform = CGAffineTransformMakeScale(0.01, 0.01)
                }, completion: { (done) -> Void in
                    self.removeFromSuperview()
            })
        }
        
    }

    func setup(item : Item){
        containerView?.transform = CGAffineTransformMakeScale(0.001, 0.001)
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.containerView!.transform = CGAffineTransformIdentity
            }) { (new) -> Void in
                
        }

        self.item = item
        textField?.text =  item.title
        urlLabel?.text = item.url
        iconImageView?.image = item.favicon
        save?.addTarget(self, action: "saveSomeWhere", forControlEvents: UIControlEvents.TouchDown)
        
    }


}
