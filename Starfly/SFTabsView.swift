//
//  SFTabsView.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/6/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFTabsView: UIView, UIGestureRecognizerDelegate {

	var tabs = [SFTab]()
	var width : CGFloat = 200

	var scrollView : UIScrollView?

	var placeHolderImageView : UIImageView!

	var panGesture : UIPanGestureRecognizer?
	var originX : CGFloat = 0

	var movingTab : SFTab?

	override init(frame: CGRect) {
		super.init(frame: frame)
		scrollView = UIScrollView(frame: .zero)
		scrollView?.bounces = false
		scrollView?.showsHorizontalScrollIndicator = false

		scrollView?.clipsToBounds = false
		scrollView?.layer.masksToBounds = false
		clipsToBounds = false
		layer.masksToBounds = false


		panGesture = UIPanGestureRecognizer(target: self, action: "panGesture:")
		panGesture?.delegate = self
		scrollView?.addGestureRecognizer(panGesture!)

		addSubviewSafe(scrollView)
		scrollView?.snp_makeConstraints(closure: {(make) -> Void in
				make.top.left.right.bottom.equalTo(0)
			})
		placeHolderImageView = UIImageView(frame: .zero)
		scrollView?.addSubviewSafe(placeHolderImageView)
	}

	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}


	func panGesture(sender : UIPanGestureRecognizer) {
		let touchPosition = sender.translationInView(sender.view)
		let translationPoint = CGPoint(x: originX + touchPosition.x, y: placeHolderImageView.center.y)
		switch sender.state {
		case .Began:
			let tp = sender.locationInView(sender.view)
			if let tab = getTabAtPoint(tp) where tab.selected == true {
				movingTab = tab
				let image = snapImageOfTab(tab)
				tab.hidden = true
				placeHolderImageView.frame.size = tab.frame.size
				placeHolderImageView.layer.cornerRadius = tab.frame.height * 0.5
				placeHolderImageView.layer.masksToBounds = true
				placeHolderImageView.center = CGPoint(x: tab.center.x, y: tab.center.y)
				originX = tab.center.x
				placeHolderImageView.image = image
				scrollView?.bringSubviewToFront(placeHolderImageView)
				UIView.animateWithDuration(0.3, animations: {() -> Void in
						self.placeHolderImageView.transform = CGAffineTransformMakeScale(1.05, 1.05)
					})
				scrollView?.scrollEnabled = false
			} else {
				panGesture?.enabled = false
				panGesture?.enabled = true
			}

			break
		case .Changed:

			placeHolderImageView.center = translationPoint
			moveTab()
			break
		case .Ended:
			UIView.animateWithDuration(0.4, animations: {() -> Void in
					self.placeHolderImageView.transform = CGAffineTransformMakeScale(0.99, 0.99)
					self.placeHolderImageView.center = self.movingTab!.center
				}, completion: {(fin) -> Void in
					self.movingTab?.hidden = false
					self.scrollView?.scrollEnabled = true
					self.placeHolderImageView.image = nil
					self.placeHolderImageView.frame.size = .zero
					self.placeHolderImageView.center = .zero
				})

			break
		default:
			break
		}

	}
	func moveTab() {
		if let replacebleTab = getTabAtPoint(placeHolderImageView.center) where replacebleTab != movingTab {
			swap(&tabs[tabs.indexOf(replacebleTab)!], &tabs[tabs.indexOf(movingTab!)!])
			let splitWidth = getWidth()
			for var i = 0; i < tabs.count; ++i {

				UIView.animateWithDuration(0.3, animations: {() -> Void in
						self.tabs[i].frame = CGRect(x: CGFloat(i) * (splitWidth + 5), y: 5, width: splitWidth, height: 35)
					})

			}
		}
	}
	func addNewTab(tab: SFTab) {
		tabs.append(tab)
		scrollView?.addSubviewSafe(tab)
		let splitWidth = getWidth()
		tab.frame = CGRect(x: (splitWidth + 5) * CGFloat(tabs.count - 2), y: 5, width: splitWidth, height: 35)

		placeAllTabs()
	}

	func removeTab(tab : SFTab) {
		tabs.removeAtIndex(tabs.indexOf(tab)!)
		placeAllTabs()
	}

	func placeAllTabs() {
		let splitWidth = self.getWidth()
		for var i = 0; i < self.tabs.count; ++i {

			UIView.animateWithDuration(0.3, animations: {() -> Void in
					self.tabs[i].frame = CGRect(x: CGFloat(i) * (splitWidth + 5), y: 5, width: splitWidth, height: 35)
				})

		}
		var x : CGFloat = 0.0
		for subview in self.scrollView!.subviews {
			if x < CGRectGetMaxX(subview.frame) {
				x = CGRectGetMaxX(subview.frame)
			}
		}
		self.scrollView!.contentSize = CGSize(width: x, height: 0)
		let maxXOfCurrentTab = CGRectGetMaxX(self.getCurrentTab().frame)
		if maxXOfCurrentTab >= self.scrollView!.bounds.size.width {
			print("\(scrollView!.contentOffset.x + self.scrollView!.bounds.size.width) \(maxXOfCurrentTab)")
			if scrollView!.contentOffset.x + self.scrollView!.bounds.size.width < maxXOfCurrentTab {
				let leftOffset = CGPointMake(maxXOfCurrentTab - self.scrollView!.bounds.size.width, 0)
				UIView.animateWithDuration(0.3, animations: {() -> Void in
						self.scrollView?.contentOffset = leftOffset
					})
			}
		}


	}

	func getCurrentTab() -> SFTab {
		for tab in tabs where tab.selected == true {
			return tab
		}
		return self.tabs.last!
	}

	func getTabAtPoint(point : CGPoint) -> SFTab? {
		for tab in tabs {
			if CGRectContainsPoint(tab.frame, point) {
				return tab
			}
		}
		return nil
	}

	func snapImageOfTab(tab : SFTab) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(tab.frame.size, false, 2.0)
		tab.drawViewHierarchyInRect(tab.bounds, afterScreenUpdates: false)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}

	func getWidth() -> CGFloat {
		if frame.width * 0.5 < width {width = frame.width * 0.5}
		return width
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
