//
//  Tabs.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/14/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
protocol SFTabDelegate{
    func closeTab(tab : SFTab)
    func addNewTabWithURL(url : NSURL)
}
class SFTabs: UIViewController, SFTabDelegate {
    var tabs = [SFTab]()
    var scroller : SFCardTabs?
    var currentTab : SFTab?
    var tabManagment : SFTabManagment?
    var urlBarManagment : SFUrlBarManagment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller = SFCardTabs(frame: view.bounds)
        scroller?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        scroller?.addTarget(self)
        
        view.addSubview(scroller!)
        delay(0.1) { () -> () in
            
        
        if NSUserDefaults.standardUserDefaults().boolForKey("rest"){
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveTabsForRecovery", name: "recover", object: nil)
            if NSUserDefaults.standardUserDefaults().objectForKey("tabsInMemory") != nil{
                let array = NSUserDefaults.standardUserDefaults().objectForKey("tabsInMemory") as! NSMutableArray
                for item in array{
                    self.addNewTabWithURL(NSURL(string: item as! String)!)
                }
                
            }else{
                self.addNewTab()
            }
        }else{
            self.addNewTab()
            }
        }
    }
    
    func saveTabsForRecovery(){
        if NSUserDefaults.standardUserDefaults().boolForKey("rest"){
            let array = NSMutableArray()
            for tab in tabs{
                if tab.webVC!.webView!.URL != nil && tab.webVC!.modeOfWeb == .web{
                    array.addObject(tab.webVC!.webView!.URL!.absoluteString)
                }
            }
            if array.count != 0{
                NSUserDefaults.standardUserDefaults().setObject(array, forKey: "tabsInMemory")
            }else{
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "tabsInMemory")
            }
        }

    }
    
    func addNewTab(){
        tabManagment?.addNewTab({ (webVC : SFWebVC) -> Void in
            webVC.openURL(nil)
            self.addTab(true, webVC: webVC)
            self.urlBarManagment?.setWebVC(webVC)
        })
        
    }
    
    func addNewTabWithURL(url : NSURL){
        tabManagment?.addNewTab({ (webVC : SFWebVC) -> Void in
            webVC.openURL(url)
            self.addTab(true, webVC: webVC)
            self.urlBarManagment?.setWebVC(webVC)
        })
    }
    
    func closeTab(tab : SFTab){
        
            let ind = tabs.indexOf(tab)
            print(ind)
            let nextTab = max(ind! - 1, 0)
            self.updateAllTabs()
        
        
            delay(0.1, closure: { () -> () in
                self.tabs.removeAtIndex(ind!)
                 self.tabManagment?.removeTab(tab.webVC!)
                self.scroller?.cells.removeAtIndex(self.scroller!.cells.indexOf(tab)!)
                tab.removeFromSuperview()
                self.scroller?.updateEverything()
                if NSUserDefaults.standardUserDefaults().boolForKey("rest"){
                    NSNotificationCenter.defaultCenter().postNotificationName("recover", object: nil)
                }

                if self.tabs.count == 0{
                    self.addNewTab()
                }else{
                    let tab = self.tabs[nextTab]
                    
                    tab.selected = true
                    self.urlBarManagment?.setWebVC(tab.webVC!)
                    self.tabManagment?.switchToTab(tab.webVC!)
                        
                
                    
                }
            })
        
            
        
    }
    
    func updateAllTabs(){
        for tab in tabs{
            tab.selected = false
            tab.webVC?.isCurrent = false
        }
    }
    
    func addTab(foreground : Bool, webVC : SFWebVC){
        let newTab = SFTab(frame: CGRect(x: 0, y: -50, width: 200, height: self.view.frame.height * 0.8))
        newTab.webVC = webVC
        newTab.setUpObservers()
        let tap = UITapGestureRecognizer(target: self, action: "selectTab:")
        newTab.addGestureRecognizer(tap)
        newTab.delegate = self
        updateAllTabs()
        newTab.selected = foreground
        scroller?.addCell(newTab)
        tabs.append(newTab)
        currentTab = newTab
        self.urlBarManagment?.setWebVC(webVC)
    }
    
    func selectTab(sender : UITapGestureRecognizer){
        if sender.view!.isKindOfClass(SFTab) && (sender.view as! SFTab) != currentTab{
            updateAllTabs()
            self.tabManagment?.switchToTab((sender.view as! SFTab).webVC!)
            self.urlBarManagment?.setWebVC((sender.view as! SFTab).webVC!)
            currentTab = (sender.view as! SFTab)
            (sender.view as! SFTab).selected = true
        }
    }
    
}
