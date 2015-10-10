//
//  BooksHomeChecker.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/27/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import CoreData

public func storeAllURLs(){
    let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
    let homeRequest = NSFetchRequest(entityName: "HomeHit")
    let homeHit = try! app.managedObjectContext.executeFetchRequest(homeRequest)
    let bookmarksRequest = NSFetchRequest(entityName: "Bookmarks")
    let bookmarks = try! app.managedObjectContext.executeFetchRequest(bookmarksRequest)
    var urls = [String]()
    for home in homeHit{
        urls.append(home.valueForKey("url") as! String)
    }
    for book in bookmarks{
        urls.append(book.valueForKey("url") as! String)
    }
    for url in urls{
        let newObj = NSEntityDescription.insertNewObjectForEntityForName("BooksHomeList", inManagedObjectContext: app.managedObjectContext)
        newObj.setValue(url, forKey: "url")
        
        app.saveContext()
    }
    
}

func containsURL(urlToCheck : String, contains : SFContains){
    var containsBool = false
    let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
    let listRequest = NSFetchRequest(entityName: "BooksHomeList")
    let list = try! app.managedObjectContext.executeFetchRequest(listRequest)
    for listItem in list{
        let url = listItem.valueForKey("url") as! String
        if urlToCheck == url{
            containsBool = true
        }
    }
    contains(containsBool)
}