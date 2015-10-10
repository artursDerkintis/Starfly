//
//  SFBookmarksVC.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/18/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import WebKit
import CoreData
class SFHomeCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    private var collection : UICollectionView?
    //var infoArray = getAllHomeHitArray()
    private var imageDictionary = NSMutableDictionary()
    var app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var editButton : UIButton?
    var editingCells = false
    private var fetchedResultController: NSFetchedResultsController?
    override func viewDidLoad(){
        super.viewDidLoad()
        let layout = LXReorderableCollectionViewFlowLayout()
        
        layout.isEditable = true
        
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 25
        layout.itemSize = CGSizeMake(160, 130)
        collection = UICollectionView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height), collectionViewLayout: layout)
        collection?.registerClass(SFHomeCell.self, forCellWithReuseIdentifier: "MiNiI")
        collection?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        collection?.dataSource = self
        collection?.contentInset = UIEdgeInsets(top: 50, left: 50, bottom: 120, right: 50)
       
        collection?.delegate = self
        collection?.showsVerticalScrollIndicator = false
        collection?.clipsToBounds = true
        collection?.backgroundColor = .clearColor()
        view.addSubview(collection!)
        
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController!.delegate = self
        
        do {
            try fetchedResultController!.performFetch()
        } catch _ {
        }
        collection?.reloadData()
        
    }
    func editCells(on onoroff : Bool){
        if onoroff != editingCells{
        if onoroff {
            for cell in self.collection?.visibleCells() as! [SFHomeCell]{
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    cell.delete!.transform = CGAffineTransformIdentity
                })
                cell.delete?.addTarget(self, action: "deleteCell:", forControlEvents: UIControlEvents.TouchDown)
            }
        }else{
            for cell in self.collection?.visibleCells() as! [SFHomeCell]{
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    cell.delete!.transform = CGAffineTransformMakeScale(0.01, 0.01)
                })
                cell.delete?.addTarget(self, action: "deleteCell:", forControlEvents: UIControlEvents.TouchDown)
            }
            }}
        editingCells = onoroff
    }
    func deleteCell(sender : SFButton){
        if sender.superview!.isKindOfClass(SFHomeCell){
            if let cell = sender.superview as? SFHomeCell{
                deleteCellFromCollectionView(self.collection!.indexPathForCell(cell)!)
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
           }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController)  {
        // println("TEST 03")
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)  {
        // println("TEST 02")
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        // println("TEST 01")
        collection!.performBatchUpdates({ () -> Void in
            switch type {
            case .Insert:
                self.collection!.insertItemsAtIndexPaths([newIndexPath!])
                let h = anObject as! HomeHit
                let imagePlace = h.bigImage
                let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
                let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
                let path = folder.stringByAppendingPathComponent(stsAr! as String)
                let image = UIImage(contentsOfFile: path)
                self.imageDictionary.setObject(image!, forKey: imagePlace)
                
                break
            case .Delete:
                self.collection!.deleteItemsAtIndexPaths([indexPath!])
                
                break
            case .Update:
                print(indexPath!.section)
                
                self.configureCell(indexPath!)
                break
            case .Move:
                
                self.collection!.reloadItemsAtIndexPaths([indexPath!, newIndexPath!])
                
                break
                
            default:
                return
            }
            
            }, completion: { (finish) -> Void in
                
        })
        
        
    }
    
    
    
    func deleteCellFromCollectionView(index: NSIndexPath) {
        let object = fetchedResultController?.objectAtIndexPath(index) as! HomeHit
        deleteImageIN(object.bigImage)
        managedObjectContext.deleteObject(object)
        
        app.saveContext()
    }
    func checkAndDelete(url : String){
        let req = NSFetchRequest(entityName: "BooksHomeList")
        let array = try! app.managedObjectContext.executeFetchRequest(req)
        for a in array{
            if (a.valueForKey("url") as! String) == url{
                app.managedObjectContext.deleteObject(a as! NSManagedObject)
            }
        }
        app.saveContext()
    }

    func deleteImageIN(stringPath : NSString){
        let stsAr : NSString? = stringPath.lastPathComponent
        if stsAr == nil {return}
        let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
        let path = folder.stringByAppendingPathComponent(stsAr! as String)
        var error : NSError?
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
    
        } catch var error1 as NSError {
            error = error1
        }
        if error != nil{
            print(error?.localizedDescription)
            }
    }
    func taskFetchRequest() -> NSFetchRequest {
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "HomeHit")
        request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: true)]
        print(request)
        var error : NSError? = nil
        var array : NSArray? = try! app.managedObjectContext.executeFetchRequest(request)
        for homH : AnyObject in array as! [AnyObject]{
            let h = homH as! HomeHit
            let imagePlace = h.bigImage
            let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
            let path = folder.stringByAppendingPathComponent(stsAr! as String)
            let image = UIImage(contentsOfFile: path)
            if let imag = image{
            imageDictionary.setObject(image!, forKey: imagePlace)
            }
        }
        array = nil
        return request
        
    }
    func configureCell(indexPath : NSIndexPath){
        
        let object = fetchedResultController!.objectAtIndexPath(indexPath) as! HomeHit
        let imagePlace = object.bigImage
        let cely = self.collection!.cellForItemAtIndexPath(indexPath) as? SFHomeCell
        print(cely)
        if cely != nil{
            cely!.imageView!.image = imageDictionary.objectForKey(imagePlace) as? UIImage
           
            
            cely!.label!.text = object.title
            if editingCells{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                cely!.transform = CGAffineTransformIdentity
            })
            cely!.delete?.addTarget(self, action: "deleteCell:", forControlEvents: UIControlEvents.TouchDown)
            }else{
                cely!.delete!.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }
        }else{
            self.collection!.reloadData()
        }
    }
    func collectionView(collectionView: UICollectionView!, itemAtIndexPath fromIndexPath: NSIndexPath!, willMoveToIndexPath toIndexPath: NSIndexPath!) {
        print("from \(fromIndexPath.row) to \(toIndexPath.row)")
        
        let fromIndex = fromIndexPath.row
        let toIndex   = toIndexPath.row
        if fromIndex == toIndex {
            return
        }
        var count = 0
        if let s = fetchedResultController!.sections as [NSFetchedResultsSectionInfo]!{
            count = s[0].numberOfObjects
        }
        
        let movingObject = fetchedResultController!.objectAtIndexPath(fromIndexPath) as! HomeHit
        let toObject = fetchedResultController!.objectAtIndexPath(toIndexPath) as! HomeHit
        let toDisplayOrder = Float(toObject.arrangeIndex)
        var newIndex : Float?
        if fromIndex < toIndex {
            //movingUp
            if toIndex == count - 1{
                newIndex = toDisplayOrder + 1
            }else{
                let object = fetchedResultController!.objectAtIndexPath(NSIndexPath(forRow: toIndex + 1, inSection: 0)) as! HomeHit
                let objectDisplayOrder = Float(object.arrangeIndex)
                newIndex = toDisplayOrder + (objectDisplayOrder - toDisplayOrder) / 2.0
                
                
            }
        }else{
            if toIndex == 0{
                newIndex = toDisplayOrder -  1
                
            }else{
                let object = fetchedResultController!.objectAtIndexPath(NSIndexPath(forRow: toIndex - 1, inSection: 0)) as! HomeHit
                let objectDisplayOrder = Float(object.arrangeIndex)
                newIndex = objectDisplayOrder + (toDisplayOrder - objectDisplayOrder) / 2.0
                
            }
        }
        movingObject.arrangeIndex = NSNumber(float: newIndex!)
        app.saveContext()
        //println(self.array)
        
    }
    func updateColLl(){
        do {
            try fetchedResultController!.performFetch()
        } catch _ {
        }
        //infoArray = getAllHomeHitArray()
        // collection?.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let s = fetchedResultController!.sections as [NSFetchedResultsSectionInfo]! {
            var d = s[section].numberOfObjects
            return d
        }
        return 0
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object = fetchedResultController!.objectAtIndexPath(indexPath) as! HomeHit
        let url = object.url
        NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: nil, userInfo: ["url" : url])
              
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let imagePlace = object.bigImage
            let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
            let path = folder.stringByAppendingPathComponent(stsAr! as String)
            if self.olderThanDay(path){
            self.updateItem(NSURL(string: parseUrl(url)!)!, completion: { (newData : NSDictionary) -> Void in
                object.url = newData.valueForKey("url") as! String
                object.title = newData.valueForKey("title") as! String
                (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                let image = newData.valueForKey("shoot") as! UIImage
                let dataBig = UIImagePNGRepresentation(image)
                
                if let data = dataBig{
                self.imageDictionary.setValue(image, forKey: imagePlace)
                data.writeToFile(path as String, atomically: true)
                }
                
                self.collection?.reloadItemsAtIndexPaths([indexPath])

            })}
        }
        
    }
    func olderThanDay(path : NSString) -> Bool{
        var creationDate : NSDate? = NSDate()
        if NSFileManager.defaultManager().fileExistsAtPath(path as String){
            
            let attr = try? NSFileManager.defaultManager().attributesOfItemAtPath(path as String)
            if let atrribute = attr{
            creationDate = atrribute[NSFileModificationDate] as? NSDate
            }
        }
        return daysBetweenThisDate(creationDate!, andThisDate: NSDate()) >= 1 ? true : false
    }
    func daysBetweenThisDate(fromDateTime:NSDate, andThisDate toDateTime:NSDate)->Int?{
        
        var fromDate:NSDate? = nil
        var toDate:NSDate? = nil
        
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
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MiNiI", forIndexPath: indexPath) as! SFHomeCell
        
        let object = fetchedResultController!.objectAtIndexPath(indexPath) as! HomeHit
        print(object.arrangeIndex)
        cell.imageView!.image = imageDictionary.objectForKey(object.bigImage) as? UIImage
        
        
        cell.label?.text = object.title
        if editingCells{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                cell.transform = CGAffineTransformIdentity
            })
            cell.delete?.addTarget(self, action: "deleteCell:", forControlEvents: UIControlEvents.TouchDown)
        }else{
            cell.delete!.transform = CGAffineTransformMakeScale(0.01, 0.01)
        }
        return cell
        
    }
    func updateItem(url : NSURL, completion:(NSDictionary) -> Void){
        let dict = NSMutableDictionary()
        let web = SFWebVC()
        
        web.view.frame = CGRect(x: 0, y: 1024, width: 1024, height: 768)
        self.view.addSubview(web.view)
        
        web.openURL(url)
       
        web.newContentLoaded = {(b : Bool) in
            print("LOADED FAKE WEBVIEW")
            delay(2.0, closure: { () -> () in
                let screenShot = web.webView!.takeSnapshotForHomePage()
                dict.setObject(screenShot, forKey: "shoot")
                dict.setObject(web.webView!.title!, forKey: "title")
                dict.setObject(web.webView!.URL!.absoluteString, forKey: "url")
                completion(dict)
                web.view.removeFromSuperview()
            })
            
            }
        
    }
    override func viewWillLayoutSubviews() {
        
        //frontColore(UIColor(rgba: "#008aff").colorWithAlphaComponent(0.35), withBackgroundColor: UIColor.whiteColor())
        // mask()
    }
}

