//
//  SFWebVC.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/16/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import WebKit

class SFWebVC: UIViewController {
    var webView : WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.bounds)
        webView?.clipsToBounds = false
        webView?.scrollView.clipsToBounds = false
        webView?.scrollView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
        webView?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.google.com")!))
        view.addSubview(webView!)
    }
}
