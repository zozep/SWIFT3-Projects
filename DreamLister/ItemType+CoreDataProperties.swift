//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Joseph Park on 11/28/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
