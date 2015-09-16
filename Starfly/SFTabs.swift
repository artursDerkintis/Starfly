//
//  Tabs.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/14/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
protocol SFCloseTab{
    func closeTab(tab : SFTab)
}
class SFTabs: UIViewController, SFCloseTab {
    var tabs = [SFTab]()
    var scroller : SFScrollView?
    var currentTab : SFTab?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller = SFScrollView(frame: view.bounds)
        scroller?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        scroller?.addTarget(self)
        
        view.addSubview(scroller!)
        
    }
    func addNewTab(){
        
        addTab(true)
    }
    func closeTab(tab : SFTab){
        if tabs.count > 1{
            let ind = tabs.indexOf(tab)
            print(ind)
            let nextTab = max(ind! - 1, 0)
            self.updateAllTabs()
            self.tabs[nextTab].selected = true
            delay(0.1, closure: { () -> () in
                self.tabs.removeAtIndex(ind!)
                self.scroller?.cells.removeAtIndex(self.scroller!.cells.indexOf(tab)!)
                tab.removeFromSuperview()
                self.scroller?.updateEverything()
            })
            
            }
            
        
    }
    func updateAllTabs(){
        for tab in tabs{
            tab.selected = false
        }
    }
    func addTab(foreground : Bool){
        let newTab = SFTab(frame: CGRect(x: 0, y: 50, width: 200, height: self.view.frame.height * 0.8))
        let tap = UITapGestureRecognizer(target: self, action: "selectTab:")
        newTab.addGestureRecognizer(tap)
        newTab.delegate = self
        updateAllTabs()
        newTab.selected = foreground
        scroller?.addCell(newTab)
        tabs.append(newTab)
        currentTab = newTab
    }
    func selectTab(sender : UITapGestureRecognizer){
        if sender.view!.isKindOfClass(SFTab) && (sender.view as! SFTab) != currentTab{
            updateAllTabs()
            currentTab = (sender.view as! SFTab)
            (sender.view as! SFTab).selected = true
        }
    }
    
}
