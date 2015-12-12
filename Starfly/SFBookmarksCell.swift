//
//  SFBookmarksCell.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/12/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFBookmarksCell : SWTableViewCell {
	var titleLabel : UILabel?
	var urlLabel : UILabel?
	var icon : UIImageView?

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .clearColor()
		titleLabel = UILabel(frame: CGRect.zero)
		titleLabel?.textColor = UIColor.blackColor()
		titleLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
		contentView.addSubview(titleLabel!)
		titleLabel?.snp_makeConstraints {(make) -> Void in
			make.left.equalTo(50)
			make.height.equalTo(self.contentView).multipliedBy(0.5)
			make.top.equalTo(4)
			make.right.equalTo(0)
		}
		urlLabel = UILabel(frame: CGRect.zero)
		urlLabel?.textColor = UIColor.grayColor()
		urlLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
		contentView.addSubview(urlLabel!)
		urlLabel!.snp_makeConstraints {(make) -> Void in
			make.left.equalTo(50)
			make.height.equalTo(self.contentView).multipliedBy(0.5)
			make.top.equalTo(25)
			make.right.equalTo(0)

		}

		icon = UIImageView(frame: CGRect.zero)
		contentView.addSubview(icon!)
		icon?.snp_makeConstraints {(make) -> Void in
			make.width.height.equalTo(30)
			make.top.left.equalTo(10)
		}
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

} 