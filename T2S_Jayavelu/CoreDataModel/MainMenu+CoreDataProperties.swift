//
//  MainMenu+CoreDataProperties.swift
//  T2S_Jayavelu
//
//  Created by JAYAVELU R on 28/06/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//
//

import Foundation
import CoreData


extension MainMenu {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainMenu> {
        return NSFetchRequest<MainMenu>(entityName: "MainMenu")
    }

    @NSManaged public var menuname: String?
    @NSManaged public var submenu: NSSet?

}

// MARK: Generated accessors for submenu
extension MainMenu {

    @objc(addSubmenuObject:)
    @NSManaged public func addToSubmenu(_ value: SubMenu)

    @objc(removeSubmenuObject:)
    @NSManaged public func removeFromSubmenu(_ value: SubMenu)

    @objc(addSubmenu:)
    @NSManaged public func addToSubmenu(_ values: NSSet)

    @objc(removeSubmenu:)
    @NSManaged public func removeFromSubmenu(_ values: NSSet)

}

