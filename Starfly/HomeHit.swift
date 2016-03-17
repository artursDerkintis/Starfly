//
//  HomeHit.swift
//  Starfly
//
//  Created by Arturs Derkintis on 3/16/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import Foundation
import CoreData

@objc(HomeHit)
class HomeHit: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    lazy var screenshot : UIImage? = {
        if let fav = self.bigImage{
            let iconFileName = (fav as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
            let iconPath = folder.stringByAppendingPathComponent(iconFileName as String)
            if let icon = UIImage(contentsOfFile: iconPath) {
                return icon
            }
        }
        return nil
    }()
    
    func setIndex(){
        self.arrangeIndex = CFAbsoluteTimeGetCurrent()
    }
    
    func getURL() -> NSURL{
        if let url = self.url{
            return NSURL(string: url)!
        }
        return NSURL(string: "http://about:blank")!
    }
    
    func saveFavicon(image : UIImage){
        if let data = UIImagePNGRepresentation(image){
            let name : String = String(format: "%@.png", randomString(11))
            let folder : String = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
            if NSFileManager.defaultManager().fileExistsAtPath(folder) == false{
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(folder, withIntermediateDirectories: false, attributes: nil)
                } catch _ {}
            }
            let newFilePath = String(format: (folder as NSString).stringByAppendingPathComponent(name))
            data.writeToFile(newFilePath, atomically: true)
            self.favicon = newFilePath
        }
    }
    
    func saveScreenshot(image : UIImage){
        if let data = UIImagePNGRepresentation(image){
            let name : String = String(format: "%@.png", randomString(10))
            let folder : String = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
            if NSFileManager.defaultManager().fileExistsAtPath(folder) == false{
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(folder, withIntermediateDirectories: false, attributes: nil)
                } catch _ {}
            }
            let newFilePath = String(format: (folder as NSString).stringByAppendingPathComponent(name))
            data.writeToFile(newFilePath, atomically: true)
            self.bigImage = newFilePath
        }
    }
    
    func removeIconsAndScreeshot(){
        if let fav = self.favicon{
            let stsAr : NSString? = (fav as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
            let path = folder.stringByAppendingPathComponent(stsAr! as String)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        if let fav = self.bigImage{
            let stsAr : NSString? = (fav as NSString).lastPathComponent
            let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/HomeHit")
            let path = folder.stringByAppendingPathComponent(stsAr! as String)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
}
