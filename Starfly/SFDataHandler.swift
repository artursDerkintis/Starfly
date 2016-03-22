//
//  SFDataHandler.swift
//  Starfly
//
//  Created by Arturs Derkintis on 3/16/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import Foundation
import CoreData

class SFDataHandler: NSObject {
    
    class var sharedInstance: SFDataHandler {
        struct Singleton {
            static let instance = SFDataHandler()
        }
        return Singleton.instance
    }
    private override init(){}
    
    private func containsItemInHistory(item : Item) -> HistoryHit?{
        let request = NSFetchRequest(entityName: "HistoryHit")
        let predicate1 = NSPredicate(format: "titleOfIt == %@", item.title)
        let predicate2 = NSPredicate(format: "urlOfIt == %@", item.url)
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])
        do{
            let array = try SFDataHelper.sharedInstance.managedObjectContext.executeFetchRequest(request)
            return array.first as? HistoryHit
        }catch _{
            return nil
        }
    }
    
    func saveHistoryItem(item : Item){
        var historyItem = containsItemInHistory(item)
        if historyItem == nil{
            historyItem = NSEntityDescription.insertNewObjectForEntityForName("HistoryHit", inManagedObjectContext: SFDataHelper.sharedInstance.managedObjectContext) as? HistoryHit
        }
        historyItem?.setTimeAndDate()
        historyItem?.saveFavicon(item.favicon)
        historyItem?.titleOfIt = item.title
        historyItem?.urlOfIt = item.url
        SFDataHelper.sharedInstance.saveContext()
    }
    
    func saveBookmarkItem(item : Item){
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName("Bookmarks", inManagedObjectContext: SFDataHelper.sharedInstance.managedObjectContext) as! Bookmarks
        newEntity.setIndex()
        newEntity.saveFavicon(item.favicon)
        newEntity.title = item.title
        newEntity.url = item.url
        SFDataHelper.sharedInstance.saveContext()
    }
    
    func saveHomeItem(item : Item){
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName("HomeHit", inManagedObjectContext: SFDataHelper.sharedInstance.managedObjectContext) as! HomeHit
        newEntity.setIndex()
        newEntity.saveFavicon(item.favicon)
        if let screenshot = item.screenshot{
            newEntity.saveScreenshot(screenshot)
        }
        newEntity.title = item.title
        newEntity.url = item.url
        
        SFDataHelper.sharedInstance.saveContext()
    }
    
    func saveHitFirst(){
        let icon = UIImage(named: "g")!
        [Item(url: "http://www.facebook.com", title: "Facebook", favicon: icon, screenshot: UIImage(named: "facebook")),
            Item(url: "http://www.google.com", title: "Google", favicon: icon, screenshot: UIImage(named: "google")),
            Item(url: "http://www.youtube.com", title: "YouTube", favicon: icon, screenshot: UIImage(named: "youtube")),
            Item(url: "http://www.twitter.com", title: "Twitter", favicon: icon, screenshot: UIImage(named: "twitter")),
            Item(url: "http://www.wikipedia.com", title: "Wikipedia", favicon: icon, screenshot: UIImage(named: "wikipedia"))
            ].forEach { (item) -> () in
                self.saveHomeItem(item)
        }
    }
    

    
}
