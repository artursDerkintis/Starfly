//
//  HistoryHit.swift
//  Starfly
//
//  Created by Arturs Derkintis on 3/16/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import Foundation
import CoreData

@objc(HistoryHit)
class HistoryHit: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    var primitiveSectionIdentifier: String?
    var primitiveSectionId : String?
    var sectionId: String{
        get {
            return self.time!
        }
        set {
            self.willChangeValueForKey("sectionID")
            self.time = newValue
            self.didChangeValueForKey("sectionID")
            self.primitiveSectionIdentifier = nil
        }
    }
    
    
    func setTimeAndDate(){
        self.time = DateFormatter.sharedInstance.readableDate(NSDate())
        self.arrangeIndex = CFAbsoluteTimeGetCurrent()
    }
    
    func getURL() -> NSURL{
        if let url = self.urlOfIt{
            return NSURL(string: url)!
        }
        return NSURL(string: "http://about:blank")!
    }
    
    lazy var icon : UIImage? = {
        if let fav = self.faviconPath{
            let iconFileName = (fav as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
            let iconPath = folder.stringByAppendingPathComponent(iconFileName as String)
            if let icon = UIImage(contentsOfFile: iconPath) {
                return icon
            }
        }
        return nil
    }()
    

    
    func removeIcon(){
        if let fav = self.faviconPath{
            let stsAr : NSString? = (fav as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
            let path = folder.stringByAppendingPathComponent(stsAr! as String)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveFavicon(image : UIImage){
        if let data = UIImagePNGRepresentation(image){
            let name : String = String(format: "%@.png", randomString(10))
            let folder : String = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HistoryHit")
            if NSFileManager.defaultManager().fileExistsAtPath(folder) == false{
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(folder, withIntermediateDirectories: false, attributes: nil)
                } catch _ {}
            }
            let newFilePath = String(format: (folder as NSString).stringByAppendingPathComponent(name))
            data.writeToFile(newFilePath, atomically: true)
            self.faviconPath = newFilePath
        }
    }
    
    
}
