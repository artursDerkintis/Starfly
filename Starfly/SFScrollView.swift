//
//  SFScrollView.swift
//  SFScrollView
//
//  Created by Arturs Derkintis on 7/14/15.
//  Copyright © 2015 Neal Ceffrey. All rights reserved.
//
/*

*/
import UIKit

//Scrolling orientation
enum SFOrienation{
    case horizontal; //Default
    case vertical;
}

enum SFCellSizeStyle{
    case fixed;     //Fixed size to all cells
    case custom;      //Set costom size for each cell
   
}

let cellColor = UIColor.orangeColor()
let cellBorderColor = UIColor.whiteColor()



class SFScrollView : UIView, UIScrollViewDelegate {
    
    //Array of Cells
    var cells = [SFTab]()
    
    var offsetGap : CGFloat? = 5.0
    
    var fixedCellSize : CGSize? = CGSize(width: 100, height: 50)
    
    
    var orienation = SFOrienation.horizontal
    var cellSizeStyle = SFCellSizeStyle.fixed

    
    var scrollView : UIScrollView?
    var addTabB : UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clearColor()
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width - 45, height: frame.height ))
        scrollView?.autoresizingMask = sfMaskBoth
        scrollView?.layer.masksToBounds = false
        scrollView?.clipsToBounds = false
        ///Delete this if you don't need it
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.decelerationRate = 0.1
        ////
        
        addSubview(scrollView!)
        scrollView?.delegate = self
        
        addTabB = UIButton(type: UIButtonType.Custom)
        addTabB?.backgroundColor = currentColor
        addTabB?.frame = CGRect(x: frame.width - 40, y: 5, width: 35, height: 35)
        addTabB?.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        addTabB?.setImage(UIImage(named: NavImages.addTab), forState: UIControlState.Normal)
        addTabB?.setImage(UIImage(named: NavImages.addTab)?.imageWithColor(UIColor.lightGrayColor()), forState: UIControlState.Highlighted)
        addTabB?.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addTabB?.layer.cornerRadius = addTabB!.frame.size.height * 0.5
        addTabB?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        addTabB?.layer.shadowOffset = CGSize(width: 0, height: 0)
        addTabB?.layer.shadowRadius = 2
        addTabB?.layer.shadowOpacity = 1.0
        addTabB?.layer.rasterizationScale = UIScreen.mainScreen().scale
        addTabB?.layer.shouldRasterize = true
        addSubview(addTabB!)

       
    }
    func addTarget(target : SFTabs){
        addTabB?.addTarget(target, action: "addNewTab", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func addCell(newCell : SFTab){
        cells.append(newCell)
        
        scrollView!.addSubview(newCell)
        scrollView?.sendSubviewToBack(newCell)
        findFrames()
            var x : CGFloat = 0.0
            
            for viewA in self.scrollView!.subviews{
                
                if x < CGRectGetMaxX(viewA.frame){
                    x = CGRectGetMaxX(viewA.frame)
                }
                
                
            }
            self.scrollView!.contentSize = CGSize(width: x, height: 0)
            if x >= self.scrollView!.bounds.size.width{
                let bottomOffset  = CGPointMake(x - self.scrollView!.bounds.size.width, 0)
                self.scrollView!.setContentOffset(bottomOffset, animated: true)
                
            }

        

        
                   
        
        
        
    }
    
    func updateEverything(){
        var width : CGFloat = 0.0
        for cell in cells{
            let size = CGSize(width: 200, height: cell.frame.height)
            width += size.width * 1.02
            
            let origin = CGPoint(x: size.width * CGFloat(cells.indexOf(cell)!) * 1.02, y: 5)
           
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                cell.frame.size = size
                
                cell.center = CGPoint(x: origin.x + (size.width * 0.5), y: self.frame.height * 0.5)
                self.repositionEachCell(self.scrollView!)
            })
            
            
            
            
        }

        
        var x : CGFloat = 0.0
        
        for viewA in self.scrollView!.subviews{
            
            if x < CGRectGetMaxX(viewA.frame){
                x = CGRectGetMaxX(viewA.frame)
            }
            
            
        }
        UIView.animateWithDuration(0.3) { () -> Void in
            self.scrollView!.contentSize = CGSize(width: x, height: 0)
        }
        
        if x >= self.scrollView!.bounds.size.width{
           // let bottomOffset  = CGPointMake(x - self.scrollView!.bounds.size.width, 0)
            //self.scrollView!.setContentOffset(bottomOffset, animated: true)
            
        }

    }
    func findFrames(){
    
        var width : CGFloat = 0.0
        for cell in cells{
        let size = CGSize(width: 200, height: cell.frame.height)
            width += size.width * 1.02
            
            let origin = CGPoint(x: size.width * CGFloat(cells.indexOf(cell)!) * 1.02, y: 5)
            if cell == cells.last{
                cell.center = CGPoint(x: origin.x - (size.width * 0.5), y: self.frame.height * 0.5)
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
               
                    cell.frame.size = size
                
                cell.center = CGPoint(x: origin.x + (size.width * 0.5), y: self.frame.height * 0.5)
            })
           
      
            
            
        }
        
        
    }
    override func layoutSubviews() {
        repositionEachCell(scrollView!)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        repositionEachCell(scrollView)
        //keepAddInSide()
        //reposiotion each cell while scrolling
            }
    func keepAddInSide(){
        scrollView!.bringSubviewToFront(addTabB!)
        let point = scrollView!.convertPoint(addTabB!.center, toView: self)
        if point.x > scrollView!.frame.width - (35 *  0.5){
            let translate = CGAffineTransformMakeTranslation(-(point.x - (scrollView!.frame.width - (35 *  0.5))), 0)
            addTabB?.transform = translate
        }else{
            addTabB?.transform = CGAffineTransformIdentity
        }

    }
    func repositionEachCell(scrollView : UIScrollView){
        for cell in cells{
            
            //next the magic happens, well, not really magic, but this is main thing!
            
            
            let point = scrollView.convertPoint(cell.center, toView: self)
            let offset = CGFloat(cells.indexOf(cell)!) * offsetGap!
            let reversedOffset = CGFloat((cells.count - 1) - cells.indexOf(cell)!) * offsetGap!
            if point.x < (cell.frame.width * 0.5) + offset {
                let translationX = ((cell.frame.width * 0.5) - point.x) + offset
                print(cell.center)
                cell.transform = CGAffineTransformMakeTranslation(translationX, 0)
                print(cell.center)
                scrollView.bringSubviewToFront(cell)
        
                
                
            }else if  point.x > scrollView.frame.width - ((cell.frame.width * 0.5) + reversedOffset){
                
                let translationX = (point.x - (scrollView.frame.width - (cell.frame.width * 0.5)) + reversedOffset)
                
                cell.transform = CGAffineTransformMakeTranslation(-translationX, 0)
        
                scrollView.sendSubviewToBack(cell)
            }else{
                //if cell is in the middle
                cell.transform = CGAffineTransformMakeTranslation(0, 0)
                scrollView.bringSubviewToFront(cell)
                }
            }
            
            
        }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Some extensions

