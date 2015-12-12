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

	var blur : UIVisualEffectView?

	var shadowView : UIView?

	var introView : SFView!
	let starImage = UIImageView(image: UIImage(named: "starbig"))

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

		bookmarksProvider = SFBookmarksProvider()
		tableView = UITableView(frame: .zero)
		bookmarksProvider.tableView = tableView
        
        tableView?.layer.cornerRadius = 20
        tableView?.layer.masksToBounds = true

		tableView.registerClass(SFBookmarksCell.self, forCellReuseIdentifier: bookmarksCell)

		tableView.backgroundColor = .clearColor()
		tableView.separatorColor = .clearColor()

		addSubviewSafe(tableView)

		introView = SFView(frame: CGRect.zero)
		introView.layer.zPosition = 500

		introView.addSubview(starImage)
        
        addSubviewSafe(introView)
        
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
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
		blur!.snp_makeConstraints {(make) -> Void in
			make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func load() {
		bookmarksProvider.loadData()
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

}
