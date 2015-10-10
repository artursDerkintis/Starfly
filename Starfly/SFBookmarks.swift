//
//  SFBookmarks.swift
//  StarflyV2
//
//  Created by Neal Caffrey on 5/1/15.
//  Copyright (c) 2015 Neal Caffrey. All rights reserved.
//

import UIKit
import CoreData
class SFBookmarks: UIView, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout {
    var collection : UICollectionView?
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    private var fetchedResultController: NSFetchedResultsController?
    var faviconDictionary = NSMutableDictionary()
    var imageDictionary   = NSMutableDictionary()
    
    var edit    : UIButton?
    var big = NSUserDefaults.standardUserDefaults().boolForKey("bookcels")
    var editingCells = false
  //  var delegate : SFOpenMeDelegate?
    override init(frame : CGRect){
        super.init(frame: frame)
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController!.delegate = self
        
        let layout = LXReorderableCollectionViewFlowLayout()
        layout.isEditable = true
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        layout.itemSize = CGSize(width: frame.width * 0.4, height: 50)
        collection = UICollectionView(frame: CGRectMake(0, 0, bounds.width, bounds.height), collectionViewLayout: layout)
        
        collection?.registerClass(SFBookmarkCell.self, forCellWithReuseIdentifier: "BooksCell")
        collection?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        collection?.bounces = true
        collection?.dataSource = self
        collection?.contentInset = UIEdgeInsets(top: 50, left: 50, bottom: 150, right: 50)
        collection?.delegate = self
        
        collection?.showsVerticalScrollIndicator = false
        collection?.clipsToBounds = true
        collection?.backgroundColor = .clearColor()
        addSubview(collection!)
        
        collection?.reloadData()
      
        edit = UIButton(frame: CGRectMake(bounds.width - 50, bounds.height - 50, 40, 40))
       
        edit?.layer.masksToBounds = true
        edit?.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleLeftMargin]
       
