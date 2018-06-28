//
//  SubMenu+CoreDataProperties.swift
//  T2S_Jayavelu
//
//  Created by JAYAVELU R on 28/06/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//
//

import Foundation
import CoreData


extension SubMenu {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubMenu> {
        return NSFetchRequest<SubMenu>(entityName: "SubMenu")
    }

    @NSManaged public var submenuid: String?
    @NSManaged public var submenuname: String?
    @NSManaged public var addon: NSSet?

}

// MARK: Generated accessors for addon
extension SubMenu {

    @objc(addAddonObject:)
    @NSManaged public func addToAddon(_ value: AddOn)

    @objc(removeAddonObject:)
    @NSManaged public func removeFromAddon(_ value: AddOn)

    @objc(addAddon:)
    @NSManaged public func addToAddon(_ values: NSSet)

    @objc(removeAddon:)
    @NSManaged public func removeFromAddon(_ values: NSSet)

}
