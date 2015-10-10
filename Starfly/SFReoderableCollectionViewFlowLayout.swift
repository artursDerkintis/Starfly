//
//  SFReoderableCollectionViewFlowLayout.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/18/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

let framesPerSec = 60.0
extension CGPoint{
    func addPoint(point2 : CGPoint) -> CGPoint{
        return CGPoint(x: x + point2.x, y: y + point2.y)
    }
}
enum SFScrollingDirection : Int{
    case unknown = 0
    case up = 1
    case down = 2
    case left = 3
    case right = 4
    
}
let kSFScrollingDirectionKey : String = "SFScrollingDirection"
let kSFColleectionViewKeyPath : String = "collectionView"

extension CADisplayLink{
    func setSFUserInfo(sfUserInfo : NSDictionary){
        objc_setAssociatedObject(self, "sfUserInfo", sfUserInfo, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
    func sfUserInfo() -> NSDictionary{
        return objc_getAssociatedObject(self, "sfUserInfo") as! NSDictionary
    }
}
extension UICollectionViewCell{
    func getRasterizedImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

@objc protocol SFReoderableCollectionViewDataSource : UICollectionViewDataSource{
    optional func collectionView(collectionView : UICollectionView, itemAtIndexPath fromIndexPath : NSIndexPath, willMoveToIndexPath toIndexPath : NSIndexPath)
    optional func collectionView(collectionView : UICollectionView, itemAtIndexPath fromIndexPath : NSIndexPath, didMoveToIndexPath toIndexPath : NSIndexPath)
    optional func collectionView(collectionView : UICollectionView, canMoveItemAtIndexPath indexPath : NSIndexPath) -> Bool
    optional func collectionView(collectionView : UICollectionView, itemAtIndexPath fromIndexPath : NSIndexPath, canMoveToIndexPath toIndexPath : NSIndexPath) -> Bool
    
}
@objc protocol SFReoderableCollectionViewDelegateFlowLayout : UICollectionViewDelegateFlowLayout{
    optional func collectionView(collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewFlowLayout, willBeginDraggingItemAtIndexPath indexPath : NSIndexPath)
    optional func collectionView(collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewFlowLayout, didBeginDraggingItemAtIndexPath indexPath : NSIndexPath)
    optional func collectionView(collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewFlowLayout, willEndDraggingItemAtIndexPath indexPath : NSIndexPath)
    optional func collectionView(collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewFlowLayout, didEndDraggingItemAtIndexPath indexPath : NSIndexPath)
    
}
class SFReorderableCollectioViewFlowLayout: UICollectionViewFlowLayout, UIGestureRecognizerDelegate
{
    var scrollingSpeed : CGFloat?
    var scrollingTriggerEdgeInsets : UIEdgeInsets?
    var longPressGestureRecognizer : UILongPressGestureRecognizer?
    var panGestureRecognizer : UIPanGestureRecognizer?
    var isEditable : Bool = true
    var isSpacing : Bool?
    var selectedItemIndexPath : NSIndexPath?
    var currentView : UIView?
    var currentViewCenter : CGPoint?
    var panTranslationInCollectionView : CGPoint?
    var displayLink : CADisplayLink?
    var dataSource : SFReoderableCollectionViewDataSource?
    var delegate : SFReoderableCollectionViewDelegateFlowLayout?
    
    override init() {
        super.init()
        setDefaults()
        setupCollectionView()
        self.addObserver(self, forKeyPath: kSFColleectionViewKeyPath, options: NSKeyValueObservingOptions.New, context: nil)
    }
    func setDefaults(){
        scrollingSpeed = 300
        scrollingTriggerEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        
    }
    func setupCollectionView(){
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
        longPressGestureRecognizer?.delegate = self
        longPressGestureRecognizer?.minimumPressDuration = 1.0
        longPressGestureRecognizer?.enabled = true
        self.collectionView?.addGestureRecognizer(longPressGestureRecognizer!)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        panGestureRecognizer?.delegate = self
        self.collectionView?.addGestureRecognizer(panGestureRecognizer!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApplicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.addObserver(self, forKeyPath: kSFColleectionViewKeyPath, options: NSKeyValueObservingOptions.New, context: nil)
        setDefaults()
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        self.removeObserver(self, forKeyPath: kSFColleectionViewKeyPath)
        NSNotificationCenter.removeObserver(self, forKeyPath: UIApplicationWillResignActiveNotification)
    }
    func applyLayoutAttributes(layoutAttributes : UICollectionViewLayoutAttributes){
        if layoutAttributes.indexPath.isEqual(self.selectedItemIndexPath){
            layoutAttributes.hidden = false
        }
    }
   
    
    func invalididateLayoutIfNecessary(){
        let newIndexPath = self.collectionView?.indexPathForItemAtPoint(self.currentView!.center)
        let previuosIndexPath = self.selectedItemIndexPath
        
        if (newIndexPath == nil){
            return
        }else if newIndexPath!.isEqual(previuosIndexPath){
            return
        }
        
        if((self.dataSource!.respondsToSelector("collectionView:itemAtIndexPath:canMoveToIndexPath:")) && (!self.dataSource!.collectionView!(self.collectionView!, itemAtIndexPath: previuosIndexPath!, canMoveToIndexPath: newIndexPath!))){
            return
        }
        self.selectedItemIndexPath = newIndexPath
        if (self.dataSource!.respondsToSelector("collectionView:itemAtIndexPath:willMoveToIndexPath:")){
            self.dataSource?.collectionView!(self.collectionView!, itemAtIndexPath: previuosIndexPath!, willMoveToIndexPath: newIndexPath!)
        }
        self.collectionView?.performBatchUpdates({ () -> Void in
            self.collectionView?.deleteItemsAtIndexPaths([previuosIndexPath!])
            self.collectionView?.insertItemsAtIndexPaths([newIndexPath!])
            
            }, completion: { (finish) -> Void in
                if self.dataSource!.respondsToSelector("collectionView:itemAtIndexPath:didMoveToIndexPath:"){
                    self.dataSource?.collectionView!(self.collectionView!, itemAtIndexPath: previuosIndexPath!, didMoveToIndexPath: newIndexPath!)
                }
        })
        
        
    }
    func invalidateScrollTimer(){
        if self.displayLink != nil{
        if self.displayLink!.paused{
            self.displayLink?.invalidate()
        }
            self.displayLink = nil}
    }
    func setupScrollTimerInDirection(direction : SFScrollingDirection){
        if displayLink != nil{
        if !displayLink!.paused{
            let oldDirection = SFScrollingDirection(rawValue: self.displayLink!.sfUserInfo()[kSFScrollingDirectionKey]!.integerValue)
            if direction == oldDirection{
                return
            }
            }}
        self.invalidateScrollTimer()
        self.displayLink = CADisplayLink(target: self, selector: "handleScroll:")
        let dict = NSMutableDictionary()
        dict.setObject(direction.rawValue, forKey: kSFScrollingDirectionKey)
        self.displayLink?.setSFUserInfo([kSFScrollingDirectionKey : direction.rawValue])
        self.displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    func handleScroll(displayLink : CADisplayLink){
        let direction = SFScrollingDirection(rawValue: displayLink.sfUserInfo()[kSFScrollingDirectionKey]!.integerValue)
        if direction == .unknown{
            return
        }
        let frameSize = self.collectionView!.bounds.size
        let contentSize = self.collectionView!.contentSize
        let contentOffset = self.collectionView!.contentOffset
        let contentInset = self.collectionView!.contentInset
        var distance = rint(self.scrollingSpeed! / CGFloat(framesPerSec))
        var translation = CGPoint.zero
        
        switch direction!{
        case .down:
            let maxY = max(contentSize.height, frameSize.height) - frameSize.height + contentInset.bottom
            if contentOffset.y + distance >= maxY{
                distance = maxY - contentOffset.y
            }
            translation = CGPoint(x: 0.0, y: distance)
            break
        case .left:
            distance = -distance
            let minX = 0.0 - contentInset.left
            if contentOffset.x + distance <= minX{
                distance = -contentOffset.x - contentInset.left
            }
            translation = CGPoint(x: distance, y: 0.0)
            break
        case .right:
            let maxX = max(contentSize.width, frameSize.width) * frameSize.width + contentInset.right
            if contentOffset.x + distance >= maxX{
                distance = maxX - contentOffset.x
            }
            translation = CGPoint(x: distance, y: 0.0)
            break
        case .up:
            distance = -distance
            let minY = 0.0 - contentInset.top;
            if contentOffset.y + distance <= minY{
                distance = -contentOffset.y - contentInset.top
            }
            translation = CGPoint(x: 0.0, y: distance)
            break
        default:
            break
            
        }
        self.currentViewCenter = self.currentViewCenter?.addPoint(translation)
        self.currentView?.center = self.currentViewCenter!.addPoint(self.panTranslationInCollectionView!)
        self.collectionView?.contentOffset = contentOffset.addPoint(translation)
    }
    func handleLongPressGesture(sender : UILongPressGestureRecognizer){
        if !isEditable{return}
        switch sender.state{
        case UIGestureRecognizerState.Began:
            let currentIndexPath = self.collectionView!.indexPathForItemAtPoint(sender.locationInView(self.collectionView))
            if self.dataSource!.respondsToSelector("collectionView:canMoveItemAtIndexPath:") && !self.dataSource!.collectionView!(self.collectionView!, canMoveItemAtIndexPath: currentIndexPath!){
                return
                
            }
            self.selectedItemIndexPath = currentIndexPath
            if self.delegate!.respondsToSelector("collectionView:layout:willBeginDraggingItemAtIndexPath:"){
                self.delegate?.collectionView!(self.collectionView!, layout: self, willBeginDraggingItemAtIndexPath: self.selectedItemIndexPath!)
                
            }
            let collectioViewCell = self.collectionView?.cellForItemAtIndexPath(self.selectedItemIndexPath!)
            currentView =  UIView(frame: collectioViewCell!.frame)
            collectioViewCell?.highlighted = true
            let highlightedImageView = UIImageView(image: collectioViewCell?.getRasterizedImage())
            highlightedImageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            highlightedImageView.alpha = 1.0
            collectioViewCell?.highlighted = false
            let imageView = UIImageView(image: collectioViewCell!.getRasterizedImage())
            imageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            imageView.alpha = 0.0
            currentView?.addSubview(imageView)
            currentView?.addSubview(highlightedImageView)
            self.collectionView?.addSubview(currentView!)
            self.currentViewCenter = self.currentView!.center
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.currentView?.transform = CGAffineTransformMakeScale(1.05, 1.05)
                highlightedImageView.alpha = 0.0
                imageView.alpha = 1.0
                }, completion: { (h) -> Void in
                   // collectioViewCell?.hidden = true
                    highlightedImageView.removeFromSuperview()
                    if self.delegate!.respondsToSelector("collectionView:layout:didBeginDraggingItemAtIndexPath:"){
                        self.delegate?.collectionView!(self.collectionView!, layout: self, didBeginDraggingItemAtIndexPath: self.selectedItemIndexPath!)
                        
                    }
            })
            invalidateLayout()
            break
        case UIGestureRecognizerState.Cancelled, UIGestureRecognizerState.Ended:
            let currentIndexPath = self.selectedItemIndexPath
            if currentIndexPath != nil{
                if self.delegate!.respondsToSelector("collectionView:layout:willEndDraggingItemAtIndexPath:"){
                    self.delegate?.collectionView!(self.collectionView!, layout: self, didEndDraggingItemAtIndexPath: currentIndexPath!)
                }
                self.selectedItemIndexPath = nil
                self.currentViewCenter = CGPoint.zero
                let layoutAttributes = self.layoutAttributesForItemAtIndexPath(currentIndexPath!)
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.currentView?.transform = CGAffineTransformIdentity
                        self.currentView?.center = layoutAttributes!.center
                    }, completion: { (y) -> Void in
                        self.currentView?.removeFromSuperview()
                        self.currentView = nil
                        self.invalidateLayout()
                        if self.delegate!.respondsToSelector("collectionView:layout:didEndDraggingItemAtIndexPath:"){
                            self.delegate?.collectionView!(self.collectionView!, layout: self, didEndDraggingItemAtIndexPath: currentIndexPath!)
                        }
                })
                
            }
            break
        default:
            break
            
        }
    }
    func handlePanGesture(sender : UIPanGestureRecognizer){
        switch sender.state{
        case .Began, .Changed:
            panTranslationInCollectionView = sender.translationInView(self.collectionView!)
            let viewCenter = self.currentViewCenter!.addPoint(panTranslationInCollectionView!)
            self.currentView?.center = viewCenter
            invalididateLayoutIfNecessary()
            switch (scrollDirection){
            case UICollectionViewScrollDirection.Vertical:
                if viewCenter.y < self.collectionView!.bounds.origin.y + self.scrollingTriggerEdgeInsets!.top{
                    self.setupScrollTimerInDirection(.up)
                }else{
                    if  viewCenter.y > CGRectGetMaxY(self.collectionView!.bounds) + scrollingTriggerEdgeInsets!.bottom{
                        setupScrollTimerInDirection(.down)
                    }else{
                        invalidateScrollTimer()
                    }
                }
                break
            case UICollectionViewScrollDirection.Horizontal:
                if viewCenter.x < self.collectionView!.bounds.origin.x + self.scrollingTriggerEdgeInsets!.left{
                    self.setupScrollTimerInDirection(.left)
                }else{
                    if  viewCenter.x > CGRectGetMaxX(self.collectionView!.bounds) + scrollingTriggerEdgeInsets!.right{
                        setupScrollTimerInDirection(.right)
                    }else{
                        invalidateScrollTimer()
                    }
                }

                break
            }
            break
            
        case .Cancelled, .Ended:
            invalidateScrollTimer()
            break
        default:
            break
        }
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesForElementsInRect = super.layoutAttributesForElementsInRect(rect)
        if layoutAttributesForElementsInRect != nil{
        for layoutAttributes in layoutAttributesForElementsInRect!{
            switch layoutAttributes.representedElementCategory{
            case .Cell:
                applyLayoutAttributes(layoutAttributes)
                break
            default:
                break
            }
            }
        }
        return layoutAttributesForElementsInRect
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       /* if self.longPressGestureRecognizer!.isEqual(gestureRecognizer){
            return self.panGestureRecognizer!.isEqual(otherGestureRecognizer)
        }
        if self.panGestureRecognizer!.isEqual(gestureRecognizer){
            return self.longPressGestureRecognizer!.isEqual(otherGestureRecognizer)
        }*/
        return true
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.panGestureRecognizer!.isEqual(gestureRecognizer){
            return self.selectedItemIndexPath != nil
        }
        return true
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == kSFColleectionViewKeyPath{
            if collectionView != nil{
                setupCollectionView()
            }else{
                invalidateScrollTimer()
            }
        }
    }
    func handleApplicationWillResignActive(not : NSNotification){
        self.panGestureRecognizer?.enabled = false
        self.panGestureRecognizer?.enabled = true
        
    }
}

