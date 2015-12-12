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

    var tiits : UITextField?
    var urlz : UILabel?
    var ic : UIImageView?
    var icH : UIView?
    var conV : SFView?
    var cancel, save : SFButton?
    var infoDictD : NSDictionary?
    var app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var s, h : UIButton?
    var saveIn = SaveIn.bookmarks
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = UIColor(white: 0.1, alpha: 0.0)
        conV = SFView(frame: CGRectMake(0, 0, 300, 300))
        conV?.layer.borderColor = UIColor.whiteColor().CGColor
        conV?.layer.borderWidth = 2
        conV?.layer.cornerRadius = 150
        conV?.layer.shadowRadius = 50
        conV?.layer.shadowColor =  UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        conV?.layer.shadowOpacity = 1.0
        conV?.layer.shadowOffset = CGSizeMake(0,0)
        conV?.layer.shouldRasterize = true
        conV?.layer.rasterizationScale = UIScreen.mainScreen().scale
        icH = UIView(frame: CGRectMake(110, 25, 80, 80))
        ic = UIImageView(frame: CGRectMake(15, 15, 50, 50))
        
        icH?.addSubview(ic!)
        let share = UIButton(type: UIButtonType.Custom)
        share.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        share.titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
        share.addTarget(self, action: "sharingIsCaring:", forControlEvents: UIControlEvents.TouchDown)
        share.setTitle("More", forState: UIControlState.Normal)
        share.frame = CGRect(x: 180, y: 60, width: 80, height: 20)
        conV?.addSubview(share)
        tiits = UITextField(frame: CGRectMake(20, 140, 260, 33))
        
        tiits?.clearButtonMode = UITextFieldViewMode.WhileEditing
        tiits?.textColor = UIColor.whiteColor()
        tiits?.tintColor = UIColor.whiteColor()
        tiits?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightRegular)
        tiits?.layer.borderWidth = 0
        tiits?.leftView = UIView(frame: CGRectMake(0, 0, 5, 50))
        tiits?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
     
        tiits?.keyboardType = UIKeyboardType.WebSearch
        tiits?.autocorrectionType = UITextAutocorrectionType.No
        tiits?.autocapitalizationType = UITextAutocapitalizationType.None
        let ss = "Type your url"
        let placeholder = NSAttributedString(string: ss, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.5)])
        tiits?.attributedPlaceholder = placeholder
        conV!.addSubview(tiits!)
        urlz = UILabel(frame: CGRectMake(25, 180, 255, 33))
        urlz?.textColor = UIColor(white: 0.9, alpha: 1)
        urlz?.font = UIFont.systemFontOfSize(13)
        conV?.addSubview(urlz!)
        conV?.addSubview(icH!)
        addSubview(conV!)
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
        conV?.addSubview(save!)
    
        conV?.addSubview(cancel!)
        conV?.layer.masksToBounds = false
        conV?.clipsToBounds = false
        
        conV?.center = CGPointMake(frame.width * 0.5, frame.height *  0.4)
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
        conV?.addSubview(stackView)
        
    }
    func sharingIsCaring(sender : UIButton){
        let objectsToShare = [NSURL(string: infoDictD!.objectForKey("url")! as! String)!]
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
            if !CGRectContainsPoint(conV!.frame, loc){
                cancelEv()
            }
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func cancelEv(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.conV!.transform = CGAffineTransformMakeScale(0.01, 0.01)
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
            saveINBookmark()
            saveINHomeHit()
            break
        case .homescreen:
            saveINHomeHit()
            break
        case .bookmarks:
            saveINBookmark()
            break
        }
    }
    func saveINHomeHit(){
        
        if infoDictD != nil {
            infoDictD?.setValue(tiits!.text, forKey: "title")
            saveInFavorites(infoDictD!)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 0.01
                self.conV!.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }, completion: { (done) -> Void in
               
                    self.removeFromSuperview()
                
            })
                   }
        
    }
    func saveINBookmark(){
        
        if infoDictD != nil {
            infoDictD?.setValue(tiits!.text, forKey: "title")
            saveInBookmarks(infoDictD!)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 0.01
                self.conV!.transform = CGAffineTransformMakeScale(0.01, 0.01)
                }, completion: { (done) -> Void in
                    
                   
                    self.removeFromSuperview()
                    
            })
        }
        
    }

    func setUpME(dict : NSDictionary){
        conV?.transform = CGAffineTransformMakeScale(0.001, 0.001)
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.conV!.transform = CGAffineTransformIdentity
            }) { (new) -> Void in
                
        }

        infoDictD = dict
        print(dict)
        let image = dict.objectForKey("image") as! UIImage
        //let main = ew.getEw().mainColoursInImage(image, detail: 0) as NSMutableArray
        //let color = main.objectAtIndex(0) as! UIColor
        let title = dict.objectForKey("title") as! String
        let url = dict.objectForKey("url") as! String
        tiits?.text = title
        urlz?.text = url
       // icH?.backgroundColor = color
        ic?.image = image
        save?.addTarget(self, action: "saveSomeWhere", forControlEvents: UIControlEvents.TouchDown)
        
        
        
    }
      /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */


}
