//
//  HistoryHit+CoreDataProperties.swift
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

extension HistoryHit {

    @NSManaged var date: NSDate?
    @NSManaged var faviconPath: String?
    @NSManaged var time: String?
    @NSManaged var titleOfIt: String?
    @NSManaged var urlOfIt: String?
    @NSManaged var arrangeIndex: NSNumber?

}
