//
//  SFHistory.swift
//  StarflyV2
//
//  Created by Neal Caffrey on 4/13/15.
//  Copyright (c) 2015 Neal Caffrey. All rights reserved.
//

import UIKit
import CoreData
struct Deleter {
    static let lastHour         = 0
    static let today            = 1
    static let lastWeek         = 2
    static let allButLastDay    = 3
    static let allButLastWeek   = 4
    static let all              = 5
    static let deepDelete       = 6
    static let cancel           = 7
    
}
class SFHistory: UIView, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, SWTableViewCellDelegate{
    var tableView : UITableView?
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    private var fetchController : NSFetchedResultsController?
    var imageDictionary = NSMutableDictionary()
    var deleteAllButton : UIButton?

    var blur : UIVisualEffectView?
   // var delgate : SFOpenMeDelegate?
    var oldestItemAge : NSDate?
    var wholeArray : NSArray?
    let laye = CALayer()
    
    var overLayerView : SFView?
    let starBig = UIImageView(image: UIImage(named: "history"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        fetchController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: app.managedObjectContext, sectionNameKeyPath: "sectionId", cacheName: nil)
        fetchController?.delegate = self
        blur = UIVisualEffectView(frame: CGRectMake(50, 50, bounds.width - 100, bounds.height - 150))
        blur?.layer.cornerRadius = 20
        blur?.layer.masksToBounds = true
        blur?.effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        blur!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
       
        laye.frame = CGRectMake(50, 50, bounds.width - 100, bounds.height - 150)
        layer.cornerRadius = 20
        laye.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        laye.shadowOffset = CGSize(width: 0, height: 0)
        laye.shadowRadius = 2
        laye.shadowPath = UIBezierPath(roundedRect: laye.bounds, cornerRadius: 20).CGPath
        laye.shadowOpacity = 1.0
        laye.shouldRasterize = true
        laye.rasterizationScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(laye)
        addSubview(blur!)
        tableView = UITableView(frame: CGRectMake(50, 50, bounds.width - 100, bounds.height - 150))
        tableView?.layer.cornerRadius = 20
        tableView?.layer.masksToBounds = true
        tableView?.registerClass(SFHistoryCell.self, forCellReuseIdentifier: "HISTI")
        tableView?.registerClass(SFHistoryHeader.self, forHeaderFooterViewReuseIdentifier: "HISTII")
        tableView!.delegate   = self
        tableView!.dataSource = self
        tableView?.backgroundColor = .clearColor()
        tableView?.separatorColor = .clearColor()
        tableView?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, .FlexibleHeight]
        tableView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        addSubview(tableView!)
        
