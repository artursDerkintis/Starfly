//
//  SFHistoryController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/10/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFHistoryController: UIViewController {
	var tableView : UITableView!
	var historyProvider : SFHistoryProvider!


	override func viewDidLoad() {
		super.viewDidLoad()
		
        historyProvider = SFHistoryProvider()
        tableView = UITableView(frame: .zero)
        historyProvider.tableView = tableView
        
        tableView.registerClass(SFHistoryCell.self, forCellReuseIdentifier: historyCell)
		tableView.registerClass(SFHistoryHeader.self, forHeaderFooterViewReuseIdentifier: historyHeader)

		tableView.backgroundColor = .clearColor()
		tableView.separatorColor = .clearColor()

		addSubviewSafe(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(768)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

    }

	func load() {
		historyProvider.loadData()
	}

	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func showDeleteActions(){
        let actionController = UIAlertController(title: "What to delete?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let actionHour = UIAlertAction(title: "Last Hour", style: UIAlertActionStyle.Default) { (k) -> Void in
            self.historyProvider.deleteLastHour()
        }
        let actionToday = UIAlertAction(title: "Today", style: UIAlertActionStyle.Default) { (k) -> Void in
            self.historyProvider.deleteToday()
        }
        let actionThisWeek = UIAlertAction(title: "This Week", style: UIAlertActionStyle.Default) { (k) -> Void in
            self.historyProvider.deleteThisWeek()
        }
        let actionAll = UIAlertAction(title: "Delete All", style: UIAlertActionStyle.Default) { (k) -> Void in
            self.historyProvider.deleteAll()
        }
        let actionDeep = UIAlertAction(title: "Delete Deeply", style: UIAlertActionStyle.Default) { (k) -> Void in
            self.historyProvider.deleteAllAndDeep()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (k) -> Void in
        }
        for action in [actionHour, actionToday, actionThisWeek, actionAll, actionDeep, actionCancel]{
            actionController.addAction(action)
        }
        
        presentViewController(actionController, animated: true, completion: nil)
    }
}
