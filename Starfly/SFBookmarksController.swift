//
//  SFBookmarksController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/12/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFBookmarksController: UIViewController {

	var tableView : UITableView!
	var bookmarksProvider : SFBookmarksProvider!


	override func viewDidLoad() {
		super.viewDidLoad()
		
		bookmarksProvider = SFBookmarksProvider()
		tableView = UITableView(frame: .zero)
		bookmarksProvider.tableView = tableView
        

		tableView.registerClass(SFBookmarksCell.self, forCellReuseIdentifier: bookmarksCell)

		tableView.backgroundColor = .clearColor()
		tableView.separatorColor = .clearColor()

		addSubviewSafe(tableView)

       
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.width.equalTo(768)
            make.bottom.equalTo(0)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func load() {
		bookmarksProvider.loadData()
	
	}

	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

}