        edit?.tag = 0
        edit?.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        edit?.addTarget(self, action: "edit:", forControlEvents: UIControlEvents.TouchUpInside)
        //addSubview(edit!)

    }
    func load(){
        
        do {
            try fetchedResultController!.performFetch()
            collection?.reloadData()
        } catch _ {
            }
    }
   
    func editCells(on onoroff : Bool){
        if onoroff != editingCells{
            if onoroff {
                for cell in self.collection?.visibleCells() as! [SFBookmarkCell]{
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        cell.delete!.transform = CGAffineTransformIdentity
                    })
                    cell.delete?.addTarget(self, action: "deleteCell:", forControlEvents: UIControlEvents.TouchDown)
                }
            }else{
                for cell in self.collection?.visibleCells() as! [SFBookmarkCell]{
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        cell.delete!.transform = CGAffineTransformMakeScale(0.01, 0.01)
                    })
                    cell.delete?.addTarget(self, action: "deleteCell:", forControlEvents: UIControlEvents.TouchDown)
                }
            }}
        editingCells = onoroff
    }
    func deleteCell(sender : SFButton){
        if sender.superview!.isKindOfClass(SFBookmarkCell){
            if let cell = sender.superview as? SFBookmarkCell{
                deleteCellFromCollectionView(self.collection!.indexPathForCell(cell)!)
            }
        }
    }

    func deleteCellFromCollectionView(index: NSIndexPath) {
        let object = fetchedResultController?.objectAtIndexPath(index) as! Bookmarks
        deleteImageIN(object.bigImage)
        deleteImageIN(object.favicon)
        managedObjectContext.deleteObject(object)
        app.saveContext()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collection?.reloadData()
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print(collection!.frame.width)
        return CGSize(width: max(collection!.frame.width * 0.4, 300), height: 50)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SFBookmarkCell
        let urel = parseUrl(cell.urlWW!)
        print(urel)
        NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: nil, userInfo: ["url" : urel!])
        
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
        
        let movingObject = fetchedResultController!.objectAtIndexPath(fromIndexPath) as! Bookmarks
        let toObject = fetchedResultController!.objectAtIndexPath(toIndexPath) as! Bookmarks
        let toDisplayOrder = Float(toObject.arrangeIndex)
        var newIndex : Float?
        if fromIndex < toIndex {
            //movingUp
            if toIndex == count - 1{
                newIndex = toDisplayOrder + 1
            }else{
                let object = fetchedResultController!.objectAtIndexPath(NSIndexPath(forRow: toIndex + 1, inSection: 0)) as! Bookmarks
                let objectDisplayOrder = Float(object.arrangeIndex)
                newIndex = toDisplayOrder + (objectDisplayOrder - toDisplayOrder) / 2.0
                
                
            }
        }else{
            if toIndex == 0{
                newIndex = toDisplayOrder -  1
                
            }else{
                let object = fetchedResultController!.objectAtIndexPath(NSIndexPath(forRow: toIndex - 1, inSection: 0)) as! Bookmarks
                let objectDisplayOrder = Float(object.arrangeIndex)
                newIndex = objectDisplayOrder + (toDisplayOrder - objectDisplayOrder) / 2.0
                
            }
        }
        movingObject.arrangeIndex = NSNumber(float: newIndex!)
        app.saveContext()
        //println(self.array)
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BooksCell", forIndexPath: indexPath) as! SFBookmarkCell
        let object = fetchedResultController?.objectAtIndexPath(indexPath) as! Bookmarks
        cell.shootImage?.image = imageDictionary.objectForKey(object.bigImage) as? UIImage
        cell.favicon?.image = faviconDictionary.objectForKey(object.favicon) as? UIImage
        cell.urlWW = object.url
        cell.titleLabel?.text = object.title
        
        let color = NSKeyedUnarchiver.unarchiveObjectWithData(object.color) as! UIColor
   
        cell.collectionVIew = collection
        cell.overLayer!.backgroundColor = color.colorWithAlphaComponent(0.8).CGColor
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
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let s = fetchedResultController!.sections as [NSFetchedResultsSectionInfo]! {
             let d = s[section].numberOfObjects
            return d
        }
        return 0
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                let h = controller.objectAtIndexPath(newIndexPath!) as! Bookmarks
                let imagePlace = h.bigImage
                let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
                let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
                let path = folder.stringByAppendingPathComponent(stsAr! as String)
                let image = UIImage(contentsOfFile: path)
                self.imageDictionary.setObject(image!, forKey: imagePlace)
                let iconPlace = h.favicon
                let stsArs : NSString? = (iconPlace as NSString).lastPathComponent
                let folders : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
                let paths = folders.stringByAppendingPathComponent(stsArs! as String)
                let images = UIImage(contentsOfFile: paths)
                self.faviconDictionary.setObject(images!, forKey: iconPlace)
                
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
    
    func deleteImageIN(stringPath : NSString){
        
        let stsAr : NSString? = (stringPath as NSString).lastPathComponent
        let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
        let path = folder.stringByAppendingPathComponent(stsAr! as String)
        var error : NSError?
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
           
        } catch var error1 as NSError {
        }
        if error != nil{
            print(error?.localizedDescription)
        }
    }
    
    
    func taskFetchRequest() -> NSFetchRequest {
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "Bookmarks")
        request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: true)]
        print(request)
        var error : NSError? = nil
        var array : NSArray? = try! app.managedObjectContext.executeFetchRequest(request)
        for homH : AnyObject in array as! [AnyObject]{
            let h = homH as! Bookmarks
            let imagePlace = h.bigImage
            let stsAr : NSString? = (imagePlace as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
            let path = folder.stringByAppendingPathComponent(stsAr! as String)
            let image = UIImage(contentsOfFile: path)
            imageDictionary.setObject(image!, forKey: imagePlace)
            let iconPlace = h.favicon
            let stsArs : NSString? = (iconPlace as NSString).lastPathComponent
            let folders : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
            let paths = folders.stringByAppendingPathComponent(stsArs! as String)
            let images = UIImage(contentsOfFile: paths)
            faviconDictionary.setObject(images!, forKey: iconPlace)
        }
        array = nil
        return request
        
    }
    func configureCell(indexPath : NSIndexPath){
        
        let object = fetchedResultController!.objectAtIndexPath(indexPath) as! Bookmarks
        
        let cely = self.collection!.cellForItemAtIndexPath(indexPath) as? SFBookmarkCell
        print(cely)
        if cely != nil{
            cely!.shootImage!.image = imageDictionary.objectForKey(object.bigImage) as? UIImage
            cely?.favicon?.image = faviconDictionary.objectForKey(object.favicon) as? UIImage
          
            cely!.urlWW = object.url
            cely!.titleLabel?.text = object.title
            
            let color = NSKeyedUnarchiver.unarchiveObjectWithData(object.color) as! UIColor
            
            cely!.collectionVIew = collection
            cely!.overLayer!.backgroundColor = color.colorWithAlphaComponent(0.8).CGColor
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

    
}
struct CellHeight{
    static let fullHeight  : CGFloat = 120
    static let smallHeight : CGFloat = 50
}
class SFBookmarkCell: UICollectionViewCell {
    
    var titleLabel : UILabel?
    var urlWW : String?
    var shootImage : UIImageView?
    var favicon    : UIImageView?
    var delete : SFButton?
    var collectionVIew : UICollectionView?
    var overLayer : CALayer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.height * 0.5
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale

        
        overLayer = CALayer()
        overLayer?.frame = self.bounds
        overLayer?.cornerRadius = frame.height * 0.5
        layer.addSublayer(overLayer!)
        backgroundColor = .whiteColor()
        shootImage?.hidden = true
        titleLabel = UILabel(frame: CGRectMake(55, 0, bounds.width - 60, 50))
        
        titleLabel?.font =  UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        titleLabel?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        titleLabel?.layer.shadowOffset = CGSizeMake(0, lineWidth())
        titleLabel?.layer.shadowOpacity = 1.0
        titleLabel?.layer.shadowRadius = 0
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        titleLabel?.layer.rasterizationScale = UIScreen.mainScreen().scale
        titleLabel?.layer.shouldRasterize = true
        addSubview(titleLabel!)
        favicon = UIImageView(frame: CGRectMake(15, 15, 20, 20))
        addSubview(favicon!)
  
        delete = SFButton(type: UIButtonType.Custom)
        delete?.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        delete?.setImage(UIImage(named: Images.closeTab), forState: UIControlState.Normal)
        delete?.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        delete?.layer.cornerRadius = delete!.frame.size.height * 0.5
        delete?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        delete?.layer.shadowOffset = CGSize(width: 0, height: 0)
        delete?.layer.shadowRadius = 2
        delete?.layer.shadowOpacity = 1.0
        delete?.layer.rasterizationScale = UIScreen.mainScreen().scale
        delete?.layer.shouldRasterize = true
        delete?.transform = CGAffineTransformMakeScale(0.01, 0.01)
        addSubview(delete!)

    }
    func deleteme(){
        
        
    }
    
    

    override func layoutSubviews() {
        super.layoutSubviews()
        overLayer?.frame = self.bounds
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}