//
//  HomeHit+CoreDataProperties.swift
//  Starfly
//
//  Created by Arturs Derkintis on 3/16/16.
//  Copyright © 2016 Starfly. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HomeHit {

    @NSManaged var arrangeIndex: NSNumber?
    @NSManaged var bigImage: String?
    @NSManaged var favicon: String?
    @NSManaged var title: String?
    @NSManaged var url: String?

}