        overLayerView = SFView(frame: CGRect.zero)
        overLayerView?.layer.zPosition = 500
        overLayerView?.addSubview(starBig)
        tableView?.addSubview(overLayerView!)
        overLayerView?.snp_makeConstraints { (make) -> Void in
            make.top.right.bottom.left.equalTo(0)
            make.height.width.equalTo(tableView!)
        }
        starBig.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(overLayerView!)
            make.height.width.equalTo(100)
        }


    }
    override func layoutSubviews() {
        super.layoutSubviews()
        laye.frame = CGRectMake(50, 50, bounds.width - 100, bounds.height - 150)
        laye.shadowPath = UIBezierPath(roundedRect: laye.bounds, cornerRadius: 20).CGPath
        blur?.frame = CGRectMake(50, 50, bounds.width - 100, bounds.height - 150)
    }
    func load(){
        
        do {
            
            try fetchController!.performFetch()
            tableView?.reloadData()
            delay(0.1, closure: { () -> () in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.overLayerView?.alpha = 0.0
                    self.starBig.transform = CGAffineTransformMakeScale(0.01, 0.01)
                    }, completion: { (m) -> Void in
                        self.overLayerView?.hidden = true
                        self.overLayerView?.alpha = 1.0
                        self.starBig.transform = CGAffineTransformIdentity
                })
            })
        } catch _ {
        }
    }

    func showActions(on : Bool){
        if on {
        let baner = SFView(frame: CGRectMake(frame.width * 0.5 - 100, bounds.height - 500, 200, 200))
        baner.tag = 10
        baner.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        baner.layer.shadowOffset = CGSize(width: 0, height: 0)
        baner.layer.shadowRadius = 2
        baner.layer.shadowOpacity = 1.0
        baner.layer.shouldRasterize = true
        baner.layer.rasterizationScale = UIScreen.mainScreen().scale
        baner.layer.masksToBounds = false
        baner.layer.cornerRadius = 21
        let deleteLastHour = SFButton(frame: CGRectMake(0, 0, 200, 50))
        deleteLastHour.setTitle("Delete last hour", forState: UIControlState.Normal)
        deleteLastHour.tag = Deleter.lastHour
        let deleteToday = SFButton(frame: CGRectMake(0, 50, 200, 50))
        deleteToday.setTitle("Delete Today", forState: UIControlState.Normal)
        deleteToday.tag = Deleter.today
        let deleteLastWeek = SFButton(frame: CGRectMake(0, 100, 200, 50))
        deleteLastWeek.setTitle("Delete this week", forState: UIControlState.Normal)
        deleteLastWeek.tag = Deleter.lastWeek
        let deleteAllButToday = SFButton(frame: CGRectMake(0, 150, 200, 50))
        deleteAllButToday.setTitle("Delete all except Today", forState: UIControlState.Normal)
        deleteAllButToday.tag = Deleter.allButLastDay
        let deleteAllButWeek = SFButton(frame: CGRectMake(0, 200, 200, 50))
        deleteAllButWeek.setTitle("Delete all except this week", forState: UIControlState.Normal)
        deleteAllButWeek.tag = Deleter.allButLastWeek
        let deleteEverthing = SFButton(frame: CGRectMake(0, 250, 200, 50))
        deleteEverthing.setTitle("Delete Everything", forState: UIControlState.Normal)
        deleteEverthing.tag = Deleter.all
        let deleteDeep = SFButton(frame: CGRectMake(0, 300, 200, 50))
        deleteDeep.setTitle("Clear cookies and cache", forState: UIControlState.Normal)
        deleteDeep.tag = Deleter.deepDelete
       // let cancel = SFButton(frame: CGRectMake(0, 350, 200, 50))
       // cancel.setTitle("Cancel", forState: UIControlState.Normal)
       // cancel.tag = Deleter.cancel
        let calendar = NSCalendar.currentCalendar()
        let date : NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -2, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
        var buttonAr : [SFButton]?
        if moreLess(date, rhs: oldestItemAge!){
             buttonAr = [deleteLastHour, deleteToday, deleteLastWeek, deleteAllButToday, deleteAllButWeek, deleteEverthing, deleteDeep/*, cancel*/]
        }else{
             buttonAr = [deleteLastHour, deleteToday, deleteEverthing, deleteDeep/*, cancel*/]
        }
            let overlay = UIView(frame: CGRect.zero)
            
            
            overlay.layer.cornerRadius = 20
            overlay.layer.masksToBounds = true
            baner.addSubview(overlay)
        var height : CGFloat = 400
        for var i = 0; i < buttonAr!.count; ++i{
            let b : SFButton = buttonAr![i] as SFButton
            b.frame = CGRectMake(0, CGFloat(i * 50), 200, 50)
            height = CGFloat(i * 50 + 50)
            b.addTarget(self, action: "callback:", forControlEvents: UIControlEvents.TouchUpInside)
            b.titleLabel?.font = UIFont.systemFontOfSize(14)
            b.layer.borderWidth = 0.5
            b.layer.borderColor = UIColor.lightGrayColor().CGColor
            if b.tag == Deleter.cancel {
            b.titleLabel?.font = UIFont.systemFontOfSize(15)
            }
            overlay.frame = CGRect(x: 0, y: 0, width: 200, height: height)
            overlay.addSubview(b)
        }
        addSubview(baner)
            baner.frame.size = CGSize(width: 200, height: height)
        baner.alpha = 0.01
            delay(0.1, closure: { () -> () in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    baner.frame = CGRect(x: self.frame.width * 0.5 - 100, y: self.frame.height * 0.5 - (height * 0.5), width: 200, height: height)
                    baner.alpha = 1.0
                })
            })
      
       
           
        }else{
            let viewToRemove = self.viewWithTag(10)
            if viewToRemove != nil{
            animate({ () -> Void in
                viewToRemove!.frame = CGRect(x: self.frame.width * 0.5 - 100, y: self.frame.height - 500, width: 200, height: viewToRemove!.frame.height)
                viewToRemove!.alpha = 0.1
                }, after: { () -> Void in
                    viewToRemove!.removeFromSuperview()
            })}
            
        }
        
        
    }
    
    func moreLess (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
    }
    
    
    func callback(sender: UIButton){
        switch sender.tag{
        case Deleter.lastHour:
            let calendar = NSCalendar.currentCalendar()
            let date = calendar.dateByAddingUnit(NSCalendarUnit.Hour, value: -1, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
          
            for var i = 0; i < wholeArray!.count; ++i{
                let h = wholeArray!.objectAtIndex(i) as! HistoryHit
                if h.date.compare(date) == NSComparisonResult.OrderedSame ||  h.date.compare(date) == NSComparisonResult.OrderedDescending{
                print("5678\n LAST HOUR \(h.date)")
                    deleteImageIN(h.faviconPath)
                    app.managedObjectContext.deleteObject(h)
                }else{
                    break
                }
                print(i)
            }
            hideBaner(sender)
            app.saveContext()
            getArray()
            break
        case Deleter.today:
            
            for var i = 0; i < wholeArray!.count; ++i{
                let h = wholeArray!.objectAtIndex(i) as! HistoryHit
                let datF = (UIApplication.sharedApplication().delegate as! AppDelegate).dateFormater2
                datF.dateFormat  = "dd-MM-yyyy"
                let dateToday = NSDate()
                let dayToday = datF.stringFromDate(dateToday)
                let dayStrings = datF.stringFromDate(h.date)
                let date = datF.dateFromString(dayStrings)
               if dayStrings == dayToday{
                    
                print("1\n to DAY \(h.date)")
                    deleteImageIN(h.faviconPath)
                    app.managedObjectContext.deleteObject(h)
                }else{
                break
                }
                print(i)
            }
            hideBaner(sender)
            app.saveContext()
            getArray()
            break
        case Deleter.lastWeek:
            let calendar = NSCalendar.currentCalendar()
            let date = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -7, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
            
            for var i = 0; i < wholeArray!.count; ++i{
                let h = wholeArray!.objectAtIndex(i) as! HistoryHit
                if h.date.compare(date) == NSComparisonResult.OrderedSame ||  h.date.compare(date) == NSComparisonResult.OrderedDescending{
                    print("176678\n this week \(h.date)")
                    deleteImageIN(h.faviconPath)
                    app.managedObjectContext.deleteObject(h)
                }else{
                    break
                }
                print(i)
            }
            hideBaner(sender)
            app.saveContext()
            getArray()
            break
        case Deleter.allButLastDay:
            
            for var i = 0; i < wholeArray!.count; ++i{
                let h = wholeArray!.objectAtIndex(i) as! HistoryHit
                let datF = (UIApplication.sharedApplication().delegate as! AppDelegate).dateFormater2
                datF.dateFormat  = "dd-MM-yyyy"
                let dateToday = NSDate()
                let dayToday = datF.stringFromDate(dateToday)
                let dayStrings = datF.stringFromDate(h.date)
                if dayStrings == dayToday{

                }else{
                     print("1e2qw\n not to DAY \(h.date)")
                    deleteImageIN(h.faviconPath)
                    app.managedObjectContext.deleteObject(h)
                    
                 
                }
                print(i)
            }
            hideBaner(sender)
            app.saveContext()
            getArray()
            break
        case Deleter.allButLastWeek:
            let calendar = NSCalendar.currentCalendar()
            let date = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -7, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
            
            for var i = 0; i < wholeArray!.count; ++i{
                let h = wholeArray!.objectAtIndex(i) as! HistoryHit
                
                if h.date.compare(date) == NSComparisonResult.OrderedSame ||  h.date.compare(date) == NSComparisonResult.OrderedDescending{
                   
                }else{
                    print("1766wefqwfqrgq78\n not this week \(h.date)")
                    deleteImageIN(h.faviconPath)
                    app.managedObjectContext.deleteObject(h)
                    
                }
                print(i)
            }
            hideBaner(sender)
            app.saveContext()
            getArray()
            break
        case Deleter.all:
            for var i = 0; i < wholeArray!.count; ++i{
                let h = wholeArray!.objectAtIndex(i) as! HistoryHit
                
                    deleteImageIN(h.faviconPath)
                    app.managedObjectContext.deleteObject(h)
                
            }
            hideBaner(sender)
            app.saveContext()
            getArray()

            break
        case Deleter.deepDelete:
            
            
            let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            if storage.cookies?.count != 0{
            for cookie : AnyObject? in storage.cookies! as [AnyObject]{
                if  cookie != nil{
                    print(cookie)
                    storage.deleteCookie(cookie as! NSHTTPCookie)
                }else{
                    break
                }
                }}
            NSUserDefaults.standardUserDefaults().synchronize()
            NSURLCache.sharedURLCache().removeAllCachedResponses()
            
            let path : String? = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Library/WebKit/WebsiteData/LocalStorage")
            if path != nil{
                var eror : NSError? = nil
                let s: [AnyObject]?
                do {
                    s = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path!)
                } catch let error as NSError {
                    eror = error
                    s = nil
                }
                if s != nil && s?.count != 0{
                for fileString : AnyObject in s! as [AnyObject] {
                    if fileString.pathExtension == "localstorage"{
                        let pathd = (path! as NSString).stringByAppendingPathComponent(fileString as! String)
                        var error : NSError?
                        var booler : Bool
                        do {
                            try NSFileManager.defaultManager().removeItemAtPath(pathd)
                            booler = true
                        } catch var error1 as NSError {
                            error = error1
                            booler = false
                        }
                        if error != nil{
                            print(error?.localizedDescription)
                        }

                    }}
                
                
                }}
            hideBaner(sender)
            break
        case Deleter.cancel:
            hideBaner(sender)
            break
        default:
            break
        }

    }
    func deleteImageIN(stringPath : NSString){
       
        let stsAr : NSString? = stringPath.lastPathComponent
        let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
        let path = folder.stringByAppendingPathComponent(stsAr! as String)
        var error : NSError?
        var booler : Bool
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
            booler = true
        } catch var error1 as NSError {
            error = error1
            booler = false
        }
        if error != nil{
            print(error?.localizedDescription)
        }
    }
    func hideBaner(sender: UIButton){
        let viewToRemove = self.viewWithTag(10)
        if viewToRemove != nil{
            animate({ () -> Void in
                viewToRemove!.frame = CGRectMake(self.frame.width * 0.5 - 100, self.bounds.height , min(200, self.laye.frame.width), viewToRemove!.frame.height)
                viewToRemove!.alpha = 0.1
                }, after: { () -> Void in
                    viewToRemove!.removeFromSuperview()
            })}

    }
    /*date =  calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -1, toDate: NSDate(), options: nil)!
    if h.date.compare(date) == NSComparisonResult.OrderedSame ||  h.date.compare(date) == NSComparisonResult.OrderedDescending{
    println("1\n to DAY \(h.date)")
    }
    date = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -7, toDate: NSDate(), options: nil)!
    if h.date.compare(date) == NSComparisonResult.OrderedSame ||  h.date.compare(date) == NSComparisonResult.OrderedDescending{
    println("4\n LAST WEEK \(h.date)")
    }
    if h.date.compare(date) == NSComparisonResult.OrderedSame ||  h.date.compare(date) == NSComparisonResult.OrderedAscending{
    println("67\n anything Else but not this WEEK \(h.date)")
    }*/

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let object = fetchController?.objectAtIndexPath(indexPath) as! HistoryHit
        NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: nil, userInfo: ["url" : object.urlOfIt])
    }
   /* func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let object = fetchController!.objectAtIndexPath(indexPath) as! NSManagedObject
            deleteImageIN(object.valueForKey("faviconPath") as! String)
            app.managedObjectContext.deleteObject(object)
            app.saveContext()
        }
    }*/
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        let indexPath = self.tableView?.indexPathForCell(cell)
        let object = fetchController!.objectAtIndexPath(indexPath!) as! NSManagedObject
        deleteImageIN(object.valueForKey("faviconPath") as! String)
        app.managedObjectContext.deleteObject(object)
        app.saveContext()
    }
    func topView(){
        let view = UIView(frame: CGRectMake(0, 0,  bounds.width, 50))
     
        let label = UILabel(frame: CGRectMake(25, 0, 100, 50))
        label.text = "History"
        label.font = starflyFont(18)
        label.textColor = .whiteColor()
        view.addSubview(label)
        let deleteAllButton = UIButton(frame: CGRectMake(view.bounds.width - 50, 0, 50, 50))
       // deleteAllButton.setImage(TabButtons.imageOfDelete(), forState: UIControlState.Normal)
        view.addSubview(deleteAllButton)
        addSubview(view)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("HISTI", forIndexPath: indexPath) as! SFHistoryCell
        let object = fetchController?.objectAtIndexPath(indexPath) as! HistoryHit
        cell.titleLabel?.text = object.titleOfIt
        cell.urlLabel?.text = object.urlOfIt
        cell.icon?.image = imageDictionary.objectForKey(object.faviconPath) as? UIImage
        cell.rightUtilityButtons = deleteButton() as [AnyObject]
        cell.delegate = self
        return cell
    }
   /* - (NSArray *)rightButtons
    {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
    [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
    title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
    [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
    title:@"Delete"];
    
    return rightUtilityButtons;
    }*/
    func deleteButton() -> NSArray{
        let mutableArray = NSMutableArray()
        mutableArray.sw_addUtilityButtonWithColor(.redColor(), title: "Delete")
        return mutableArray.mutableCopy() as! NSArray
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("HISTII") as! SFHistoryHeader
        let sectionInfo = self.fetchController!.sections![section] as NSFetchedResultsSectionInfo
        let datF = (UIApplication.sharedApplication().delegate as! AppDelegate).dateFormater2
        datF.dateFormat  = "dd-MM-yyyy"
        let dateToday = NSDate()
        let dayToday = datF.stringFromDate(dateToday)
        let dayStrings = sectionInfo.name
        let date = datF.dateFromString(dayStrings)
        let calendar = NSCalendar.currentCalendar()
        let dayAgo = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -6, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
        print(dayStrings)
        if (dayAgo.compare(date!) == NSComparisonResult.OrderedAscending){
            datF.dateFormat = "EEEE"
            let dayString = datF.stringFromDate(date!)
            
            if dayStrings == dayToday{
                header.dayLabel!.text = "Today"
            }else{
                header.dayLabel!.text = dayString
            }
        }else if (dayAgo.compare(date!) == NSComparisonResult.OrderedSame ||  dayAgo.compare(date!) == NSComparisonResult.OrderedDescending){
            datF.dateFormat =  "d LLLL"
            header.dayLabel!.text = datF.stringFromDate(date!)
        }
        return header
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func taskFetchRequest() -> NSFetchRequest {
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "HistoryHit")
        request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
        print(request)
        var array : NSArray? = try! app.managedObjectContext.executeFetchRequest(request)
        for homH : AnyObject in array as! [AnyObject]{
            let h = homH as! HistoryHit
            oldestItemAge = h.date
            let imagePlace = h.faviconPath
            let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
            let path = folder.stringByAppendingPathComponent(stsAr! as String)
            let image = UIImage(contentsOfFile: path)
            if let imag = image{
            
            imageDictionary.setObject(imag, forKey: imagePlace)
            }
        }
        wholeArray = array
        array = nil
        return request
        
    }
    func getArray(){
        let request : NSFetchRequest = NSFetchRequest(entityName: "HistoryHit")
        request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
        print(request)
        let array : NSArray? = try! app.managedObjectContext.executeFetchRequest(request)
        for homH : AnyObject in array as! [AnyObject]{
            let h = homH as! HistoryHit
            oldestItemAge = h.date
            let imagePlace = h.faviconPath
            let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
            let path = folder.stringByAppendingPathComponent(stsAr! as String)
            let image = UIImage(contentsOfFile: path)
            imageDictionary.setObject(image!, forKey: imagePlace)
        }
        wholeArray = array
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController)  {
         print("TEST 03")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.tableView != nil{
             self.tableView?.beginUpdates()
            }
        })
       
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)  {
         print("TEST 02")
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
            
            print("TEST 054")

            let h = anObject as! HistoryHit
            let imagePlace = h.faviconPath
            let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory()as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
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
            
        default:
            return
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
      print("TEST 05r")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView?.endUpdates()
            
        })

    }
    func configureCell(indexPath : NSIndexPath){
        
        let object = fetchController!.objectAtIndexPath(indexPath) as! HistoryHit
        let imagePlace = object.faviconPath
        let cely = self.tableView?.cellForRowAtIndexPath(indexPath) as? SFHistoryCell
            print(cely)
        if cely != nil{
            cely!.icon!.image = imageDictionary.objectForKey(imagePlace) as? UIImage
            
            
            cely!.urlLabel?.text = object.urlOfIt
            cely!.titleLabel?.text = object.titleOfIt
            
        }else{
            self.tableView!.reloadData()
        }
    }


}
class SFHistoryCell : SWTableViewCell{
    var titleLabel : UILabel?
    var urlLabel   : UILabel?
    var icon   : UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clearColor()
        titleLabel = UILabel(frame: CGRectMake(50, 3, bounds.width - 155, 25))
        titleLabel?.textColor = UIColor.blackColor()
        titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        contentView.addSubview(titleLabel!)
        urlLabel = UILabel(frame: CGRectMake(50, 22, bounds.width - 155, 25))
        urlLabel?.textColor = UIColor.grayColor()
        urlLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        contentView.addSubview(urlLabel!)
        icon = UIImageView(frame: CGRectMake(10, 10, 30, 30))
        contentView.addSubview(icon!)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        urlLabel!.frame = CGRectMake(50, 21, bounds.width - 55, 25)
        titleLabel!.frame = CGRectMake(50, 3, bounds.width - 55, 25)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class SFHistoryHeader : UITableViewHeaderFooterView{
    var dayLabel : UILabel?
    var csView : SFView?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        csView = SFView(frame: bounds)
        
        csView!.userInteractionEnabled = false
        
        addSubview(csView!)
        
        dayLabel = UILabel(frame: CGRectMake(35, 0, bounds.width - 55, 30))
        dayLabel?.textColor = UIColor.whiteColor()
        dayLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightMedium)
        addSubview(dayLabel!)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        dayLabel!.frame = CGRectMake(15, 0, bounds.width - 55, 30)
        csView?.frame = bounds
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}