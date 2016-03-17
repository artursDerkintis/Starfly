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

    var tableView : UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

	private var fetchController : NSFetchedResultsController?

	override init() {
		super.init()
		fetchController = NSFetchedResultsController(fetchRequest: simpleHistoryRequest, managedObjectContext: SFDataHelper.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchController?.delegate = self
	}

	func loadData() {
		do {
			try fetchController?.performFetch()
            tableView.reloadData()
		} catch _ {

		}
	}

    lazy var simpleHistoryRequest : NSFetchRequest = {
		let request = NSFetchRequest(entityName: "Bookmarks")
		request.sortDescriptors = [NSSortDescriptor(key: "arrangeIndex", ascending: false)]
		return request
	}()

	//MARK: NSFetchedResultsControllerDelegate
	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		dispatch_async(dispatch_get_main_queue(), {() -> Void in
				self.tableView?.beginUpdates()
			})
	}

	func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            if self.tableView != nil{
                delay(0.5, closure: { () -> () in
                    self.tableView?.endUpdates()
                })
            }
        })
	}

	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		dispatch_async(dispatch_get_main_queue(), {() -> Void in
				switch type {
				case .Insert:
                    self.tableView!.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Top)
					break
				case .Delete:
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

	func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
		let indexPath = self.tableView?.indexPathForCell(cell)
		if let hit = fetchController!.objectAtIndexPath(indexPath!) as? Bookmarks {
			SFDataHelper.sharedInstance.managedObjectContext.deleteObject(hit)
			SFDataHelper.sharedInstance.saveContext()
		}
	}

	func deleteImage(stringPath : NSString) {
        let iconFileName = stringPath.lastPathComponent
        let folder : NSString = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents/Books")
        let iconPath = folder.stringByAppendingPathComponent(iconFileName as String)
		do {
			try NSFileManager.defaultManager().removeItemAtPath(iconPath)
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
		cell.icon?.image = object.icon
		cell.leftUtilityButtons = deleteButton() as [AnyObject]
		cell.delegate = self
		return cell
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.fetchController!.sections?.count > 0{
           let sectionInfo = self.fetchController!.sections![section]
            return sectionInfo.numberOfObjects
            
        }else{return 0}
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 50
	}
	func configureExistingCell(indexPath: NSIndexPath) {
		if let hit = fetchController?.objectAtIndexPath(indexPath) as? Bookmarks {
			if let cell = self.tableView?.cellForRowAtIndexPath(indexPath) as? SFBookmarksCell {
				cell.icon?.image = hit.icon
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
			NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: object.getURL())
		}
	}

}
