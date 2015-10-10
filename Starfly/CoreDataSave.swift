//
//  CoreDataSave.swift
//  StarflyV2
//
//  Created by Neal Caffrey on 4/8/15.
//  Copyright (c) 2015 Neal Caffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MessageUI
import Social
public func saveInFavorites(array : NSDictionary) {
    let title : String = array.objectForKey("title") as! String
    let url : String = array.objectForKey("url") as! String

    let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let name : String = String(format: "%@.png", randomString(11))
    let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
    if NSFileManager.defaultManager().fileExistsAtPath(folder as String) == false{
        let error : NSError? = nil
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(folder as String, withIntermediateDirectories: false, attributes: nil)
        } catch let error1 as NSError {
            
        }
        
    }


    let dataBig : NSData = UIImagePNGRepresentation(array.objectForKey("imageScreenShoot") as! UIImage)!
    let nameBig : NSString = NSString(format: "%@.png", randomString(11))
   
    let newFileBig : String = String(format: folder.stringByAppendingPathComponent(nameBig as String))
    dataBig.writeToFile(newFileBig as String, atomically: true)

    let newObj : NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("HomeHit", inManagedObjectContext: app.managedObjectContext) as NSManagedObject
    newObj.setValue(title, forKey: "title")
    newObj.setValue(newFileBig, forKey: "bigImage")
    newObj.setValue(url, forKey: "url")
    let requeste : NSFetchRequest = NSFetchRequest(entityName: "HomeHit")
    requeste.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: true)]
    let error : NSError? = nil
    let resultds : NSArray? = try! app.managedObjectContext.executeFetchRequest(requeste)
    let obj : NSManagedObject = resultds?.objectAtIndex(resultds!.count - 1) as! NSManagedObject
    let index : Float = obj.valueForKey("arrangeIndex") as! Float
    newObj.setValue(index + 1.0 , forKey: "arrangeIndex")
        app.saveContext()
    
    //println("Home Hit: \(getAllHomeHitArray())")
}
public func saveInBookmarks(array : NSDictionary) {
    let title : String = array.objectForKey("title") as! String
    let url : String = array.objectForKey("url") as! String
    
    let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let data : NSData = UIImagePNGRepresentation(array.objectForKey("image") as! UIImage)!
    let main = ew.getEw().mainColoursInImage(array.objectForKey("image") as! UIImage, detail: 0) as NSMutableArray
    let color = main.objectAtIndex(0) as! UIColor
    let dataColor = NSKeyedArchiver.archivedDataWithRootObject(color)
    
    let name : String = String(format: "%@.png", randomString(11))
    let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
    if NSFileManager.defaultManager().fileExistsAtPath(folder as String) == false{
        let error : NSError? = nil
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(folder as String, withIntermediateDirectories: false, attributes: nil)
        } catch let error1 as NSError {
            
        }
        
    }
    let newFile : String = String(format: folder.stringByAppendingPathComponent(name))
    data.writeToFile(newFile, atomically: true)
    let newObj : NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Bookmarks", inManagedObjectContext: app.managedObjectContext) as NSManagedObject
    if let image = array.objectForKey("imageScreenShoot") as? UIImage{
    let dataBig : NSData = UIImagePNGRepresentation(image)!
    let nameBig : NSString = NSString(format: "%@.png", randomString(11))
    
    let newFileBig : String = String(format: folder.stringByAppendingPathComponent(nameBig as String))
    dataBig.writeToFile(newFileBig as String, atomically: true)
    newObj.setValue(newFileBig, forKey: "bigImage")
    }
    
    newObj.setValue(title, forKey: "title")
    newObj.setValue(newFile, forKey: "favicon")
    
    newObj.setValue(url, forKey: "url")
    
    newObj.setValue(dataColor, forKey: "color")
    let requeste : NSFetchRequest = NSFetchRequest(entityName: "Bookmarks")
    requeste.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: true)]
    let error : NSError? = nil
    let resultds : NSArray? = try! app.managedObjectContext.executeFetchRequest(requeste)
    let obj : NSManagedObject = resultds?.objectAtIndex(resultds!.count - 1) as! NSManagedObject
    let index : Float = obj.valueForKey("arrangeIndex") as! Float
    newObj.setValue(index + 1.0 , forKey: "arrangeIndex")
  
    app.saveContext()
    
    //println("Home Hit: \(getAllHomeHitArray())")
}

public func saveHitFirst(){
    let dict1 = NSMutableDictionary()
    dict1.setObject(UIImage(named: "facebook")!, forKey: "imageScreenShoot")
    dict1.setObject("Facebook", forKey: "title")
    dict1.setObject("http://www.facebook.com", forKey: "url")
    let dict2 = NSMutableDictionary()
    dict2.setObject(UIImage(named: "google")!, forKey: "imageScreenShoot")
    dict2.setObject("Google", forKey: "title")
    dict2.setObject("http://www.google.com", forKey: "url")
    let dict3 = NSMutableDictionary()
    dict3.setObject(UIImage(named: "youtube")!, forKey: "imageScreenShoot")
    dict3.setObject("YouTube", forKey: "title")
    dict3.setObject("http://www.youtube.com", forKey: "url")
    let dict4 = NSMutableDictionary()
    dict4.setObject(UIImage(named: "twitter")!, forKey: "imageScreenShoot")
    dict4.setObject("Twitter", forKey: "title")
    dict4.setObject("http://www.twitter.com", forKey: "url")
    let dict5 = NSMutableDictionary()
    dict5.setObject(UIImage(named: "wikipedia")!, forKey: "imageScreenShoot")
    dict5.setObject("Wikipedia", forKey: "title")
    dict5.setObject("http://www.wikipedia.com", forKey: "url")
    let dict = NSMutableDictionary()
    dict.setObject(UIImage(named: "yahoo")!, forKey: "imageScreenShoot")
    dict.setObject("Yahoo", forKey: "title")
    dict.setObject("http://www.yahoo.com", forKey: "url")
    let array = NSArray(objects:  dict2, dict3, dict4, dict5, dict, dict1)
    for dicts : AnyObject in array{
        let d = dicts as! NSMutableDictionary
        saveInFavorites(d)
    }
    
    }


