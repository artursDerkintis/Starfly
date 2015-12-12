//
//  SFBookmarksProvider.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/12/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import CoreData

let bookmarksCell = "bookmarksCell"

class SFBookmarksProvider: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, SWTableViewCellDelegate {

	var tableView : UITableView!

	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

	private var fetchController : NSFetchedResultsController?

	var iconDictionary = NSMutableDictionary()

	var request : NSFetchRequest!
	override init() {
		super.init()
		request = simpleHistoryRequest()
		cacheIcons(request)
		fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchController?.delegate = self
	}

	func loadData() {
		do {
			try fetchController?.performFetch()
            tableView.reloadData()
		} catch _ {

		}
	}

	func simpleHistoryRequest() -> NSFetchRequest {
		let request = NSFetchRequest(entityName: "Bookmarks")
		request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
		return request
	}

	func cacheIcons(request : NSFetchRequest) {
		do {
			if let hits = try appDelegate.managedObjectContext.executeFetchRequest(request) as? [Bookmarks] {
				for hit in hits {
					let iconFileName = (hit.favicon as NSString).lastPathComponent
                    let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
					let iconPath = folder.stringByAppendingPathComponent(iconFileName as String)
					if let icon = UIImage(contentsOfFile: iconPath) {
						iconDictionary.setObject(icon, forKey: hit.favicon)
					}
				}
			}
		} catch _ {

		}
	}

	//MARK: NSFetchedResultsControllerDelegate
	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		dispatch_async(dispatch_get_main_queue(), {() -> Void in
				self.tableView?.beginUpdates()
			})
	}

	func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            if self.tableView != nil{
                self.tableView?.endUpdates()
                
            }
        })
	}

	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		dispatch_async(dispatch_get_main_queue(), {() -> Void in
				switch type {
				case .Insert:
					if let hit = anObject as? Bookmarks {
						let iconFileName = (hit.favicon as NSString).lastPathComponent
						let folder = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
						let iconPath = folder.stringByAppendingString(iconFileName as String)
						if let icon = UIImage(contentsOfFile: iconPath) {
							self.iconDictionary.setObject(icon, forKey: hit.favicon)
						}
					}
					break
				case .Delete:
					if let hit = anObject as? Bookmarks {
						self.deleteImage(hit.favicon)
					}
					self.tableView?.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
					break
				case .Move:
					self.tableView?.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
					break
				case .Update:
					self.configureExistingCell(indexPath!)
					break
				}
			})
	}

	func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
		dispatch_async(dispatch_get_main_queue(), {() -> Void in
				switch type {
				case .Insert:
					self.tableView!.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
					break
				case .Delete:
					self.tableView!.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
					break
				default:
					return
				}
			})
	}

	//MARK: SWTableViewDelegate
	func deleteButton() -> NSArray {
		let mutableArray = NSMutableArray()
		mutableArray.sw_addUtilityButtonWithColor(.redColor(), title: "Delete")
		return mutableArray.mutableCopy() as! NSArray
	}

	func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
		let indexPath = self.tableView?.indexPathForCell(cell)
		if let hit = fetchController!.objectAtIndexPath(indexPath!) as? Bookmarks {
			deleteImage(hit.favicon)
			appDelegate.managedObjectContext.deleteObject(hit)
			appDelegate.saveContext()
		}
	}

	func deleteImage(stringPath : NSString) {
		let stsAr : NSString? = stringPath.lastPathComponent
		let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
		let path = folder.stringByAppendingPathComponent(stsAr! as String)

		do {
			try NSFileManager.defaultManager().removeItemAtPath(path)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}

	//MARK: UITableViewDataSource
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(bookmarksCell, forIndexPath: indexPath) as! SFBookmarksCell
		let object = fetchController?.objectAtIndexPath(indexPath) as! Bookmarks
		cell.titleLabel?.text = object.title
		cell.urlLabel?.text = object.url
		cell.icon?.image = iconDictionary.objectForKey(object.favicon) as? UIImage
		cell.rightUtilityButtons = deleteButton() as [AnyObject]
		cell.delegate = self
		return cell
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchController!.sections![section] as NSFetchedResultsSectionInfo
		return sectionInfo.numberOfObjects
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 50
	}
	func configureExistingCell(indexPath: NSIndexPath) {
		if let hit = fetchController?.objectAtIndexPath(indexPath) as? Bookmarks {
			if let cell = self.tableView?.cellForRowAtIndexPath(indexPath) as? SFBookmarksCell {
				cell.icon?.image = iconDictionary.objectForKey(hit.favicon) as? UIImage
				cell.urlLabel?.text = hit.url
				cell.titleLabel?.text = hit.title
			} else {
				self.tableView?.reloadData()
			}
		}
	}

	//MARK: UITableViewDelagate
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		if let object = fetchController?.objectAtIndexPath(indexPath) as? Bookmarks {
			NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: object.url)
		}
	}

}
