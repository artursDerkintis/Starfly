//
//  SFWebVC.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/16/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class SFWebVC: UIViewController, WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {
    var webView : WKWebView?
    var faviconOperation = NSOperationQueue()
    dynamic var favicon : UIImage?
    var tabManagment : SFTabManagment?
    var modeOfWeb = SFWebState.home
    var selected : NSMutableDictionary?
    var newContentLoaded : ((Bool) -> (Void))?
    var circle : UIView?
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

        webView = WKWebView(frame:  CGRect(x: 0, y: 90, width: self.view.frame.width, height: self.view.frame.height - 90), configuration: con)
        webView?.UIDelegate = self
        webView?.navigationDelegate = self
        webView?.clipsToBounds = false
        
        webView?.backgroundColor = UIColor.clearColor()
        webView?.scrollView.backgroundColor = UIColor.clearColor()
        webView?.opaque = false
        webView?.scrollView.clipsToBounds = false
        webView?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        
        webView?.allowsBackForwardNavigationGestures = true
        
        view.addSubview(webView!)
        if let web = webView{
            web.addObserver(self, forKeyPath: "URL", options: NSKeyValueObservingOptions.New, context: nil)
            web.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
            web.addObserver(self, forKeyPath: "canGoBack", options: NSKeyValueObservingOptions.New, context: nil)
            web.addObserver(self, forKeyPath: "canGoForward", options: NSKeyValueObservingOptions.New, context: nil)
            web.addObserver(self, forKeyPath: "loading", options: NSKeyValueObservingOptions.New, context: nil)
        }
        let long = UILongPressGestureRecognizer(target: self, action: "long:")
        long.delegate = self
        
        long.minimumPressDuration = 2.0
        webView?.addGestureRecognizer(long)
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        tap.delegate = self
        view.addGestureRecognizer(tap)
        setupCircle()
    }
    func setupCircle(){
        circle = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        circle?.layer.borderWidth = 2
        circle?.layer.cornerRadius = 25
        circle?.hidden = true
        circle?.userInteractionEnabled = false
        view.addSubview(circle!)
        
        
        
    }
    func tap(sender : UITapGestureRecognizer){
        if NSUserDefaults.standardUserDefaults().boolForKey("showT"){
        let location = sender.locationInView(sender.view)
        circle?.layer.borderColor = currentColor?.CGColor
        circle?.center = location
        circle?.hidden = false
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.circle?.transform = CGAffineTransformMakeScale(1.1, 1.1)
            }) { (fin) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.circle?.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
                    }, completion: { (fin) -> Void in
                        self.circle?.hidden = true
                })
                
                
            }}
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       
        return true
    }
  
    func savePassword(dict : NSMutableDictionary, strinf : String){
        let alert = UIAlertController(title: "Save password", message: "Do you want to save password for \(strinf)?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Cancel, handler: { (Action) -> Void in
            let dicte : NSMutableDictionary? = (NSUserDefaults.standardUserDefaults().objectForKey("PASSWORDS") as? NSMutableDictionary)?.mutableCopy() as? NSMutableDictionary
            if dicte != nil{
                
                dicte!.setObject(dict, forKey: strinf)
                NSUserDefaults.standardUserDefaults().setObject(dicte, forKey: "PASSWORDS")
            }else{
                let dictes = NSMutableDictionary()
                dictes.setObject(dict, forKey: strinf)
                NSUserDefaults.standardUserDefaults().setObject(dictes, forKey: "PASSWORDS")
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (Action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    func updatePassword(dict : NSMutableDictionary, strinf : String){
        let alert = UIAlertController(title: "Update password", message: "Do you want to update password for \(strinf)?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.Cancel, handler: { (Action) -> Void in
            let dicte : NSMutableDictionary? = (NSUserDefaults.standardUserDefaults().objectForKey("PASSWORDS") as? NSMutableDictionary)!.mutableCopy() as? NSMutableDictionary
            if dicte != nil{
                
                dicte!.setValue(dict, forKey: strinf)
                NSUserDefaults.standardUserDefaults().setObject(dicte, forKey: "PASSWORDS")
            }else{
                let dictes = NSMutableDictionary()
                dicte!.setValue(dict, forKey: strinf)
                NSUserDefaults.standardUserDefaults().setObject(dictes, forKey: "PASSWORDS")
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (Action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }

    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
       
        if keyPath == "URL" || keyPath == "estimatedProgress" || keyPath == "canGoBack" || keyPath == "canGoForward" || keyPath == "loading"{
            NSNotificationCenter.defaultCenter().postNotificationName("UPDATE", object: self)
        }
      
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func cleanUp() {
         webView?.evaluateJavaScript("stopAllVideos();", completionHandler: nil)
    }
    
    deinit{
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
    
    func openURL(urlOpt : NSURL?){
        if let url = urlOpt{
            modeOfWeb = .web
            webView?.loadRequest(NSURLRequest(URL: url))
            webView?.backgroundColor = UIColor.whiteColor()
        }else{
            justGoHome()
        }
    }
    func justGoHome(){
        
        let url = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("home", ofType:"html")!)
        webView?.loadRequest(NSURLRequest(URL: url))
        webView?.backgroundColor = UIColor.clearColor()
    
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if let url = webView.URL{
        if webView.title == "Starfly Home" && url.absoluteString.containsString("file:///"){
            tabManagment?.bringHomeInFront()
            modeOfWeb = .home
        }else{
            modeOfWeb = .web
            }
        }
        newContentLoaded?(true)
        if NSUserDefaults.standardUserDefaults().boolForKey("rest"){
            NSNotificationCenter.defaultCenter().postNotificationName("recover", object: nil)
        }
        if NSUserDefaults.standardUserDefaults().boolForKey("savePASS"){
            let dicte = NSUserDefaults.standardUserDefaults().objectForKey("PASSWORDS") as? NSMutableDictionary
            
            if dicte != nil{
                
                if (dicte?.valueForKey(shortURL(webView.URL!) as String) != nil){
                    let dictg = dicte?.valueForKey(shortURL(webView.URL!) as String) as! NSMutableDictionary
                    let user = dictg.valueForKey("USERNAME") as? String
                    let password = dictg.valueForKey("PASSWORD") as? String
                    if user != nil && password != nil{
                        let string  = String(format: "injectPassword(\"%@\",\"%@\");", user!, password!)
                        print(string)
                        webView.evaluateJavaScript(string, completionHandler: { (string, error : NSError?) -> Void in
                            print("DONE OR \(string)")
                        })
                    }
                }
            }}

        let string = shortURL(webView.URL!)
        let url = NSURL(string: NSString(format: "http://icons.better-idea.org/api/icons?url=%@&i_am_feeling_lucky=yes", string) as String)!
        loadFavicon(url) { (ima) -> Void in
            self.favicon = ima
            if NSUserDefaults.standardUserDefaults().boolForKey("pr") == false{
            let dict = NSMutableDictionary()
            if webView.URL?.absoluteString != "about:blank" && webView.title != nil && !webView.URL!.absoluteString.containsString("file:///"){
                dict.setObject(webView.title!, forKey: "title")
                dict.setObject(webView.URL!.absoluteString, forKey: "url")
                if ima == nil {
                    dict.setObject(UIImage(named: "g")!, forKey: "iconData")
                }else{
                    dict.setObject(ima!, forKey: "iconData")
                }
                
                saveInHistory(dict)
                
                }}

        }
    }
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (Action) -> Void in
            completionHandler()
        }))
        
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func makeDictionaryOfPass(tags : [NSString]) -> NSMutableDictionary{
        let dict = NSMutableDictionary(capacity: 2)
        for tag : NSString in tags as [NSString] {
            let start = tag.rangeOfString("[")
            let end = tag.rangeOfString("]")
            if start.location != NSNotFound && end.location != NSNotFound {
                let tagName = tag.substringToIndex(start.location)
                let tagURL  = tag.substringWithRange(NSMakeRange(start.location + 1, end.location - start.location - 1))
                dict.setObject(tagURL, forKey: tagName)
            }
        }
        return dict
        
    }

    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.FormSubmitted && NSUserDefaults.standardUserDefaults().boolForKey("savePASS"){
            webView.evaluateJavaScript("savePassword();", completionHandler: { (string, error : NSError?) -> Void in
                if string != nil{
                    let result = string as! NSString
                    let tags = result.componentsSeparatedByString("|&|")
                    let dict = self.makeDictionaryOfPass(tags as [NSString])
                    
                    
                    let userName = dict.valueForKey("USERNAME") as? NSString
                    let passWord = dict.valueForKey("PASSWORD") as? NSString
                    if userName != nil && passWord != nil{
                        print("USER \(userName), PASS \(passWord)")
                        let strinf = shortURL(webView.URL!)
                        let dicte = NSUserDefaults.standardUserDefaults().objectForKey("PASSWORDS") as? NSMutableDictionary
                        if dicte != nil{
                            if dicte?.valueForKey(strinf as String) != nil{
                                let dictg = dicte?.valueForKey(strinf as String) as! NSMutableDictionary
                                if dictg.valueForKey("USERNAME") as? String == userName && dictg.valueForKey("PASSWORD") as? String == passWord{
                                    
                                }else if dictg.valueForKey("USERNAME") as? String != userName || dictg.valueForKey("PASSWORD") as? String != passWord{
                                    self.updatePassword(dict, strinf: strinf as String)
                                }
                            }else{
                                self.savePassword(dict, strinf: strinf as String)
                            }
                        }else{
                            self.savePassword(dict, strinf: strinf as String)
                        }}
                }
            })
        }
        
        let url = navigationAction.request.URL;
        let urlString = url != nil ? url!.absoluteString : ""
        
        if (urlString as NSString).isMatch(NSRegularExpression(pattern: "\\/\\/itunes\\.apple\\.com\\/")){
            UIApplication.sharedApplication().openURL(url!)
            decisionHandler(WKNavigationActionPolicy.Cancel)
            return
        }
        if (navigationAction.targetFrame == nil){
            tabManagment?.addTabWithURL(navigationAction.request.URL!)
            decisionHandler(WKNavigationActionPolicy.Cancel)
        }
        decisionHandler(WKNavigationActionPolicy.Allow)
    }

    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
      //  print(navigationResponse.response.URL?.absoluteString)
        
        decisionHandler(WKNavigationResponsePolicy.Allow)
    }
    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {

        if let hostName = webView.URL?.host{
            let authMethod = challenge.protectionSpace.authenticationMethod
            if  authMethod == NSURLAuthenticationMethodDefault ||
                authMethod == NSURLAuthenticationMethodHTTPBasic ||
                authMethod == NSURLAuthenticationMethodHTTPDigest{
                
                    let title = "Authentication Request"
                    let message = "requires user name and password" + hostName
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addTextFieldWithConfigurationHandler{ (textField : UITextField) -> Void in
                        textField.placeholder = "User"
                        
                    }
                    alertController.addTextFieldWithConfigurationHandler{ (textField) -> Void in
                        textField.placeholder = "Password"
                        textField.secureTextEntry = true
                    }
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        
                        let userName = alertController.textFields![0].text
                        let password = alertController.textFields![1].text
                        
                        let credential = NSURLCredential(user: userName!, password: password!, persistence: NSURLCredentialPersistence.None)
                        
                        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
                    }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                        completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
                    }))
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    })
            }else{
                completionHandler(NSURLSessionAuthChallengeDisposition.PerformDefaultHandling, nil)
            }
        }
        
    }
    func loadFavicon(url : NSURL, completionHandler:(ima:UIImage?) -> Void){
        NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: url)) { (data : NSData?, response : NSURLResponse?, err : NSError?) -> Void in
            print("Completion")
            if data != nil{
                let image = UIImage(data: data!)
                if image != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(ima: image!)
                    })
                    
                }else{
                    let js: AnyObject?
                    do {
                        js = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    } catch _ {
                        js = nil
                    }
                    print(js)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(ima: UIImage(named: "g"))
                    })
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(ima: UIImage(named: "g"))
                })
                print(err)
            }
        
        }.resume()
        //http://icons.better-idea.org/api/icons?url=stackovereflow.com&i_am_feeling_lucky=yes
    }
   
    func long(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Began{
            
            self.tagsForPosition(sender.locationInView(webView!), gesture: sender)
        }
    }
    
    func tagsForPosition(pt : CGPoint, gesture: UIGestureRecognizer){
        var tags : NSArray? = nil
        self.webView!.evaluateJavaScript(NSString(format: "getHTMLElementsAtPoint(%i,%i);",NSInteger(pt.x),NSInteger(pt.y)) as String, completionHandler: { (stringy, error : NSError?) -> Void in
            if error == nil{
                
                
                let result = stringy as! NSString
                tags = result.componentsSeparatedByString("|&|")
                self.makeDict(tags!)
                
                let link : NSString? = self.selected!.valueForKey("A") as? NSString
                let image : NSString? = self.selected!.valueForKey("IMG") as? NSString
                var actionSheet : UIAlertController?
                if link != nil && image != nil {
                    actionSheet = UIAlertController(title: link! as String, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                    actionSheet?.addAction(UIAlertAction(title: "Open in New Tab", style: UIAlertActionStyle.Default, handler: { (n) -> Void in
                        self.tabManagment?.addTabWithURL(NSURL(string: link! as String)!)
                    }))
                    actionSheet?.addAction(UIAlertAction(title: "Save Image", style: UIAlertActionStyle.Default, handler: { (n) -> Void in
                        self.saveImage(image!)
                    }))
                    actionSheet?.addAction(UIAlertAction(title: "Copy URL", style: UIAlertActionStyle.Default, handler: { (n) -> Void in
                        UIPasteboard.generalPasteboard().string = link! as String
                    }))
                
                }else if link != nil && image == nil {
                    actionSheet = UIAlertController(title: link! as String, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                    actionSheet?.addAction(UIAlertAction(title: "Open in New Tab", style: UIAlertActionStyle.Default, handler: { (n) -> Void in
                        self.tabManagment?.addTabWithURL(NSURL(string: link! as String)!)
                    }))
                    actionSheet?.addAction(UIAlertAction(title: "Copy URL", style: UIAlertActionStyle.Default, handler: { (n) -> Void in
                        UIPasteboard.generalPasteboard().string = link! as String
                    }))

                }else if link == nil && image != nil{
                    actionSheet = UIAlertController(title: image! as String, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                    
                    actionSheet?.addAction(UIAlertAction(title: "Save Image", style: UIAlertActionStyle.Default, handler: { (n) -> Void in
                        self.saveImage(image!)
                    }))
                    actionSheet?.addAction(UIAlertAction(title: "Copy URL", style: UIAlertActionStyle.Default, handler: { (n) -> Void in
                        UIPasteboard.generalPasteboard().string = link! as String
                    }))
                }
                if let alert = actionSheet{
                    let pop = actionSheet?.popoverPresentationController
                    pop?.sourceRect = CGRect(x: pt.x + 4, y: pt.y, width: 4, height: 4)
                    pop?.sourceView = self.webView!
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            
        })
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let link : NSString? = self.selected!.valueForKey("A") as? NSString
        let image : NSString? = self.selected!.valueForKey("IMG") as? NSString
        if link != nil && image != nil {
            switch buttonIndex {
            case 1:
                tabManagment?.addTabWithURL(NSURL(string: link! as String)!)
               // del?.addTabInForeground(NSURLRequest(URL: NSURL(string: link! as String)!))
                break
            
            case 2:
                saveImage(image!)
                break
            case 4:
                UIPasteboard.generalPasteboard().string = link! as String
                break
            default:
                break
            }
        }else if link != nil && image == nil {
            switch buttonIndex {
            case 1:
                tabManagment?.addTabWithURL(NSURL(string: link! as String)!)
               // del?.addTabInForeground(NSURLRequest(URL: ))
                break
            case 2:
                UIPasteboard.generalPasteboard().string = link! as String
                break
            default:
                break
            }
            
            
        }else if link == nil && image != nil{
            switch buttonIndex {
                
            case 1:
                saveImage(image!)
                break
            case 2:
                UIPasteboard.generalPasteboard().string = link! as String
                break
            default:
                break
            }
            
        }
        
    }
    func saveImage(link : NSString){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            let data = NSData(contentsOfURL: NSURL(string: link as String)!)
            if data != nil {
                let im = UIImage(data: data!)
                UIImageWriteToSavedPhotosAlbum(im!, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
            }
        })
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        if error != nil{
            let alert = UIAlertView(title: "Cannot Save", message: "Error Retrieving Data", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    func makeDict(tag : NSArray){
        let dict = NSMutableDictionary(capacity: 2)
        for tags : NSString in tag as! [NSString] {
            let start = tags.rangeOfString("[")
            let end = tags.rangeOfString("]")
            if start.location != NSNotFound && end.location != NSNotFound {
                let tagName = tags.substringToIndex(start.location)
                let tagURL  = tags.substringWithRange(NSMakeRange(start.location + 1, end.location - start.location - 1))
                dict.setObject(tagURL, forKey: tagName)
            }
        }
        self.selected = dict
        
        print(self.selected)
    }
    
}
public func shortURL(url : NSURL?) -> NSString{
    
    if url == nil{return ""}
    if url!.absoluteString.containsString("file:///var/"){return ""}
    var strinf = url!.absoluteString as NSString
    if strinf.containsString("http://") || strinf.containsString("https://"){
        let array : NSArray = strinf.componentsSeparatedByString("//")
        let newString : String = array.objectAtIndex(1) as! String
        let newArray  : NSArray = newString.componentsSeparatedByString("/")
        for string : String in newArray as! [String]{
            if string == newArray[0] as? NSString{
                strinf = string
            }else{
                
            }
            
        }}
    return strinf
}

