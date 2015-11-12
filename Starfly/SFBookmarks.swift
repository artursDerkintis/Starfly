//
//  SFBookmarks.swift
//  Starfly
//
//  Created by Arturs Derkintis on 10/1/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
 import CoreData
class SFBookmarks: UIView, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, SWTableViewCellDelegate{
        var tableView : UITableView?
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        private var fetchController : NSFetchedResultsController?
        var imageDictionary = NSMutableDictionary()
        var deleteAllButton : UIButton?
        
        var blur : UIVisualEffectView?
        // var delgate : SFOpenMeDelegate?
        var oldestItemAge : NSDate?
        var wholeArray : NSArray?
        var shadowView : UIView?
    
    
        var introView : SFView?
        let starImage = UIImageView(image: UIImage(named: "starbig"))
        override init(frame: CGRect) {
            super.init(frame: frame)
            clipsToBounds = true
            layer.cornerRadius = 20
            fetchController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: app.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchController?.delegate = self
            blur = UIVisualEffectView(frame: CGRectMake(50, 50, bounds.width - 100, bounds.height - 150))
            blur?.layer.cornerRadius = 20
            blur?.layer.masksToBounds = true
            blur?.effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            blur!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            
            shadowView = UIView(frame: CGRect.zero)
            
            
            shadowView?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
            shadowView?.layer.shadowOffset = CGSize(width: 0, height: 0)
            shadowView?.layer.shadowRadius = 2
            shadowView?.layer.shadowPath = UIBezierPath(roundedRect: shadowView!.bounds, cornerRadius: 20).CGPath
            shadowView?.layer.shadowOpacity = 1.0
            shadowView?.layer.shouldRasterize = true
            shadowView?.layer.rasterizationScale = UIScreen.mainScreen().scale
            addSubview(shadowView!)
            addSubview(blur!)
            tableView = UITableView(frame: CGRect.zero)
            tableView?.layer.cornerRadius = 20
            tableView?.layer.masksToBounds = true
            tableView?.registerClass(SFBookmarksCell.self, forCellReuseIdentifier: "BB")
            tableView!.delegate   = self
            tableView!.dataSource = self
            tableView?.backgroundColor = .clearColor()
            tableView?.separatorColor = .clearColor()
        
            addSubview(tableView!)
            
            introView = SFView(frame: CGRect.zero)
            introView?.layer.zPosition = 500
            
            introView?.addSubview(starImage)
            tableView?.addSubview(introView!)
            introView?.snp_makeConstraints { (make) -> Void in
                make.top.right.bottom.left.equalTo(0)
                make.height.width.equalTo(tableView!)
            }
            starImage.snp_makeConstraints { (make) -> Void in
                make.center.equalTo(introView!)
                make.height.width.equalTo(100)
            }
            tableView?.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            }
            shadowView?.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            }
            blur!.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            }
    }
        func updateFrames(edge : UIEdgeInsets){
            tableView?.snp_updateConstraints { (make) -> Void in
                make.edges.equalTo(edge)
            }
            shadowView?.snp_updateConstraints { (make) -> Void in
                make.edges.equalTo(edge)
            }
            blur!.snp_updateConstraints { (make) -> Void in
                make.edges.equalTo(edge)
            }
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            shadowView!.layer.shadowPath = UIBezierPath(roundedRect: shadowView!.bounds, cornerRadius: 20).CGPath
            
            
        }
        func load(){
            
            do {
                
                try fetchController!.performFetch()
                tableView?.reloadData()
                delay(0.1, closure: { () -> () in
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.introView?.alpha = 0.0
                        self.starImage.transform = CGAffineTransformMakeScale(0.01, 0.01)
                        }, completion: { (m) -> Void in
                            self.introView?.hidden = true
                            self.introView?.alpha = 1.0
                            self.starImage.transform = CGAffineTransformIdentity
                    })
                })
            } catch _ {
            }
        }
  
        func deleteImageIN(stringPath : NSString?){
        if stringPath != nil{
            let stsAr : NSString? = stringPath!.lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
            let path = folder.stringByAppendingPathComponent(stsAr! as String)
            var error : NSError?
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
                
            } catch var error1 as NSError {
                error = error1
            }
            if error != nil{
                print(error?.localizedDescription)
            }}
        }

    
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            let object = fetchController?.objectAtIndexPath(indexPath) as! Bookmarks
            NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: nil, userInfo: ["url" : object.url])
        }
    
        func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
            let indexPath = self.tableView?.indexPathForCell(cell)
            let object = fetchController!.objectAtIndexPath(indexPath!) as! Bookmarks
            
            deleteImageIN(object.favicon)
            app.managedObjectContext.deleteObject(object)
            app.saveContext()
        }
    
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let sectionInfo = self.fetchController!.sections![section] as NSFetchedResultsSectionInfo
            if sectionInfo.numberOfObjects > 0{
                deleteAllButton?.hidden = false
            }
            return sectionInfo.numberOfObjects
        }
    
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return self.fetchController!.sections?.count ?? 0
        }
    
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("BB", forIndexPath: indexPath) as! SFBookmarksCell
            let object = fetchController?.objectAtIndexPath(indexPath) as! Bookmarks
            cell.titleLabel?.text = object.title
            cell.urlLabel?.text = object.url
            cell.icon?.image = imageDictionary.objectForKey(object.favicon) as? UIImage
            cell.leftUtilityButtons = deleteButton() as [AnyObject]
            
            cell.delegate = self
            return cell
        }
    
        func deleteButton() -> NSArray{
            let mutableArray = NSMutableArray()
            mutableArray.sw_addUtilityButtonWithColor(.redColor(), title: "Delete")
            return mutableArray.mutableCopy() as! NSArray
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 50
        }
        func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0
        }
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func taskFetchRequest() -> NSFetchRequest {
            
            let request : NSFetchRequest = NSFetchRequest(entityName: "Bookmarks")
            request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
           
            var array : NSArray? = try! app.managedObjectContext.executeFetchRequest(request)
            for object in array as! [Bookmarks]{
                let imagePlace = object.favicon
                let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
                let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
                let path = folder.stringByAppendingPathComponent(stsAr! as String)
                if let image = UIImage(contentsOfFile: path){
                    imageDictionary.setObject(image, forKey: imagePlace)
                }
            }
            wholeArray = array
            array = nil
            return request
            
        }
    
        func controllerWillChangeContent(controller: NSFetchedResultsController)  {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.tableView != nil{
                    self.tableView?.beginUpdates()
                }
            })
            
            
        }
        
        func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)  {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch type {
                case .Insert:
                    self.tableView!.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                    break
                case .Delete:
                    self.tableView!.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                    break
                default:
                    return
                }
            })
        }
        
        func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch type {
                case .Insert:
                    
                    
                    let h = anObject as! Bookmarks
                    let imagePlace = h.favicon
                    let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
                    let folder : NSString = (NSHomeDirectory()as NSString).stringByAppendingPathComponent("Documents/Books")
                    let path = folder.stringByAppendingPathComponent(stsAr! as String)
                    let image = UIImage(contentsOfFile: path)
                    self.imageDictionary.setObject(image!, forKey: imagePlace)
                    self.tableView!.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Top)
                    
                    
                    
                    break
                case .Delete:
                    self.tableView!.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                    break
                case .Update:
                    print(indexPath!.section)
                    self.configureCell(indexPath!)
                    break
                case .Move:
                    
                    self.tableView!.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                    break
                    
                }
            })
            
            
        }
        override func removeFromSuperview() {
            super.removeFromSuperview()
            self.fetchController = nil
        }
        deinit{
            
        }
        func controllerDidChangeContent(controller: NSFetchedResultsController) {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.tableView != nil{
                    self.tableView?.endUpdates()
                }
            })
            
        }
        func configureCell(indexPath : NSIndexPath){
            
            let object = fetchController!.objectAtIndexPath(indexPath) as! Bookmarks
            let imagePlace = object.favicon
            let cely = self.tableView?.cellForRowAtIndexPath(indexPath) as? SFBookmarksCell
            print(cely)
            if cely != nil{
                cely!.icon!.image = imageDictionary.objectForKey(imagePlace) as? UIImage
                cely!.urlLabel?.text = object.url
                cely!.titleLabel?.text = object.title
                
            }else{
                self.tableView!.reloadData()
            }
        }
        
        
    }
