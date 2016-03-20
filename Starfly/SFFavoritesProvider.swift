//
//  SFFavoritesProvider.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/10/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import CoreData

let homeCell = "HomeCell"


protocol SFFavoritesCellDelegate{
    func deleteFromDataBase(cell : SFFavoritesCell)
}


class SFFavoritesProvider: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, SFFavoritesCellDelegate {
    
    
    var fetchController : NSFetchedResultsController?
    
    var collectionView : UICollectionView? {
        didSet {
            collectionView?.delegate = self
            collectionView?.dataSource = self
        }
    }
    
    
    override init() {
        super.init()
        fetchController = NSFetchedResultsController(fetchRequest: simpleHistoryRequest, managedObjectContext: SFDataHelper.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchController?.delegate = self
    }
    
    func loadData() {
        do {
            try fetchController?.performFetch()
        } catch _ {
            
        }
    }
    
    lazy var simpleHistoryRequest : NSFetchRequest = {
        let request = NSFetchRequest(entityName: "HomeHit")
        request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: true)]
        return request
    }()
    
    
    //MARK: Delete
    func switchDeleteButton(on: Bool) {
        for cell in collectionView?.visibleCells() as! [SFFavoritesCell] {
            UIView.animateWithDuration(0.1, animations: {() -> Void in
                cell.delete?.transform = on ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.001, 0.001)
            })
        }
    }
    
    
    func deleteFromDataBase(cell : SFFavoritesCell){
        if let indexPath = self.collectionView?.indexPathForCell(cell){
            if let hit = fetchController?.objectAtIndexPath(indexPath) as? HomeHit {
                hit.removeIconsAndScreeshot()
                SFDataHelper.sharedInstance.managedObjectContext.deleteObject(hit)
                SFDataHelper.sharedInstance.saveContext()
            }
        }
    }
    
    //MARK:  NSFetchedResultsControllerDelegate
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        collectionView?.performBatchUpdates({() -> Void in
            switch type {
            case .Insert:
                
                self.collectionView?.insertItemsAtIndexPaths([newIndexPath!])
                break
            case .Delete:
                self.collectionView?.deleteItemsAtIndexPaths([indexPath!])
                break
            case .Update:
                self.configureExistingCell(indexPath!)
                break
            case .Move:
                self.collectionView?.reloadItemsAtIndexPaths([indexPath!, newIndexPath!])
                break
            }
            
            }, completion: {(fin) -> Void in
                
        })
        
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(homeCell, forIndexPath: indexPath) as! SFFavoritesCell
        cell.delegate = self
        if let hit = fetchController?.objectAtIndexPath(indexPath) as? HomeHit {
            cell.label?.text = hit.title
            cell.imageView?.image = hit.screenshot
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchController!.sections![0].numberOfObjects
    }
    
    func configureExistingCell(indexPath : NSIndexPath) {
        if let hit = fetchController?.objectAtIndexPath(indexPath) as? HomeHit {
            
            if let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? SFFavoritesCell {
                cell.label?.text = hit.title
                cell.imageView?.image = hit.screenshot
                cell.delegate = self
            }
        }
    }
    
    //MARK: LXDelegate
    func collectionView(collectionView: UICollectionView!, itemAtIndexPath fromIndexPath: NSIndexPath!, willMoveToIndexPath toIndexPath: NSIndexPath!) {
        print("from \(fromIndexPath.row) to \(toIndexPath.row)")
        let fromIndex = fromIndexPath.row
        let toIndex = toIndexPath.row
        if fromIndex == toIndex {
            return
        }
        var count = 0
        if let s = fetchController!.sections as [NSFetchedResultsSectionInfo]! {
            count = s[0].numberOfObjects
        }
        
        let movingObject = fetchController!.objectAtIndexPath(fromIndexPath) as! HomeHit
        let toObject = fetchController!.objectAtIndexPath(toIndexPath) as! HomeHit
        let toDisplayOrder = Float(toObject.arrangeIndex!.floatValue)
        var newIndex : Float?
        if fromIndex < toIndex {
            
            if toIndex == count - 1 {
                newIndex = toDisplayOrder + 1
            } else {
                let object = fetchController!.objectAtIndexPath(NSIndexPath(forRow: toIndex + 1, inSection: 0)) as! HomeHit
                let objectDisplayOrder = Float(object.arrangeIndex!.floatValue)
                newIndex = toDisplayOrder + (objectDisplayOrder - toDisplayOrder) / 2.0
                
                
            }
        } else {
            if toIndex == 0 {
                newIndex = toDisplayOrder - 1
            } else {
                let object = fetchController!.objectAtIndexPath(NSIndexPath(forRow: toIndex - 1, inSection: 0)) as! HomeHit
                let objectDisplayOrder = Float(object.arrangeIndex!.floatValue)
                newIndex = objectDisplayOrder + (toDisplayOrder - objectDisplayOrder) / 2.0
                
            }
        }
        movingObject.arrangeIndex = NSNumber(float: newIndex!)
        SFDataHelper.sharedInstance.saveContext()
        
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let hit = fetchController?.objectAtIndexPath(indexPath) as? HomeHit {
            NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: hit.getURL())
            
            
            self.loadNewImageForHit(hit, indexPath: indexPath)
            
        }
    }
    
    //MARK: Retreive new Image
    func loadNewImageForHit(hit : HomeHit, indexPath: NSIndexPath) {
        
        let imageFileName = (hit.bigImage! as NSString).lastPathComponent
        let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
        let imagePath = folder.stringByAppendingPathComponent(imageFileName as String)
        if fileIsOlderThanDay(imagePath) {
            dispatch_async(dispatch_get_main_queue()) {() -> Void in
                self.updateItem(hit.getURL(), completion: {(newData: NSDictionary) -> Void in
                    hit.url = newData.valueForKey("url") as? String
                    hit.title = newData.valueForKey("title") as? String
                    hit._screenshot = nil
                    let image = newData.valueForKey("shoot") as! UIImage
                    let dataBig = UIImagePNGRepresentation(image)
                    
                    if let data = dataBig {
                        data.writeToFile(imagePath as String, atomically: true)
                    }
                    self.configureExistingCell(indexPath)
                })
            }
        }
    }
    
    func updateItem(url : NSURL, completion: (NSDictionary) -> Void) {
        let dict = NSMutableDictionary()
        let web = SFWebController()
        
        web.view.frame = CGRect(x: 0, y: 1024, width: 850, height: 768)
        collectionView?.addSubview(web.view)
        
        web.openURL(url)
        
        web.newContentLoaded = {(b : Bool) in
            web.webView?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            delay(2.0, closure: {() -> () in
                
                if let screenShot = web.webView?.takeSnapshotForHomePage() {
                    dict.setObject(screenShot, forKey: "shoot")
                    dict.setObject(web.webView!.title!, forKey: "title")
                    dict.setObject(web.webView!.URL!.absoluteString, forKey: "url")
                    completion(dict)
                }
                web.view.removeFromSuperview()
            })
            
        }
        
    }
    
    func fileIsOlderThanDay(path : NSString) -> Bool {
        var creationDate : NSDate? = NSDate()
        if NSFileManager.defaultManager().fileExistsAtPath(path as String) {
            
            let attr = try? NSFileManager.defaultManager().attributesOfItemAtPath(path as String)
            if let atrribute = attr {
                creationDate = atrribute[NSFileModificationDate] as? NSDate
            }
        }
        return daysBetweenThisDate(creationDate!, andThisDate: NSDate()) >= 1 ? true : false
    }
    func daysBetweenThisDate(fromDateTime: NSDate, andThisDate toDateTime: NSDate) -> Int? {
        
        var fromDate: NSDate? = nil
        var toDate: NSDate? = nil
        
        let calendar = NSCalendar.currentCalendar()
        
        calendar.rangeOfUnit(NSCalendarUnit.NSDayCalendarUnit, startDate: &fromDate, interval: nil, forDate: fromDateTime)
        
        calendar.rangeOfUnit(NSCalendarUnit.NSDayCalendarUnit, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        if let from = fromDate {
            
            if let to = toDate {
                
                let difference = calendar.components(NSCalendarUnit.NSDayCalendarUnit, fromDate: from, toDate: to, options: NSCalendarOptions.MatchStrictly)
                
                return difference.day
            }
        }
        
        return nil
    }
    
    
}
