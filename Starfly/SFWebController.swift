//
//  SFWebController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/16/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class SFWebController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {
    
	var webView : WKWebView?
    
	var faviconOperation = NSOperationQueue()
    
	dynamic var favicon : UIImage?
    
	var modeOfWeb = SFWebState.home
    
	var newContentLoaded : ((Bool) -> (Void))?
    
	var circle : UIView?
    
	var isCurrent : Bool = false {
		didSet {
			if isCurrent {
				//Updates everthing on becoming current
				NSNotificationCenter.defaultCenter().postNotificationName("PROGRESS", object: self.webView?.estimatedProgress)
				NSNotificationCenter.defaultCenter().postNotificationName("UPDATE", object: self)
			}
		}
	}
    var longpress = false
	var handler : SFWebViewHandler?
	override func viewDidLoad() {
		super.viewDidLoad()
		let stringOfJS: NSString?
		do {
			stringOfJS = try NSString(contentsOfFile: NSBundle.mainBundle().pathForResource("web", ofType: "js")!, encoding: NSUTF8StringEncoding)
		} catch _ {
			stringOfJS = nil
		}
		let ed = WKUserScript(source: stringOfJS! as String, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: false)
		let ee = WKUserContentController()

		ee.addUserScript(ed)

		let con = WKWebViewConfiguration()
		con.userContentController = ee

		webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), configuration: con)
		handler = SFWebViewHandler(webView: webView!)
		webView?.UIDelegate = self
		webView?.navigationDelegate = self
		webView?.clipsToBounds = false

		webView?.backgroundColor = UIColor.clearColor()
		webView?.scrollView.backgroundColor = UIColor.clearColor()
		webView?.opaque = false
		webView?.scrollView.clipsToBounds = false
		webView?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        webView?.allowsLinkPreview = true
		webView?.allowsBackForwardNavigationGestures = true

		view.addSubview(webView!)

		if let web = webView {
			web.addObserver(self, forKeyPath: "URL", options: NSKeyValueObservingOptions.New, context: nil)
			web.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
			web.addObserver(self, forKeyPath: "canGoBack", options: NSKeyValueObservingOptions.New, context: nil)
			web.addObserver(self, forKeyPath: "canGoForward", options: NSKeyValueObservingOptions.New, context: nil)
			web.addObserver(self, forKeyPath: "loading", options: NSKeyValueObservingOptions.New, context: nil)
		}

		//long press for action sheet
		let long = UILongPressGestureRecognizer(target: self, action: "longPress:")
		long.delegate = self
		webView?.addGestureRecognizer(long)

		//circle when tapped
		let tap = UITapGestureRecognizer(target: self, action: "tap:")
		tap.delegate = self
		view.addGestureRecognizer(tap)

		setupCircle()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "action:", name: "ACTION", object: nil)
	}
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.webView?.scrollView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
	}
	func action(not : NSNotification) {
		if isCurrent {
			self.performSelector(Selector(not.object! as! String))
		}
	}
	func goBack() {
		webView?.goBack()
	}

	func goHome() {
		//if there's no url - "goes home"
		openURL(nil)
	}

	func reload() {
		webView?.reload()
	}

	func stop() {
		webView?.stopLoading()
	}

	func goForward() {
		webView?.goForward()
	}

	func setupCircle() {
		circle = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
		circle?.layer.borderWidth = 2
		circle?.layer.cornerRadius = 25
		circle?.hidden = true
		circle?.userInteractionEnabled = false
		view.addSubview(circle!)
	}

	func tap(sender : UITapGestureRecognizer) {
		if NSUserDefaults.standardUserDefaults().boolForKey("showT") {
			let location = sender.locationInView(sender.view)
			circle?.layer.borderColor = currentColor?.CGColor
			circle?.center = location
			circle?.hidden = false
			UIView.animateWithDuration(0.1, animations: {() -> Void in
					self.circle?.transform = CGAffineTransformMakeScale(1.1, 1.1)
				}) {(fin) -> Void in
				UIView.animateWithDuration(0.5, animations: {() -> Void in
						self.circle?.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
					}, completion: {(fin) -> Void in
						self.circle?.hidden = true
					})


			}}
	}

	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {

		return true
	}



	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

		if keyPath == "URL" || keyPath == "estimatedProgress" || keyPath == "canGoBack" || keyPath == "canGoForward" || keyPath == "loading" {
			if self.isCurrent {
				NSNotificationCenter.defaultCenter().postNotificationName("UPDATE", object: self)
				NSNotificationCenter.defaultCenter().postNotificationName("PROGRESS", object: self.webView?.estimatedProgress)
			}
		}

	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

	}

	func cleanUp() {
		webView?.deleteMySelf()
	}

	deinit {
		webView?.removeObserver(self, forKeyPath: "URL")
		webView?.removeObserver(self, forKeyPath: "estimatedProgress")
		webView?.removeObserver(self, forKeyPath: "canGoBack")
		webView?.removeObserver(self, forKeyPath: "canGoForward")
		webView?.removeObserver(self, forKeyPath: "loading")
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

	}
	func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {

	}

	func openURL(urlOpt : NSURL?) {
        
		if let url = urlOpt {
			modeOfWeb = .web
			webView?.loadRequest(NSURLRequest(URL: url))
			webView?.backgroundColor = UIColor.whiteColor()
		} else {
			justGoHome()
		}
        
	}
    
	func justGoHome() {

		let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("home", ofType: "html")!)
		webView?.loadRequest(NSURLRequest(URL: url))
		webView?.backgroundColor = UIColor.clearColor()


	}


	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		if let url = webView.URL {
			if webView.title == "Starfly Home" && url.absoluteString.containsString("file:///") {

				NSNotificationCenter.defaultCenter().postNotificationName("HOME", object: self)
				modeOfWeb = .home
			} else {
                
				modeOfWeb = .web
			}
		}
        NSNotificationCenter.defaultCenter().postNotificationName("RECOVERY", object: nil)
		newContentLoaded?(true)

		handler?.tryToInjectPasword()

		handler?.loadFavicon({(ima) -> Void in
				self.favicon = ima
				self.handler?.saveHistory(ima)
			})
	}

	func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
		let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(Action) -> Void in
					completionHandler()
				}))
		self.presentViewController(alert, animated: true, completion: nil)
	}
   
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if longpress == true{
            decisionHandler(.Cancel)
            longpress = false
            return
        }
        
        let url = navigationAction.request.URL;
        let urlString = url != nil ? url!.absoluteString : ""
        
        if (urlString as NSString).isMatch(NSRegularExpression(pattern: "\\/\\/itunes\\.apple\\.com\\/")) {
            UIApplication.sharedApplication().openURL(url!)
            decisionHandler(WKNavigationActionPolicy.Cancel)
            return
        }
        if (navigationAction.targetFrame == nil) {
            NSNotificationCenter.defaultCenter().postNotificationName("AddTabURL", object: navigationAction.request.URL!.absoluteString)
            decisionHandler(WKNavigationActionPolicy.Cancel)
        }
        decisionHandler(WKNavigationActionPolicy.Allow)


    }
    
	func longPress(sender: UILongPressGestureRecognizer) {
        longpress = true
		if sender.state == UIGestureRecognizerState.Began {
           handler!.showActionSheet(sender.locationInView(webView!))
			
        }else if sender.state == UIGestureRecognizerState.Ended{
                        
        }
	}
	func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {

		if let hostName = webView.URL?.host {
			let authMethod = challenge.protectionSpace.authenticationMethod
			if authMethod == NSURLAuthenticationMethodDefault ||
			authMethod == NSURLAuthenticationMethodHTTPBasic ||
			authMethod == NSURLAuthenticationMethodHTTPDigest {

				let title = "Authentication Request"
				let message = "requires user name and password" + hostName
				let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
				alertController.addTextFieldWithConfigurationHandler {(textField : UITextField) -> Void in
					textField.placeholder = "User"

				}
				alertController.addTextFieldWithConfigurationHandler {(textField) -> Void in
					textField.placeholder = "Password"
					textField.secureTextEntry = true
				}
				alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action) -> Void in

							let userName = alertController.textFields![0].text
							let password = alertController.textFields![1].text

							let credential = NSURLCredential(user: userName!, password: password!, persistence: NSURLCredentialPersistence.None)

							completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
						}))
				alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alertAction) -> Void in
							completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
						}))
				dispatch_async(dispatch_get_main_queue(), {() -> Void in
						self.presentViewController(alertController, animated: true, completion: nil)

					})
			} else {
				completionHandler(NSURLSessionAuthChallengeDisposition.PerformDefaultHandling, nil)
			}
		}

	}



	func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
       /// print(error.localizedDescription)
        
	}
}

