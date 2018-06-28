//
//  AddOn+CoreDataProperties.swift
//  T2S_Jayavelu
//
//  Created by JAYAVELU R on 28/06/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//
//

import Foundation
import CoreData


extension AddOn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddOn> {
        return NSFetchRequest<AddOn>(entityName: "AddOn")
    }

    @NSManaged public var adonid: String?
    @NSManaged public var adonname: String?

}