public func saveInHistory(array : NSDictionary) {
    let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let request : NSFetchRequest = NSFetchRequest(entityName: "HistoryHit")
    
    
    request.returnsObjectsAsFaults = false
    let title : String = array.objectForKey("title") as! String
    let url : String = array.objectForKey("url") as! String
    let resultPredicate1 : NSPredicate = NSPredicate(format: "titleOfIt = %@", title)
    let resultPredicate2 : NSPredicate = NSPredicate(format: "urlOfIt = %@", url)
    
    let compound = NSCompoundPredicate(orPredicateWithSubpredicates: [resultPredicate1, resultPredicate2])
    request.predicate = compound
    let error : NSError? = nil
    let results : NSArray? = try! app.managedObjectContext.executeFetchRequest(request)
    if results?.count != 0 {
        for obj : AnyObject in results! {
            let newObj : HistoryHit = obj as! HistoryHit
           
            newObj.titleOfIt = title
            newObj.urlOfIt = url
            let datee : NSDate = NSDate()
            newObj.date = datee
            let datF = (UIApplication.sharedApplication().delegate as! AppDelegate).dateFormater2
            datF.dateFormat  = "dd-MM-yyyy"
            newObj.time = datF.stringFromDate(datee)
            
            newObj.arrangeIndex = CFAbsoluteTimeGetCurrent()
            
            app.saveContext()
            return
        }
    }
    var newFile = "empty"
    let i  = array.objectForKey("iconData") as? UIImage
    if i != nil{
    
    let data : NSData? = UIImagePNGRepresentation(imageWithImage(i!))
    let name : String = String(format: "%@.png", randomString(10))
    if data != nil {
        let folder : String = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
        if NSFileManager.defaultManager().fileExistsAtPath(folder) == false{
            let error : NSError? = nil
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(folder, withIntermediateDirectories: false, attributes: nil)
            } catch let error1 as NSError {
                
            }
            
        }
        newFile = String(format: (folder as NSString).stringByAppendingPathComponent(name))
        
        data!.writeToFile(newFile, atomically: true)
        }}
    let newObj = NSEntityDescription.insertNewObjectForEntityForName("HistoryHit", inManagedObjectContext: app.managedObjectContext) as! HistoryHit
    newObj.titleOfIt = title
    newObj.faviconPath = newFile
    newObj.urlOfIt = url
    let datee : NSDate = NSDate()
    newObj.date = datee
    let datF = (UIApplication.sharedApplication().delegate as! AppDelegate).dateFormater2
    datF.dateFormat  = "dd-MM-yyyy"
    newObj.time = datF.stringFromDate(datee)
    
    newObj.arrangeIndex = CFAbsoluteTimeGetCurrent()
    
    app.saveContext()
    // println("History : \(getAllHomeHitArray())")
}
public func getAllHomeHitArray() -> NSMutableArray? {
    let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let request : NSFetchRequest = NSFetchRequest(entityName: "HistoryHit")
    request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
    request.returnsObjectsAsFaults = false
    let error : NSError? = nil
    let array : NSArray? = try! app.managedObjectContext.executeFetchRequest(request)
    
    
    return array!.mutableCopy() as? NSMutableArray
}

public func imageWithImage(image:UIImage) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), false, 2.0);
    image.drawInRect(CGRectMake(5, 5, 20, 20))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}
public func tweet(url : NSURL){
    
    let tw = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
   /*
    let mainVC = (UIApplication.sharedApplication().delegate as! AppDelegate).mainVC
    tw.addURL(url)
    mainVC!.presentViewController(tw, animated: true, completion: { () -> Void in
        
    })*/
    
}
public func faceit(url : NSURL){
    
    let tw = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
    
    
   /* tw.addURL(url)
    let mainVC = (UIApplication.sharedApplication().delegate as! AppDelegate).mainVC
    mainVC!.presentViewController(tw, animated: true, completion: { () -> Void in

    })*/
    
    
}
func messege(url : NSURL){
   /* let mainVC = (UIApplication.sharedApplication().delegate as! AppDelegate).mainVC
    let mm = MFMessageComposeViewController()
   
    mm.messageComposeDelegate = mainVC
    
    mm.body = String(format: "\n %@", url.absoluteString)
    mainVC!.presentViewController(mm, animated: true, completion: { () -> Void in
        
    })

}
func mail(url : NSURL){
    let mainVC = (UIApplication.sharedApplication().delegate as! AppDelegate).mainVC
    let mm = MFMailComposeViewController()
    mm.mailComposeDelegate = mainVC!
    
    mm.setMessageBody(url.absoluteString, isHTML: false)
    mainVC!.presentViewController(mm, animated: true, completion: { () -> Void in
        
    })*/
    
    
}

