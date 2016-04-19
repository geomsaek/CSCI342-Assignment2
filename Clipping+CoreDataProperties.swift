//
//  Clipping+CoreDataProperties.swift
//  ass2
//
//  Created by Matthew Saliba on 19/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Clipping {

    @NSManaged var date: NSDate?
    @NSManaged var images: String?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var collections: Collection?

}
