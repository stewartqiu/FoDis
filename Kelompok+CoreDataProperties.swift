//
//  Kelompok+CoreDataProperties.swift
//  
//
//  Created by SchoolDroid on 12/6/17.
//
//

import Foundation
import CoreData


extension Kelompok {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kelompok> {
        return NSFetchRequest<Kelompok>(entityName: "Kelompok")
    }

    @NSManaged public var nama: String?

}
