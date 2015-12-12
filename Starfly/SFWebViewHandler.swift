//
//  SFWebViewHandler.swift
//  Starfly
//
//  Created by Arturs Derkintis on 11/21/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import WebKit

class SFWebViewHandler: NSObject {
	var webView : WKWebView?
	convenience init(webView : WKWebView) {
		self.init()
		self.webView = webView
	}

	func saveHistory(favicon : UIImage?) {
		if NSUserDefaults.standardUserDefaults().boolForKey("pr") == false {
			let dictionary = NSMutableDictionary()
			if webView!.URL?.absoluteString != "about:blank" && webView!.title != nil && !webView!.URL!.absoluteString.containsString("file:///") {
				dictionary.setObject(webView!.title!, forKey: "title")
				dictionary.setObject(webView!.URL!.absoluteString, forKey: "url")
				if favicon == nil {
					dictionary.setObject(UIImage(named: "g")!, forKey: "iconData")
				} else {
					dictionary.setObject(favicon!, forKey: "iconData")
				}
				saveInHistory(dictionary)
			}
		}
	}

	func tryToInjectPasword() {
		if NSUserDefaults.standardUserDefaults().boolForKey("savePASS") {
			let dictionary = NSUserDefaults.standardUserDefaults().objectForKey("PASSWORDS") as? NSMutableDictionary

			if dictionary != nil {

				if (dictionary?.valueForKey(shortURL(self.webView!.URL!) as String) != nil) {
					let dictg = dictionary?.valueForKey(shortURL(self.webView!.URL!) as String) as! NSMutableDictionary
					let user = dictg.valueForKey("USERNAME") as? String
					let password = dictg.valueForKey("PASSWORD") as? String
					if user != nil && password != nil {
						let string = String(format: "injectPassword(\"%@\",\"%@\");", user!, password!)
						self.webView!.evaluateJavaScript(string, completionHandler: {(string, error : NSError?) -> Void in
								print("DONE OR \(string)")
							})
					}
				}
			}}

	}

	func lookForPaswordAndSaveIt() {
		self.webView!.evaluateJavaScript("savePassword();", completionHandler: {(string, error : NSError?) -> Void in
				if string != nil {
					let result = string as! NSString
					let tags = result.componentsSeparatedByString("|&|")
					let dict = self.makeDictionaryOfPass(tags as [NSString])


					let userName = dict.valueForKey("USERNAME") as? NSString
					let passWord = dict.valueForKey("PASSWORD") as? NSString
					if userName != nil && passWord != nil {
						print("USER \(userName), PASS \(passWord)")
						let strinf = shortURL(self.webView!.URL!)
						let dicte = NSUserDefaults.standardUserDefaults().objectForKey("PASSWORDS") as? NSMutableDictionary
						if dicte != nil {
							if dicte?.valueForKey(strinf as String) != nil {
								let dictg = dicte?.valueForKey(strinf as String) as! NSMutableDictionary
								if dictg.valueForKey("USERNAME") as? String == userName && dictg.valueForKey("PASSWORD") as? String == passWord {

								} else if dictg.valueForKey("USERNAME") as? String != userName || dictg.valueForKey("PASSWORD") as? String != passWord {
									self.updatePassword(dict, strinf: strinf as String)
								}
							} else {
								self.savePassword(dict, strinf: strinf as String)
							}
						} else {
							self.savePassword(dict, strinf: strinf as String)
						}}
				}
			})

	}

