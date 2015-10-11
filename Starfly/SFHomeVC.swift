//
//  SFHomeVC.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/18/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFHomeVC: UIViewController, UIScrollViewDelegate{
     var scrollView : UIScrollView?
    
    var controlView : UIView?
    var switcher : SFHomeSwitcher?
    
    
    var history : SFHistory?
    var homeContent : SFHomeCollectionVC?
    var bookmarks : SFBookmarks?
    
    var editButton : SFButton?
    var imageChange : SFButton?
    var backGround : UIImageView?
    var radial : ALRadialMenu?
    override func viewDidLoad() {
        super.viewDidLoad()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "bookcels")
        view.backgroundColor = .clearColor()
        backGround = UIImageView(frame: view.bounds)
        backGround!.contentMode = UIViewContentMode.ScaleAspectFill
        backGround!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        let b = NSUserDefaults.standardUserDefaults().objectForKey("BACKGr")
        backGround!.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(b == nil ? "abs2" : b as! String, ofType: ".jpg")!)
        
        view.addSubview(backGround!)
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        scrollView?.pagingEnabled = true
        scrollView?.delegate = self
        scrollView?.bounces = false
        view.addSubview(scrollView!)
        homeContent = SFHomeCollectionVC()
        homeContent!.view.frame = CGRect(x: view.bounds.width, y: 90, width: view.bounds.width, height: view.bounds.height - 90)
        homeContent!.view.autoresizingMask = [ UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        scrollView!.addSubview(homeContent!.view)
        bookmarks = SFBookmarks(frame: CGRect(x: 0, y: 90, width: view.bounds.width, height: view.bounds.height - 90))
        bookmarks!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        bookmarks?.updateFrames(EdgeInsetsMake(50, left: 50, bottom: -130, right: -50))
        scrollView?.addSubview(bookmarks!)
        history = SFHistory(frame: CGRect(x: view.bounds.width * 2, y: 90, width: view.bounds.width, height: view.bounds.height - 90))
        history!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        history!.updateFrames(EdgeInsetsMake(50, left: 50, bottom: -130, right: -50))
        scrollView?.addSubview(history!)
        scrollView?.showsHorizontalScrollIndicator = false
        
        controlView = UIView(frame:  CGRect(x: view.frame.width * 0.5 - 150, y: view.frame.height - 80, width: 300, height: 40))
        switcher = SFHomeSwitcher(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        switcher!.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleTopMargin]
        switcher!.addTarget(self, action: "scroll:", forControlEvents: UIControlEvents.ValueChanged)
        switcher!.addTarget(self, action: "scrollEnded:", forControlEvents: UIControlEvents.TouchUpInside)
        
        editButton = SFButton(type: UIButtonType.Custom)
        editButton!.frame = CGRect(x: 5, y: self.view.frame.height - 35, width: 30, height: 30)
        editButton!.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
        editButton!.setImage(UIImage(named: Images.edit), forState: UIControlState.Normal)
        editButton!.setImage(UIImage(named: Images.edit)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        editButton!.contentEdgeInsets = UIEdgeInsets(top: 12.5, left: 6, bottom: 12.5, right: 6)
        editButton!.layer.cornerRadius = editButton!.frame.size.height * 0.5
        editButton!.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        editButton!.layer.shadowOffset = CGSize(width: 0, height: 0)
        editButton!.layer.shadowRadius = 2
        editButton!.layer.shadowOpacity = 1.0
        editButton!.layer.rasterizationScale = UIScreen.mainScreen().scale
        editButton!.layer.shouldRasterize = true
        editButton!.tag = 0
        editButton!.addTarget(self, action: "editContent:", forControlEvents: UIControlEvents.TouchDown)
        view.addSubview(editButton!)
        controlView!.addSubview(switcher!)
        view.addSubview(controlView!)
        
        let long = UILongPressGestureRecognizer(target: self, action: "long:")
        view.addGestureRecognizer(long)
        imageChange = SFButton(type: UIButtonType.Custom)
        imageChange!.frame = CGRect(x: view.frame.width - 35, y: self.view.frame.height - 35, width: 30, height: 30)
        imageChange!.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleLeftMargin]
        imageChange!.setImage(UIImage(named: Images.image), forState: UIControlState.Normal)
        imageChange!.setImage(UIImage(named: Images.image)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        imageChange!.setImage(UIImage(named: Images.closeTab), forState: UIControlState.Selected)
        imageChange!.contentEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
        imageChange!.layer.cornerRadius = imageChange!.frame.size.height * 0.5
        imageChange!.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        imageChange!.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageChange!.layer.shadowRadius = 2
        imageChange!.layer.shadowOpacity = 1.0
        imageChange!.layer.rasterizationScale = UIScreen.mainScreen().scale
        imageChange!.layer.shouldRasterize = true
        imageChange!.tag = 0
        imageChange!.addTarget(self, action: "openMenu:", forControlEvents: UIControlEvents.TouchDown)
        view.addSubview(imageChange!)
    }
    func openMenu(sender : SFButton){
        if sender.tag == 0{
            sender.tag = 1
            sender.selected = true
            var buttons = [ALRadialMenuButton]()
            for imageName in backgroundImagesThumbnails(){
                let button = ALRadialMenuButton(type: UIButtonType.Custom)
                button.setImage(UIImage(named: imageName + ".jpg"), forState: UIControlState.Normal)
                button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
                button.tag = backgroundImagesThumbnails().indexOf(imageName)!
                button.frame = CGRect(x: 0, y: 0, width: 58, height: 58)
                button.imageView?.layer.cornerRadius = button.frame.size.height * 0.5
                button.layer.cornerRadius = button.frame.height * 0.5
                button.imageView?.layer.masksToBounds = true
                button.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
                button.layer.shadowOffset = CGSize(width: 0, height: 0)
                button.layer.shadowRadius = 2
                button.layer.shadowOpacity = 1.0
                button.layer.rasterizationScale = UIScreen.mainScreen().scale
                button.layer.shouldRasterize = true
                buttons.append(button)
                button.addTarget(self, action: "changeImage:", forControlEvents: UIControlEvents.TouchDown)
            }
            let animationOptions: UIViewAnimationOptions = [UIViewAnimationOptions.CurveEaseInOut, UIViewAnimationOptions.BeginFromCurrentState]
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: animationOptions, animations: {
                self.scrollView?.alpha = 0.001
                self.editButton?.alpha = 0.001
                self.switcher?.alpha = 0.001
                sender.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                sender.center = CGPoint(x: CGRectGetMidX(self.view.frame), y: CGRectGetMidY(self.view.frame))
            
            
            }) { (finish) -> Void in
                self.radial = ALRadialMenu()
                    .setButtons(buttons)
                    .setDelay(0.01)
                    .setAnimationOrigin(sender.center)
                    .presentInView(self.view)
                
                self.view.bringSubviewToFront(self.imageChange!)
            }
        }else{
            sender.tag = 0
            self.radial?.dismiss()
            self.imageChange?.selected = false
            UIView.animateWithDuration(0.5) { () -> Void in
                self.scrollView?.alpha = 1
                self.editButton?.alpha = 1
                self.switcher?.alpha = 1
                self.imageChange!.frame = CGRect(x: self.view.frame.width - 35, y: self.view.frame.height - 35, width: 30, height: 30)
                self.imageChange!.contentEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
                self.imageChange!.layer.cornerRadius = self.imageChange!.frame.size.height * 0.5
            }
        }
    
    }
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.radial?.dismiss()
        self.imageChange?.selected = false

        UIView.animateWithDuration(0.1) { () -> Void in
            self.scrollView?.alpha = 1
            self.editButton?.alpha = 1
            self.switcher?.alpha = 1
            self.imageChange!.frame = CGRect(x: self.view.frame.width - 35, y: self.view.frame.height - 35, width: 30, height: 30)
            self.imageChange!.contentEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
            self.imageChange!.layer.cornerRadius = self.imageChange!.frame.size.height * 0.5
        }

    }
    func changeImage(sender : ALRadialMenuButton){
        let tag = sender.tag
        self.radial?.dismiss()
        self.imageChange?.selected = false
        backGround!.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(backgroundImages()[tag], ofType: ".jpg")!)
        NSUserDefaults.standardUserDefaults().setObject(backgroundImages()[tag], forKey: "BACKGr")
        UIView.animateWithDuration(0.5) { () -> Void in
            self.scrollView?.alpha = 1
            self.editButton?.alpha = 1
            self.switcher?.alpha = 1
            self.imageChange!.frame = CGRect(x: self.view.frame.width - 35, y: self.view.frame.height - 35, width: 30, height: 30)
            self.imageChange!.contentEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
            self.imageChange!.layer.cornerRadius = self.imageChange!.frame.size.height * 0.5
        }
        

    }
    func editContent(sender : SFButton){
        

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            sender.transform = sender.tag == 1 ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(CGFloat(degreesToRadians(90)))
        })

        switch currentPage {
        case 0:
           // bookmarks?.editCells(on: sender.tag == 1 ? false : true)
            break
        case 1:
            homeContent?.editCells(on: sender.tag == 1 ? false : true)
            
            break
        case 2:
            history?.showActions(sender.tag == 1 ? false : true)
            break
        default:
            break
        }
        sender.tag = sender.tag == 0 ? 1 : 0
    }
    
    func long(sender: UILongPressGestureRecognizer){
        if sender.state == .Began{
            scrollView?.scrollEnabled = false
        }else if sender.state == .Ended{
            scrollView?.scrollEnabled = true
        }
    }
    var currentPage : Int = 1{
        didSet{
            self.editButton?.tag = 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.editButton!.transform = CGAffineTransformIdentity
            })
            //bookmarks?.editCells(on: false)
            homeContent?.editCells(on: false)
            history?.showActions(false)
            if currentPage != oldValue{
            switch currentPage{
            case 0:
                editButton?.hidden = true
                bookmarks?.load()
                break
            case 1:
                editButton?.hidden = false
                break
            case 2:
                editButton?.hidden = false
                
                history?.load()
                break
            default:
                break
                }}
        }
    }
    func scroll(sender : SFHomeSwitcher){
        let width = sender.frame.width
        let rate = scrollView!.contentSize.width / width
        scrollView?.contentOffset = CGPoint(x: sender.floater!.frame.origin.x * rate, y: 0)
       
    }
    func scrollEnded(sender : SFHomeSwitcher){
            scrollView?.setContentOffset(CGPoint(x: scrollView!.frame.width * CGFloat(sender.currentPage), y: 0), animated: true)
            currentPage = sender.currentPage
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = switcher!.frame.width
        let rate =  width / scrollView.contentSize.width
        switcher?.liveScroll(CGPoint(x: scrollView.contentOffset.x * rate, y: 0))
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        print(currentPage)
        switcher?.setPage(currentPage)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controlView?.frame = CGRect(x: view.frame.width * 0.5 - 150, y: view.frame.height - 80, width: 300, height: 40)
        history?.frame = CGRect(x: view.bounds.width * 2, y: 90, width: view.bounds.width, height: view.bounds.height - 90)
        homeContent!.view.frame = CGRect(x: view.bounds.width, y: 90, width: view.bounds.width, height: view.bounds.height - 90)
        bookmarks?.frame = CGRect(x: 0, y: 90, width: view.bounds.width, height: view.bounds.height - 90)
        scrollView?.contentSize = CGSize(width: view.frame.width * 3, height: 200)
        scrollView?.setContentOffset(CGPoint(x: scrollView!.frame.width * CGFloat(currentPage), y: 0), animated: false)
    }
    
}
