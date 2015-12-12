//
//  SFFavoritesController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/10/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFFavoritesController: UIViewController {

	var collectionView : UICollectionView!
	var favoritesProvider : SFFavoritesProvider!
	override func viewDidLoad() {
		super.viewDidLoad()
		favoritesProvider = SFFavoritesProvider()
		let layout = LXReorderableCollectionViewFlowLayout()

		layout.isEditable = true

		layout.minimumLineSpacing = 15
		layout.minimumInteritemSpacing = 15
		layout.itemSize = CGSizeMake(175, 123)
		collectionView = UICollectionView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height), collectionViewLayout: layout)
		collectionView.registerClass(SFFavoritesCell.self, forCellWithReuseIdentifier: homeCell)
		collectionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		collectionView.contentInset = UIEdgeInsets(top: 40, left: 40, bottom: 120, right: 40)
		collectionView.showsVerticalScrollIndicator = false
		collectionView.clipsToBounds = true
		collectionView.backgroundColor = .clearColor()
		addSubviewSafe(collectionView)

		favoritesProvider.collectionView = collectionView

		load()
		// Do any additional setup after loading the view.
	}

	func load() {
		favoritesProvider.loadData()
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}
