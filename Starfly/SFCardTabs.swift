////
////  SFCardTabs.swift
////  SFCardTabs
////
////  Created by Arturs Derkintis on 7/14/15.
////  Copyright © 2015 Neal Ceffrey. All rights reserved.
////
///*
//
//*/
//import UIKit
//
//
//
//class SFCardTabs : UIView, UIScrollViewDelegate {
//    
//    var cells = [SFTab]()
//    
//    var offsetGap : CGFloat? = 5.0
//    
//    var scrollView : UIScrollView?
//    var addTabB : SFButton?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = .clearColor()
//        
//        
//        
//        scrollView = UIScrollView(frame: CGRect.zero)
//        scrollView?.layer.masksToBounds = false
//        scrollView?.clipsToBounds = false
//        scrollView?.showsHorizontalScrollIndicator = false
//        scrollView?.showsVerticalScrollIndicator = false
//        scrollView?.decelerationRate = 0.1
//        addSubview(scrollView!)
//        scrollView?.snp_makeConstraints { (make) -> Void in
//            make.top.bottom.left.equalTo(0)
//            make.right.equalTo(self.snp_right).inset(75).priority(100)
//        }
//        scrollView?.delegate = self
//        
//        
//        
//        addTabB = SFButton(type: UIButtonType.Custom)
//        addTabB?.setImage(UIImage(named: Images.addTab), forState: UIControlState.Normal)
//        addTabB?.setImage(UIImage(named: Images.addTab)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
//        addTabB?.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        addTabB?.layer.cornerRadius = 35 * 0.5
//        addTabB?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
//        addTabB?.layer.shadowOffset = CGSize(width: 0, height: 0)
//        addTabB?.layer.shadowRadius = 2
//        addTabB?.layer.shadowOpacity = 1.0
//        addTabB?.layer.rasterizationScale = UIScreen.mainScreen().scale
//        addTabB?.layer.shouldRasterize = true
//        addSubview(addTabB!)
//        addTabB?.snp_makeConstraints { (make) -> Void in
//            make.width.height.equalTo(35)
//            make.top.equalTo(5)
//            make.right.equalTo(-5).priority(100)
//        }
//       
//    }
//    
//    
//    func addTarget(target : SFTabs){
//        addTabB?.addTarget(target, action: "addNewTab", forControlEvents: UIControlEvents.TouchUpInside)
//    }
//    
//    //Adds new Tab 'Cell'
//    func addCell(newCell : SFTab){
//        
//        cells.append(newCell)
//        
//        scrollView!.addSubview(newCell)
//        scrollView?.sendSubviewToBack(newCell)
//        findFrames()
//            var x : CGFloat = 0.0
//            
//            for viewA in self.scrollView!.subviews{
//                
//                if x < CGRectGetMaxX(viewA.frame){
//                    x = CGRectGetMaxX(viewA.frame)
//                }
//            }
//            self.scrollView!.contentSize = CGSize(width: x, height: 0)
//            if x >= self.scrollView!.bounds.size.width{
//                let bottomOffset  = CGPointMake(x - self.scrollView!.bounds.size.width, 0)
//                self.scrollView!.setContentOffset(bottomOffset, animated: true)
//                
//            }
//        
//    }
//    
//    //Find placement for all tabs
//    func updateEverything(){
//        var width : CGFloat = 0.0
//        for cell in cells{
//            let size = CGSize(width: 200, height: cell.frame.height)
//            width += size.width * 1.02
//            
//            let origin = CGPoint(x: size.width * CGFloat(cells.indexOf(cell)!) * 1.02, y: 5)
//           
//            UIView.animateWithDuration(0.3, animations: { () -> Void in
//                cell.frame.size = size
//                
//                cell.center = CGPoint(x: origin.x + (size.width * 0.5), y: self.frame.height * 0.5)
//                self.repositionEachCell(self.scrollView!)
//            })
//            
//        }
//
//        var x : CGFloat = 0.0
//        
//        for viewA in self.scrollView!.subviews{
//            
//            if x < CGRectGetMaxX(viewA.frame){
//                x = CGRectGetMaxX(viewA.frame)
//            }
//            
//            
//        }
//        UIView.animateWithDuration(0.3) { () -> Void in
//            self.scrollView!.contentSize = CGSize(width: x, height: 0)
//        }
//
//    }
//    
//    func findFrames(){
//    
//        var width : CGFloat = 0.0
//        for cell in cells{
//        let size = CGSize(width: 200, height: cell.frame.height)
//            width += size.width * 1.02
//            
//            let origin = CGPoint(x: size.width * CGFloat(cells.indexOf(cell)!) * 1.02, y: 5)
//            if cell == cells.last{
//                cell.center = CGPoint(x: origin.x - (size.width * 0.5), y: self.frame.height * 0.5)
//            }
//            let animationOptions: UIViewAnimationOptions = [UIViewAnimationOptions.CurveEaseInOut, UIViewAnimationOptions.BeginFromCurrentState]
//            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: animationOptions, animations: { () -> Void in
//                cell.center = CGPoint(x: origin.x + (size.width * 0.5), y: self.frame.height * 0.5)
//                cell.frame.size = size
//                }, completion: { (e) -> Void in
//                    
//            })
//        }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        repositionEachCell(scrollView!)
//    }
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        repositionEachCell(scrollView)
//    }
//    
//   
//    func repositionEachCell(scrollView : UIScrollView){
//        for cell in cells{
//            
//            //next the magic happens, well, not really magic, but this is main thing!
//            
//            
//            let point = scrollView.convertPoint(cell.center, toView: self)
//            let offset = CGFloat(cells.indexOf(cell)!) * offsetGap!
//            let reversedOffset = CGFloat((cells.count - 1) - cells.indexOf(cell)!) * offsetGap!
//            if point.x < (cell.frame.width * 0.5) + offset {
//                let translationX = ((cell.frame.width * 0.5) - point.x) + offset
//                print(cell.center)
//                cell.transform = CGAffineTransformMakeTranslation(translationX, 0)
//                print(cell.center)
//                scrollView.bringSubviewToFront(cell)
//        
//                
//                
//            }else if  point.x > scrollView.frame.width - ((cell.frame.width * 0.5) + reversedOffset){
//                
//                let translationX = (point.x - (scrollView.frame.width - (cell.frame.width * 0.5)) + reversedOffset)
//                
//                cell.transform = CGAffineTransformMakeTranslation(-translationX, 0)
//        
//                scrollView.sendSubviewToBack(cell)
//            }else{
//                //if cell is in the middle
//                cell.transform = CGAffineTransformMakeTranslation(0, 0)
//                scrollView.bringSubviewToFront(cell)
//                }
//            }
//            
//            
//        }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//