public func randomInRange (lower: Int , upper: Int) -> Int {
    return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
}
public func randomString(len : Int) -> NSString {
    let s : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let mut : NSMutableString = NSMutableString(capacity: len)
    for var inde = 0; inde < len; ++inde {
        mut.appendFormat("%C", s.characterAtIndex(Int(arc4random_uniform(UInt32(s.length)))))
    }
    return mut.mutableCopy() as! NSString
}

public let sfMaskBoth : UIViewAutoresizing = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]


class SFCell: UIView {
    
    var line = 0
    var row = 0
    ///Put your stuff in contentView
    var contentView : UIView?
    var label : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        contentView?.autoresizingMask = sfMaskBoth
        addSubview(contentView!)
        label = UILabel(frame: contentView!.bounds)
        label?.clipsToBounds = true
        label?.autoresizingMask = sfMaskBoth
        contentView!.addSubview(label!)
        label?.textAlignment = NSTextAlignment.Center
        label!.textColor = UIColor.whiteColor()
        contentView?.backgroundColor = cellColor
        contentView?.layer.borderColor = cellBorderColor.CGColor
        contentView?.layer.borderWidth = 1
        
    }
    func setUpSize(horizotal : Bool){
        //Autogenerates random size
        ///Change size to the one you need
        
        self.bounds = CGRect(x: 0, y: 0, width: horizotal ? CGFloat(randomInRange(50, upper: 200)) : frame.width, height: horizotal ? frame.height : CGFloat(randomInRange(50, upper: 200)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}