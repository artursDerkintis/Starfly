//
//  SFHistoryCell.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/12/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFHistoryCell : SWTableViewCell {
	var titleLabel : UILabel?
	var urlLabel : UILabel?
	var icon : UIImageView?

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .clearColor()
        icon = UIImageView(frame: CGRect.zero)
        contentView.addSubview(icon!)
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(1)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(-1)
        }
        contentView.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        icon?.snp_makeConstraints {(make) -> Void in
            make.width.height.equalTo(30)
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(10)
        }
		titleLabel = UILabel(frame: CGRect.zero)
		titleLabel?.textColor = UIColor.blackColor()
		titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
		contentView.addSubview(titleLabel!)
		titleLabel?.snp_makeConstraints {(make) -> Void in
			make.left.equalTo(self.icon!.snp_rightMargin).offset(20)
			make.height.equalTo(self.contentView).multipliedBy(0.5)
			make.top.equalTo(4)
			make.right.equalTo(0)
		}
		urlLabel = UILabel(frame: CGRect.zero)
		urlLabel?.textColor = UIColor.grayColor()
		urlLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
		contentView.addSubview(urlLabel!)
		urlLabel!.snp_makeConstraints {(make) -> Void in
			make.left.equalTo(self.icon!.snp_rightMargin).offset(20)
			make.bottom.equalTo(-4)
			make.top.equalTo(25)
			make.right.equalTo(0)
		}


	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

class SFHistoryHeader : UITableViewHeaderFooterView {
    
	var dayLabel : UILabel?
	var csView : SFView?
    
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
        
		csView = SFView(frame: bounds)
		csView!.userInteractionEnabled = false
		addSubview(csView!)
        
		csView?.snp_makeConstraints {(make) -> Void in
			make.top.equalTo(0)
            make.bottom.equalTo(-1)
            make.right.left.equalTo(0)
			make.center.equalTo(self)
		}

		dayLabel = UILabel(frame: CGRect.zero)
        dayLabel?.textAlignment = .Center
		dayLabel?.textColor = UIColor.whiteColor()
		dayLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
		addSubview(dayLabel!)
        
		dayLabel?.snp_makeConstraints {(make) -> Void in
			make.top.bottom.equalTo(0)
			make.left.equalTo(0)
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

class SFHistoryCellSearch : SWTableViewCell {
    var titleLabel : UILabel?
    var urlLabel : UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clearColor()
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(1)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(-1)
        }
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel?.textColor = UIColor.blackColor()
        titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        contentView.addSubview(titleLabel!)
        titleLabel?.snp_makeConstraints {(make) -> Void in
            make.left.equalTo(20)
            make.height.equalTo(self.contentView).multipliedBy(0.5)
            make.top.equalTo(4)
            make.right.equalTo(0)
        }
        urlLabel = UILabel(frame: CGRect.zero)
        urlLabel?.textColor = UIColor.grayColor()
        urlLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        contentView.addSubview(urlLabel!)
        urlLabel!.snp_makeConstraints {(make) -> Void in
            make.left.equalTo(20)
            make.bottom.equalTo(-4)
            make.top.equalTo(25)
            make.right.equalTo(0)
        }
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
