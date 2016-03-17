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
    
    func saveHistoryItem(item : Item){
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName("HistoryHit", inManagedObjectContext: SFDataHelper.sharedInstance.managedObjectContext) as! HistoryHit
        newEntity.setTimeAndDate()
        newEntity.saveFavicon(item.favicon)
        newEntity.titleOfIt = item.title
        newEntity.urlOfIt = item.url
    }
    
    func saveBookmarkItem(item : Item){
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName("Bookmarks", inManagedObjectContext: SFDataHelper.sharedInstance.managedObjectContext) as! Bookmarks
        newEntity.setIndex()
        newEntity.saveFavicon(item.favicon)
        newEntity.title = item.title
        newEntity.url = item.url
    }
    
    func saveHomeItem(item : Item){
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName("HomeHit", inManagedObjectContext: SFDataHelper.sharedInstance.managedObjectContext) as! HomeHit
        newEntity.setIndex()
        newEntity.saveFavicon(item.favicon)
        newEntity.title = item.title
        newEntity.url = item.url
    }
    
}
