//
//  SFTextController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 11/21/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFTextView: UIView, UIGestureRecognizerDelegate {
    var textediting : Bool = false
    var textFieldHolder : UIView?
    var textField : UITextField?
    var fullURL : NSURL?
    var searchCompletion : SFSearchTable?
    func setup() {
        //TextField Holder
        textFieldHolder = UIView(frame: CGRect.zero)
        addSubviewSafe(textFieldHolder)
        textFieldHolder?.snp_makeConstraints(closure: {(make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(35)
            make.center.equalTo(self)
        })
        textFieldHolder?.layer.cornerRadius = 35 * 0.5
        textFieldHolder?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.4).CGColor
        textFieldHolder?.layer.shadowOffset = CGSize(width: 0, height: lineWidth())
        textFieldHolder?.layer.shadowOpacity = 0.6
        textFieldHolder?.layer.shadowRadius = 0
        textFieldHolder?.layer.borderWidth = 0
        textFieldHolder?.layer.borderColor = UIColor.whiteColor().CGColor
        textFieldHolder?.layer.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.07).CGColor
        textFieldHolder?.layer.masksToBounds = false
        
        //TextField Setup
        textField = UITextField(frame: CGRect.zero)
        textFieldHolder?.addSubviewSafe(textField)
        textField?.snp_makeConstraints(closure: {(make) -> Void in
            make.top.bottom.right.left.equalTo(0)
        })
        textField?.attributedPlaceholder = NSAttributedString(string: "Search or Type URL", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.9)])
        textField?.layer.cornerRadius = 35 * 0.5
        textField?.layer.masksToBounds = true
        textField?.keyboardType = UIKeyboardType.WebSearch
        textField?.keyboardAppearance = UIKeyboardAppearance.Light
        textField?.clearButtonMode = .WhileEditing
        textField?.autocapitalizationType = UITextAutocapitalizationType.None
        textField?.autocorrectionType = UITextAutocorrectionType.No
        textField?.tintColor = UIColor.whiteColor()
        textField?.font = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        textField?.textColor = UIColor.whiteColor()
        textField?.leftView = UIView(frame: CGRectMake(0, 0, 15, 30))
        textField?.leftViewMode = UITextFieldViewMode.Always
        textField?.addTarget(self, action: "textFieldStart", forControlEvents: UIControlEvents.EditingDidBegin)
        textField?.addTarget(self, action: "textFieldEnd", forControlEvents: [UIControlEvents.EditingDidEnd, UIControlEvents.EditingDidEndOnExit])
        textField?.addTarget(self, action: "textEnter", forControlEvents: UIControlEvents.EditingDidEndOnExit)
        textField?.addTarget(self, action: "textFieldEditing", forControlEvents: UIControlEvents.EditingChanged)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "showFullURL:")
        textFieldHolder!.addGestureRecognizer(doubleTap)
        doubleTap.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "UPDATE", object: nil)
        let progress = SFProgressView(frame: .zero)
        textField?.addSubviewSafe(progress)
        progress.snp_makeConstraints {(make) -> Void in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(0)
            make.height.equalTo(3)
        }
        
    }
    
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func textFieldStart() {
        delay(0.2) {() -> () in
            self.textField!.selectedTextRange = self.textField!.textRangeFromPosition(self.textField!.beginningOfDocument, toPosition: self.textField!.endOfDocument)
            self.presentSearchCompletions()
        }
        let basicAnim = CABasicAnimation(keyPath: "shadowRadius")
        basicAnim.toValue = 6
        basicAnim.duration = 0.2
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.removedOnCompletion = false
        textFieldHolder?.layer.addAnimation(basicAnim, forKey: "shadow")
        let basicAnim1 = CABasicAnimation(keyPath: "shadowColor")
        basicAnim1.fromValue = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        basicAnim1.toValue = UIColor.whiteColor().colorWithAlphaComponent(1).CGColor
        basicAnim1.duration = 0.2
        basicAnim1.fillMode = kCAFillModeForwards
        basicAnim1.removedOnCompletion = false
        textFieldHolder?.layer.addAnimation(basicAnim1, forKey: "shadow2")
        let basicAnim2 = CABasicAnimation(keyPath: "shadowOffset")
        basicAnim2.fromValue = NSValue(CGSize: CGSize(width: 0, height: lineWidth()))
        basicAnim2.toValue = NSValue(CGSize: CGSize(width: 0, height: 0))
        basicAnim2.duration = 0.2
        basicAnim2.fillMode = kCAFillModeForwards
        basicAnim2.removedOnCompletion = false
        textFieldHolder?.layer.addAnimation(basicAnim2, forKey: "shadow3")
    }
    
    func textFieldEnd() {
        hideCompletions()
        let basicAnim = CABasicAnimation(keyPath: "shadowRadius")
        basicAnim.fromValue = 6
        basicAnim.toValue = 0
        basicAnim.duration = 0.2
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.removedOnCompletion = false
        textFieldHolder?.layer.addAnimation(basicAnim, forKey: "shadow")
        let basicAnim1 = CABasicAnimation(keyPath: "shadowColor")
        basicAnim1.fromValue = UIColor.whiteColor().colorWithAlphaComponent(1).CGColor
        basicAnim1.toValue = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        basicAnim1.duration = 0.2
        basicAnim1.fillMode = kCAFillModeForwards
        basicAnim1.removedOnCompletion = false
        textFieldHolder?.layer.addAnimation(basicAnim1, forKey: "shadow2")
        let basicAnim2 = CABasicAnimation(keyPath: "shadowOffset")
        basicAnim2.fromValue = NSValue(CGSize: CGSize(width: 0, height: 0))
        basicAnim2.toValue = NSValue(CGSize: CGSize(width: 0, height: lineWidth()))
        basicAnim2.duration = 0.2
        basicAnim2.fillMode = kCAFillModeForwards
        basicAnim2.removedOnCompletion = false
        textFieldHolder?.layer.addAnimation(basicAnim2, forKey: "shadow3")
    }
    
    func textFieldEditing() {
        if let sView = searchCompletion {
            if sView.hidden {
                sView.hidden = false
                sView.snp_updateConstraints {(make) -> Void in
                    make.height.equalTo(220)
                }
                sView.superview?.snp_updateConstraints {(make) -> Void in
                    make.height.equalTo(300)
                }
                UIView.animateWithDuration(0.5, animations: {() -> Void in
                    sView.superview?.layoutIfNeeded()
                    sView.alpha = 1.0
                    sView.layoutIfNeeded()
                    }) {(e) -> Void in
                }
            }
        }
        searchCompletion?.getSuggestions(forText: textField!.text!)
    }
    
    func textEnter() {
        if let url = NSURL(string: parseUrl(self.textField!.text!)!){
            NSNotificationCenter.defaultCenter().postNotificationName("OPEN", object: url)
        }
    }
    
    func presentSearchCompletions() {
        let urlBarView = self.firstViewController()?.view
        searchCompletion = SFSearchTable(frame: CGRect.zero)
        searchCompletion?.hidden = true
        urlBarView?.addSubviewSafe(searchCompletion)
        textediting = true
        searchCompletion?.snp_makeConstraints(closure: {(make) -> Void in
            make.top.equalTo(60)
            make.right.equalTo(-35)
            make.left.equalTo(35)
            make.height.equalTo(0)
        })
    }
    
    func hideCompletions() {
        if let v = searchCompletion {
            v.superview?.snp_updateConstraints {(make) -> Void in
                make.height.equalTo(45)
            }
            v.snp_updateConstraints {(make) -> Void in
                make.height.equalTo(0)
            }
            UIView.animateWithDuration(0.3, animations: {() -> Void in
                v.superview?.layoutIfNeeded()
                v.layoutIfNeeded()
                }, completion: {(fin) -> Void in
                    v.removeFromSuperview()
            })
        }
    }
    
    
    func showFullURL(sender : UITapGestureRecognizer) {
        let location = sender.locationInView(sender.view)
        if CGRectContainsPoint(CGRectMake(sender.view!.frame.width * 0.5, 0, sender.view!.frame.width * 0.5, sender.view!.frame.height), location){
            if let url = fullURL?.absoluteString {
                if !url.containsString("file:///") {
                    textField?.text = url
                }
            }
        }
    }
    
    func update(notification : NSNotification) {
        if let webVC = notification.object {
            if webVC.isKindOfClass(SFWebController) {
                updateInstantly(webVC as! SFWebController)
            }
        }
    }
    
    func updateInstantly(webViewVC : SFWebController) {
        if !textField!.isFirstResponder() {
            fullURL = webViewVC.webView?.URL
            textField?.text = shortURL(webViewVC.webView!.URL) as String
        }
    }
}
