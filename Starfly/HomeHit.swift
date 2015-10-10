//
//  HomeHit.swift
//  StarflyV2
//
//  Created by Neal Caffrey on 5/1/15.
//  Copyright (c) 2015 Neal Caffrey. All rights reserved.
//

import Foundation
import CoreData
@objc(HomeHit)
class HomeHit: NSManagedObject {

    @NSManaged var arrangeIndex: NSNumber
    @NSManaged var bigImage: String
    @NSManaged var color: NSData
    @NSManaged var favicon: String
    @NSManaged var title: String
    @NSManaged var url: String

}
