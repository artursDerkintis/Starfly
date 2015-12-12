//
//  SFHistoryDataProvider.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/10/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import CoreData

let historyCell = "historyCell"
let historyHeader = "historyHeader"

class SFHistoryProvider: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, SWTableViewCellDelegate {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    private var fetchController : NSFetchedResultsController?
    
    var iconDictionary = NSMutableDictionary()
    
    var tableView : UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    
    var request : NSFetchRequest!
    
    override init() {
        super.init()
        request = simpleHistoryRequest()
        cacheIcons(request)
        fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "sectionId", cacheName: nil)
        
        fetchController?.delegate = self
        
    }
    
    func loadData() {
        do {
            try fetchController?.performFetch()
            
            tableView?.reloadData()
        } catch _ {
            
        }
    }
    
    func simpleHistoryRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "HistoryHit")
        request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
        return request
    }
    
    func cacheIcons(request : NSFetchRequest) {
        do {
            if let hits = try appDelegate.managedObjectContext.executeFetchRequest(request) as? [HistoryHit] {
                for hit in hits {
                    let iconFileName = (hit.faviconPath as NSString).lastPathComponent
                    let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
                    let iconPath = folder.stringByAppendingPathComponent(iconFileName as String)
                    if let icon = UIImage(contentsOfFile: iconPath) {
                        iconDictionary.setObject(icon, forKey: hit.faviconPath)
                    }
                }
            }
        } catch _ {
            
        }
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            self.tableView?.beginUpdates()
        })
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            if self.tableView != nil{
                self.tableView?.endUpdates()
            }
        })
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            switch type {
            case .Insert:
                if let hit = anObject as? HistoryHit {
                    let iconFileName = (hit.faviconPath as NSString).lastPathComponent
                    let folder = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
                    let iconPath = folder.stringByAppendingString(iconFileName as String)
                    if let icon = UIImage(contentsOfFile: iconPath) {
                        self.iconDictionary.setObject(icon, forKey: hit.faviconPath)
                    }
                }
                break
            case .Delete:
                if let hit = anObject as? HistoryHit {
                    self.deleteImage(hit.faviconPath)
                }
                self.tableView?.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                break
            case .Move:
                self.tableView?.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                break
            case .Update:
                self.configureExistingCell(indexPath!)
                break
            }
        })
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
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
    
    
    //MARK: SWTableViewDelegate
    func deleteButton() -> NSArray {
        let mutableArray = NSMutableArray()
        mutableArray.sw_addUtilityButtonWithColor(.redColor(), title: "Delete")
        return mutableArray.mutableCopy() as! NSArray
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        let indexPath = self.tableView?.indexPathForCell(cell)
        if let hit = fetchController!.objectAtIndexPath(indexPath!) as? HistoryHit {
            deleteImage(hit.faviconPath)
            appDelegate.managedObjectContext.deleteObject(hit)
            appDelegate.saveContext()
        }
        
    }
    
    //Delete
    func deleteLastHour(){
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(NSCalendarUnit.Hour, value: -1, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
        
        for hit in fetchController!.fetchedObjects as! [HistoryHit]{
            if hit.date.compare(date) == NSComparisonResult.OrderedSame ||  hit.date.compare(date) == NSComparisonResult.OrderedDescending{
                
                deleteImage(hit.faviconPath)
                
                appDelegate.managedObjectContext.deleteObject(hit)
            }else{
                break
            }
        }
        appDelegate.saveContext()
    }
    func deleteToday(){
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
        
        for hit in fetchController!.fetchedObjects as! [HistoryHit]{
            if hit.date.compare(date) == NSComparisonResult.OrderedSame ||  hit.date.compare(date) == NSComparisonResult.OrderedDescending{
                
                deleteImage(hit.faviconPath)
                appDelegate.managedObjectContext.deleteObject(hit)
            }else{
                break
            }
        }
        appDelegate.saveContext()
    }
    func deleteThisWeek(){
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -7, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
        
        for hit in fetchController!.fetchedObjects as! [HistoryHit]{
            if hit.date.compare(date) == NSComparisonResult.OrderedSame ||  hit.date.compare(date) == NSComparisonResult.OrderedDescending{
                
                deleteImage(hit.faviconPath)
                appDelegate.managedObjectContext.deleteObject(hit)
            }else{
                break
            }
        }
        appDelegate.saveContext()
    }
    func deleteAll(){
        for hit in fetchController!.fetchedObjects as! [HistoryHit]{
            deleteImage(hit.faviconPath)
            appDelegate.managedObjectContext.deleteObject(hit)
        }
        appDelegate.saveContext()

    }
    func deleteAllAndDeep(){
        deleteAll()
        
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
            let s: [AnyObject]?
            do {
                s = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path!)
            } catch let error as NSError {
                print(error)
                s = nil
            }
            if s != nil && s?.count != 0{
                for fileString : AnyObject in s! as [AnyObject] {
                    if fileString.pathExtension == "localstorage"{
                        let pathd = (path! as NSString).stringByAppendingPathComponent(fileString as! String)
                        var error : NSError?
                        do {
                            try NSFileManager.defaultManager().removeItemAtPath(pathd)
                            
                        } catch let error1 as NSError {
                            error = error1
                        }
                        if error != nil{
                            print(error?.localizedDescription)
                        }
                        
                    }}
            }}

        
    }
    func deleteImage(stringPath : NSString) {
        let stsAr : NSString? = stringPath.lastPathComponent
        let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
        let path = folder.stringByAppendingPathComponent(stsAr! as String)
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(historyCell, forIndexPath: indexPath) as! SFHistoryCell
        let object = fetchController?.objectAtIndexPath(indexPath) as! HistoryHit
        cell.titleLabel?.text = object.titleOfIt
        cell.urlLabel?.text = object.urlOfIt
        cell.icon?.image = iconDictionary.objectForKey(object.faviconPath) as? UIImage
        cell.rightUtilityButtons = deleteButton() as [AnyObject]
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.fetchController!.sections?.count > 0{
            let sectionInfo = self.fetchController!.sections![section]
            return sectionInfo.numberOfObjects
            
        }else{return 0}
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchController!.sections?.count ?? 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(historyHeader) as! SFHistoryHeader
        let sectionInfo = self.fetchController!.sections![section] as NSFetchedResultsSectionInfo
        
        appDelegate.dateFormater2.dateFormat = "dd-MM-yyyy"
        let dateToday = NSDate()
        let dayToday = appDelegate.dateFormater2.stringFromDate(dateToday)
        let dayStrings = sectionInfo.name
        let date = appDelegate.dateFormater2.dateFromString(dayStrings)
        let calendar = NSCalendar.currentCalendar()
        let dayAgo = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -6, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)!
        if (dayAgo.compare(date!) == NSComparisonResult.OrderedAscending) {
            appDelegate.dateFormater2.dateFormat = "EEEE"
            let dayString = appDelegate.dateFormater2.stringFromDate(date!)
            if dayStrings == dayToday {
                header.dayLabel!.text = "Today"
            } else {
                header.dayLabel!.text = dayString
            }
        } else if (dayAgo.compare(date!) == NSComparisonResult.OrderedSame || dayAgo.compare(date!) == NSComparisonResult.OrderedDescending) {
            appDelegate.dateFormater2.dateFormat = "d LLLL"
            header.dayLabel!.text = appDelegate.dateFormater2.stringFromDate(date!)
        }
        return header
    }
    
    func configureExistingCell(indexPath: NSIndexPath) {
        if let hit = fetchController?.objectAtIndexPath(indexPath) as? HistoryHit {
            if let cell = self.tableView?.cellForRowAtIndexPath(indexPath) as?SFHistoryCell {
                cell.icon?.image = iconDictionary.objectForKey(hit.faviconPath) as? UIImage
                cell.urlLabel?.text = hit.urlOfIt
                cell.titleLabel?.text = hit.titleOfIt
            } else {
                self.tableView?.endUpdates()
                
                self.tableView?.reloadData()
            }
        }
    }
    //MARK: UITableViewDelagate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if let object = fetchController?.objectAtIndexPath(indexPath) as? HistoryHit {
            NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: object.urlOfIt)
        }
    }
}
