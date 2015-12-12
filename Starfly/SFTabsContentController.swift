//
//  SFTabsContentController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/8/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

protocol SFTabsContentDelegate {
	func addTab(completion: (webViewController : SFWebController) -> Void)
	//    func removeTab(webViewController : SFWebController)
	func selectTab(webViewController : SFWebController)
	func bringHomeInFront()
    func bringSFWebControllerInFront(webViewController : SFWebController)
}


class SFTabsContentController: UIViewController, SFTabsContentDelegate {

	var home = SFHomeController()

	override func viewDidLoad() {
		super.viewDidLoad()
		addSubviewSafe(home.view)
		home.view.snp_makeConstraints {(make) -> Void in
			make.top.right.left.bottom.equalTo(0)
		}
	}
	func bringHomeInFront() {
		self.view.bringSubviewToFront(home.view)
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func addTab(completion: (webViewController: SFWebController) -> Void) {
		let webViewController = SFWebController()
		self.addSubviewSafe(webViewController.view)
		webViewController.view.snp_makeConstraints {(make) -> Void in
			make.top.right.left.bottom.equalTo(0)
		}
		completion(webViewController: webViewController)

	}
    func bringSFWebControllerInFront(webViewController: SFWebController) {
        self.view.bringSubviewToFront(webViewController.view)
    }


	func selectTab(webViewController: SFWebController) {
		self.view.bringSubviewToFront(webViewController.view)
	}

}
