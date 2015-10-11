//
//  SFBookmarkCell.swift
//  Starfly
//
//  Created by Arturs Derkintis on 9/18/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit


class SFHomeCell: UICollectionViewCell {
    var label : UILabel?
    var imageView : UIImageView?
    var blur : UIVisualEffectView?
    var delete : SFButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = SFView(frame: bounds)
        view.layer.cornerRadius = 10
        addSubview(view)
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
      
        label = UILabel(frame: CGRect(x: 10, y: frame.height - frame.height * 0.16, width: frame.width - 20, height: frame.height * 0.16))
        label?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        
        label?.textColor = .whiteColor()
        label!.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        label!.layer.shadowOffset = CGSize(width: 0, height: lineWidth())
        label!.layer.shadowRadius = 0
        label!.layer.shadowOpacity = 1.0
        label!.layer.rasterizationScale = UIScreen.mainScreen().scale
        label!.layer.shouldRasterize = true
        label?.textAlignment = NSTextAlignment.Center
     
        addSubview(label!)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: frame.height - frame.height * 0.16))
        imageView?.backgroundColor = UIColor.whiteColor()
        imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: CGRectInset(bounds, 0, 0), byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight], cornerRadii: CGSize(width: 8, height: 8)).CGPath
        imageView?.layer.mask = shape
        imageView?.layer.masksToBounds = true
        imageView?.image = UIImage(named: "test2.jpg")
        addSubview(imageView!)
        delete = SFButton(type: UIButtonType.Custom)
        delete?.frame = CGRect(x: frame.width - 11, y: -6, width: 20, height: 20)
        delete?.setImage(UIImage(named: Images.closeTab), forState: UIControlState.Normal)
        delete?.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        delete?.layer.cornerRadius = delete!.frame.size.height * 0.5
        delete?.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        delete?.layer.shadowOffset = CGSize(width: 0, height: 0)
        delete?.layer.shadowRadius = 2
        delete?.layer.shadowOpacity = 1.0
        delete?.layer.rasterizationScale = UIScreen.mainScreen().scale
        delete?.layer.shouldRasterize = true
        delete?.transform = CGAffineTransformMakeScale(0.01, 0.01)
        addSubview(delete!)
    }
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(CGRect(x: 0, y: -20, width: frame.width + 20, height: frame.height + 20), point){
            
            return true
        }
        return false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SFSearchTableCell: UITableViewCell {
    var label : UILabel?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label = UILabel(frame: CGRect.zero)
        label?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightRegular)
        backgroundColor = UIColor.clearColor()
        label?.textColor = UIColor.blackColor()
        label!.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.8).CGColor
        label!.layer.shadowOffset = CGSize(width: 0, height: lineWidth())
        label!.layer.shadowRadius = 0
        label!.layer.shadowOpacity = 1.0
        label!.layer.rasterizationScale = UIScreen.mainScreen().scale
        label!.layer.shouldRasterize = true
        label?.textAlignment = NSTextAlignment.Left
        addSubview(label!)
        label?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(self)
            make.left.right.equalTo(50)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: BOOKMARKS CELL

class SFBookmarksCell : SWTableViewCell{
    var titleLabel : UILabel?
    var urlLabel   : UILabel?
    var icon   : UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clearColor()
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel?.textColor = UIColor.blackColor()
        titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        contentView.addSubview(titleLabel!)
        titleLabel?.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(50)
            make.height.equalTo(self.contentView).multipliedBy(0.5)
            make.top.equalTo(4)
            make.right.equalTo(0)
        }
        urlLabel = UILabel(frame: CGRect.zero)
        urlLabel?.textColor = UIColor.grayColor()
        urlLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        contentView.addSubview(urlLabel!)
        urlLabel!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(50)
            make.height.equalTo(self.contentView).multipliedBy(0.5)
            make.top.equalTo(25)
            make.right.equalTo(0)
            
        }
        
        icon = UIImageView(frame: CGRect.zero)
        contentView.addSubview(icon!)
        icon?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(30)
            make.top.left.equalTo(10)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: HISTORY's Stuff

class SFHistoryCell : SWTableViewCell{
    var titleLabel : UILabel?
    var urlLabel   : UILabel?
    var icon   : UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clearColor()
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel?.textColor = UIColor.blackColor()
        titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        contentView.addSubview(titleLabel!)
        titleLabel?.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(50)
            make.height.equalTo(self.contentView).multipliedBy(0.5)
            make.top.equalTo(4)
            make.right.equalTo(0)
        }
        urlLabel = UILabel(frame: CGRect.zero)
        urlLabel?.textColor = UIColor.grayColor()
        urlLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        contentView.addSubview(urlLabel!)
        urlLabel!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(50)
            make.height.equalTo(self.contentView).multipliedBy(0.5)
            make.top.equalTo(25)
            make.right.equalTo(0)
            
        }
        
        icon = UIImageView(frame: CGRect.zero)
        contentView.addSubview(icon!)
        icon?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(30)
            make.top.left.equalTo(10)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class SFHistoryHeader : UITableViewHeaderFooterView{
    var dayLabel : UILabel?
    var csView : SFView?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        csView = SFView(frame: bounds)
        
        csView!.userInteractionEnabled = false
        
        addSubview(csView!)
        csView?.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(self)
            make.center.equalTo(self)
        }
        
        dayLabel = UILabel(frame: CGRect.zero)
        dayLabel?.textColor = UIColor.whiteColor()
        dayLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightMedium)
        addSubview(dayLabel!)
        dayLabel?.snp_makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(0)
            make.left.equalTo(35)
            make.width.equalTo(self)
            
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
