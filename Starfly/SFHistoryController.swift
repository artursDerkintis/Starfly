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

	var blur : UIVisualEffectView?

	var shadowView : UIView?

	var introView : SFView!
	let starImage = UIImageView(image: UIImage(named: "history"))

	override func viewDidLoad() {
		super.viewDidLoad()
		blur = UIVisualEffectView(frame: .zero)
		blur?.layer.cornerRadius = 20
		blur?.layer.masksToBounds = true
		blur?.effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
		blur!.autoresizingMask = UIViewAutoresizing.FlexibleWidth


		shadowView = UIView(frame: CGRect.zero)


		shadowView?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
		shadowView?.layer.shadowOffset = CGSize(width: 0, height: 0)
		shadowView?.layer.shadowRadius = 2
		shadowView?.layer.shadowPath = UIBezierPath(roundedRect: shadowView!.bounds, cornerRadius: 20).CGPath
		shadowView?.layer.shadowOpacity = 1.0
		shadowView?.layer.shouldRasterize = true
		shadowView?.layer.rasterizationScale = UIScreen.mainScreen().scale

		addSubviewSafe(shadowView!)
		addSubviewSafe(blur!)

        historyProvider = SFHistoryProvider()
        tableView = UITableView(frame: .zero)
        historyProvider.tableView = tableView
        
        tableView?.layer.cornerRadius = 20
        tableView?.layer.masksToBounds = true
        
        tableView.registerClass(SFHistoryCell.self, forCellReuseIdentifier: historyCell)
		tableView.registerClass(SFHistoryHeader.self, forHeaderFooterViewReuseIdentifier: historyHeader)

		tableView.backgroundColor = .clearColor()
		tableView.separatorColor = .clearColor()

		addSubviewSafe(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }

		introView = SFView(frame: CGRect.zero)
		introView.layer.zPosition = 500
        addSubviewSafe(introView)
        
		introView.addSubview(starImage)
        
		introView.snp_makeConstraints {(make) -> Void in
			make.top.right.bottom.left.equalTo(0)
		}
		starImage.snp_makeConstraints {(make) -> Void in
			make.center.equalTo(introView!)
			make.height.width.equalTo(100)
		}
       
		shadowView?.snp_makeConstraints {(make) -> Void in
			make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
		}
		blur!.snp_makeConstraints {(make) -> Void in
			make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
		}
	}

	func load() {
		historyProvider.loadData()
		delay(0.1, closure: {() -> () in
				UIView.animateWithDuration(0.5, animations: {() -> Void in
						self.introView?.alpha = 0.0
						self.starImage.transform = CGAffineTransformMakeScale(0.01, 0.01)
					}, completion: {(m) -> Void in
						self.introView?.hidden = true
						self.introView?.alpha = 1.0
						self.starImage.transform = CGAffineTransformIdentity
					})
			})
	}

	func updateFrames(edge : UIEdgeInsets) {
		tableView?.snp_updateConstraints {(make) -> Void in
			make.edges.equalTo(edge)
		}
		shadowView?.snp_updateConstraints {(make) -> Void in
			make.edges.equalTo(edge)
		}
		blur?.snp_updateConstraints {(make) -> Void in
			make.edges.equalTo(edge)
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		shadowView?.layer.shadowPath = UIBezierPath(roundedRect: shadowView!.bounds, cornerRadius: 20).CGPath
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
