//
//  AppDelegate.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/13/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dateFormater : NSDateFormatter = NSDateFormatter()
    var dateFormater2 : NSDateFormatter = NSDateFormatter()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window?.backgroundColor = UIColor.lightGrayColor()
        
        
        
        if NSUserDefaults.standardUserDefaults().stringForKey("alreadyLauched") != nil{
            
        }else{
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "showT")
             NSUserDefaults.standardUserDefaults().setBool(true, forKey: "rest")
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "savePASS")
            NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "alreadyLauched")
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "pr")
            SFDataHandler.sharedInstance.saveHitFirst()
        }
        
        return true
    }
  
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        SFDataHelper.sharedInstance.saveContext()
    }
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if Fillr.sharedInstance().canHandleOpenURL(url){
            Fillr.sharedInstance().handleOpenURL(url)
            return true
        }else{
            UIApplication.sharedApplication().openURL(url)
        }
        return false
    }
}