	func savePassword(dict : NSMutableDictionary, strinf : String) {
		let alert = UIAlertController(title: "Save password", message: "Do you want to save password for \(strinf)?", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Cancel, handler: {(Action) -> Void in
					let dicte : NSMutableDictionary? = (NSUserDefaults.standardUserDefaults().objectForKey("PASSWORDS") as? NSMutableDictionary)?.mutableCopy() as? NSMutableDictionary
					if dicte != nil {

						dicte!.setObject(dict, forKey: strinf)
						NSUserDefaults.standardUserDefaults().setObject(dicte, forKey: "PASSWORDS")
					} else {
						let dictes = NSMutableDictionary()
						dictes.setObject(dict, forKey: strinf)
						NSUserDefaults.standardUserDefaults().setObject(dictes, forKey: "PASSWORDS")
					}

				}))
		alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {(Action) -> Void in

				}))

		self.webView!.firstViewController()!.presentViewController(alert, animated: true, completion: nil)

	}

	func updatePassword(dict : NSMutableDictionary, strinf : String) {
		let alert = UIAlertController(title: "Update password", message: "Do you want to update password for \(strinf)?", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.Cancel, handler: {(Action) -> Void in
					let dicte : NSMutableDictionary? = (NSUserDefaults.standardUserDefaults().objectForKey("PASSWORDS") as? NSMutableDictionary)!.mutableCopy() as? NSMutableDictionary
					if dicte != nil {

						dicte!.setValue(dict, forKey: strinf)
						NSUserDefaults.standardUserDefaults().setObject(dicte, forKey: "PASSWORDS")
					} else {
						let dictes = NSMutableDictionary()
						dicte!.setValue(dict, forKey: strinf)
						NSUserDefaults.standardUserDefaults().setObject(dictes, forKey: "PASSWORDS")
					}

				}))
		alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {(Action) -> Void in

				}))

		self.webView!.firstViewController()!.presentViewController(alert, animated: true, completion: nil)

	}

	func makeDictionaryOfPass(tags : [NSString]) -> NSMutableDictionary {
		let dict = NSMutableDictionary(capacity: 2)
		for tag : NSString in tags as [NSString] {
			let start = tag.rangeOfString("[")
			let end = tag.rangeOfString("]")
			if start.location != NSNotFound && end.location != NSNotFound {
				let tagName = tag.substringToIndex(start.location)
				let tagURL = tag.substringWithRange(NSMakeRange(start.location + 1, end.location - start.location - 1))
				dict.setObject(tagURL, forKey: tagName)
			}
		}
		return dict

	}

	func loadFavicon(completionHandler: (ima: UIImage?) -> Void) {
		if let longURL = webView?.URL {

			let string = shortURL(longURL)
			let url = NSURL(string: NSString(format: "http://icons.better-idea.org/api/icons?url=%@&i_am_feeling_lucky=yes", string) as String)!
			NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: url)) {(data : NSData?, response : NSURLResponse?, err : NSError?) -> Void in

				if data != nil {
					let image = UIImage(data: data!)
					if image != nil {
						dispatch_async(dispatch_get_main_queue(), {() -> Void in
								completionHandler(ima: image!)
							})

					} else {
						let js: AnyObject?
						do {
							js = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
						} catch _ {
							js = nil
						}
						print(js)
						dispatch_async(dispatch_get_main_queue(), {() -> Void in
								//return empty placeholder
								completionHandler(ima: UIImage(named: "g"))
							})
					}
				} else {
					dispatch_async(dispatch_get_main_queue(), {() -> Void in
							completionHandler(ima: UIImage(named: "g"))
						})
					print(err)
				}

			}.resume()

		}
		//http://icons.better-idea.org/api/icons?url=stackovereflow.com&i_am_feeling_lucky=yes
	}
	func showActionSheet(pt : CGPoint) {
		var tags : NSArray? = nil
		self.webView!.evaluateJavaScript(NSString(format: "getHTMLElementsAtPoint(%i,%i);", NSInteger(pt.x), NSInteger(pt.y)) as String, completionHandler: {(stringy, error : NSError?) -> Void in
				if error == nil {


					let result = stringy as! NSString
					tags = result.componentsSeparatedByString("|&|")

					let dict = NSMutableDictionary(capacity: 2)
					for tag : NSString in tags as! [NSString] {
						let start = tag.rangeOfString("[")
						let end = tag.rangeOfString("]")
						if start.location != NSNotFound && end.location != NSNotFound {
							let tagName = tag.substringToIndex(start.location)
							let tagURL = tag.substringWithRange(NSMakeRange(start.location + 1, end.location - start.location - 1))
							dict.setObject(tagURL, forKey: tagName)
						}
					}


					let link : NSString? = dict.valueForKey("A") as? NSString
					let image : NSString? = dict.valueForKey("IMG") as? NSString
					var actionSheet : UIAlertController?
					if link != nil && image != nil {
						actionSheet = UIAlertController(title: link! as String, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
						actionSheet?.addAction(UIAlertAction(title: "Open in New Tab", style: UIAlertActionStyle.Default, handler: {(n) -> Void in
									NSNotificationCenter.defaultCenter().postNotificationName("AddTabURL", object: link! as String)
								}))
						actionSheet?.addAction(UIAlertAction(title: "Save Image", style: UIAlertActionStyle.Default, handler: {(n) -> Void in
									self.saveImage(image!)
								}))
						actionSheet?.addAction(UIAlertAction(title: "Copy URL", style: UIAlertActionStyle.Default, handler: {(n) -> Void in
									UIPasteboard.generalPasteboard().string = link! as String
								}))

					} else if link != nil && image == nil {
						actionSheet = UIAlertController(title: link! as String, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
						actionSheet?.addAction(UIAlertAction(title: "Open in New Tab", style: UIAlertActionStyle.Default, handler: {(n) -> Void in
									NSNotificationCenter.defaultCenter().postNotificationName("AddTabURL", object: link! as String)
								}))
						actionSheet?.addAction(UIAlertAction(title: "Copy URL", style: UIAlertActionStyle.Default, handler: {(n) -> Void in
									UIPasteboard.generalPasteboard().string = link! as String
								}))

					} else if link == nil && image != nil {
						actionSheet = UIAlertController(title: image! as String, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

						actionSheet?.addAction(UIAlertAction(title: "Save Image", style: UIAlertActionStyle.Default, handler: {(n) -> Void in
									self.saveImage(image!)
								}))
						actionSheet?.addAction(UIAlertAction(title: "Copy URL", style: UIAlertActionStyle.Default, handler: {(n) -> Void in
									UIPasteboard.generalPasteboard().string = link! as String
								}))
					}
					if let alert = actionSheet {
						let pop = actionSheet?.popoverPresentationController
						pop?.sourceRect = CGRect(x: pt.x + 4, y: pt.y, width: 4, height: 4)
						pop?.sourceView = self.webView!
						self.webView?.firstViewController()!.presentViewController(alert, animated: true, completion: nil)
					}
				}


			})
	}
	func saveImage(link : NSString) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {() -> Void in
				let data = NSData(contentsOfURL: NSURL(string: link as String)!)
				if data != nil {
					let im = UIImage(data: data!)
					UIImageWriteToSavedPhotosAlbum(im!, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
				}
			})
	}

	func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer < () >) {
		if error != nil {
			let alert = UIAlertController(title: "Image Cannot Be Saved!", message: nil, preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
			self.webView?.firstViewController()!.presentViewController(alert, animated: true, completion: nil)
		}
	}


}
