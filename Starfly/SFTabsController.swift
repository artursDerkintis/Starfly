//
//  SFTabsController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/6/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

protocol SFTabsControllerDelegate {
	func addTab()
	func addTabWithUrl(url : NSURL)
	func removeCurrentTab()
	func removeTabWithId(id: Double?)
	func selectTab(id: Double)
}


class SFTabsController: UIViewController, SFTabsControllerDelegate {

	var tabs = [SFTab]()
	var currentTab : SFTab? {
		didSet {
			if currentTab?.webViewController?.modeOfWeb == .home {
				tabContentDelegate?.bringHomeInFront()
			}
		}
	}

	var tabsView : SFTabsView?

	var addTabButton : SFButton?

	var tabContentDelegate : SFTabsContentDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		tabsView = SFTabsView(frame: .zero)
		addSubviewSafe(tabsView)
		tabsView?.snp_makeConstraints(closure: {(make) -> Void in
				make.top.bottom.left.equalTo(0)
				make.right.equalTo(-50)
			})
		addTabButton = SFButton(type: UIButtonType.Custom)
		addTabButton?.setImage(UIImage(named: Images.addTab), forState: UIControlState.Normal)
		addTabButton?.setImage(UIImage(named: Images.addTab)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
		addTabButton?.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		addTabButton?.layer.cornerRadius = 35 * 0.5
		addTabButton?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
		addTabButton?.layer.shadowOffset = CGSize(width: 0, height: 0)
		addTabButton?.layer.shadowRadius = 2
		addTabButton?.layer.shadowOpacity = 1.0
		addTabButton?.layer.rasterizationScale = UIScreen.mainScreen().scale
		addTabButton?.layer.shouldRasterize = true
		addSubviewSafe(addTabButton!)
		addTabButton?.snp_makeConstraints {(make) -> Void in
			make.width.height.equalTo(35)
			make.top.equalTo(5)
			make.right.equalTo(-5).priority(100)
		}
		addTabButton?.addTarget(self, action: "addTab", forControlEvents: .TouchDown)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "addTabNotification:", name: "AddTabURL", object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "goHome:", name: "HOME", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openURL:", name: "OPEN", object: nil)
        
        //Initatial tab
        delay(0.4) { () -> () in
            self.addTab()
        }
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	//MARK: Chrome functions
	func addTab() {
		let tab = SFTab(frame: .zero)
		tabContentDelegate?.addTab({(webViewController: SFWebController) -> Void in
				tab.webViewController = webViewController
				webViewController.openURL(nil)
				tab.setUpObservers()
			})
		tab.id = getId()
		tab.controllerDelegate = self
		tabs.append(tab)
		selectTab(tab.id)
		tabsView?.addNewTab(tab)
	}

	func addTabWithUrl(url : NSURL) {
		let tab = SFTab(frame: .zero)
		tab.id = getId()
		tab.controllerDelegate = self
		tabs.append(tab)
		selectTab(tab.id)
		tabsView?.addNewTab(tab)
		tabContentDelegate?.addTab({(webViewController: SFWebController) -> Void in
				tab.webViewController = webViewController
				webViewController.openURL(url)
			})
	}

	func removeCurrentTab() {
		if let currentTab = currentTab {
			tabsView?.removeTab(currentTab)
			currentTab.destroy()

			if let index = tabs.indexOf(currentTab) {
				tabs.removeAtIndex(index)
				if let tab = tabByIndex(index) {
					selectTab(tab.id)
				} else {
					addTab()
				}
			}
			tabsView?.removeTab(currentTab)
		}
	}

	func removeTabWithId(id: Double?) {
		if let id = id {
			if let tab = tabById(id) {
				tab.destroy()

				if let index = tabs.indexOf(tab) {
					tabs.removeAtIndex(index)
					if let tab = tabByIndex(index) {
						selectTab(tab.id)
					} else {
						addTab()
					}
				}
				tabsView?.removeTab(tab)
			}
		} else {
			removeCurrentTab()
		}
	}

	func selectTab(id: Double) {
		unselectAllTabs()
		if let tab = tabById(id) {
			tab.webViewController?.isCurrent = true
			tab.selected = true
			currentTab = tab
		}
	}

	func unselectAllTabs() {
		for tab in tabs {
			tab.webViewController?.isCurrent = false
			tab.selected = false
		}
	}

	//MARK: Finders
	func tabByIndex(index : Int) -> SFTab? {
		if tabs.count > index {
			return tabs[index]
		} else if tabs.count > 0 {
			return tabs[tabs.count - 1]
		} else {
			return nil
		}
	}

	func tabById(id : Double) -> SFTab? {
		for tab in tabs where tab.id == id {
			return tab
		}
		return nil
	}

	func getId() -> Double {
		var id : Double = 0
		for tab in tabs where id <= tab.id {
			id = tab.id + 1
		}
		return id
	}

	//MARK: Notifications handlers
	func addTabNotification(not : NSNotification) {
		addTabWithUrl(NSURL(string: not.object! as! String)!)
	}

	func goHome(not : NSNotification) {
		if let webViewController = not.object! as? SFWebController {
			if currentTab?.webViewController == webViewController {
				tabContentDelegate?.bringHomeInFront()
			}
		}
	}
    func openURL(not: NSNotification){
        if let urlString = not.object! as? String{
            if let URL = NSURL(string: parseUrl(urlString)!){
                currentTab?.webViewController?.openURL(URL)
                tabContentDelegate?.bringSFWebControllerInFront(currentTab!.webViewController!)
            }
        }
    }

}
