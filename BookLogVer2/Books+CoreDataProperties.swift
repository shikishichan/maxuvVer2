//
//  Books+CoreDataProperties.swift
//  BookLogVer2
//
//  Created by masami on 2019/12/14.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//
//

import Foundation
import CoreData


extension Books {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Books> {
        return NSFetchRequest<Books>(entityName: "Books")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var place_id: Int16
    @NSManaged public var number: Int16
    @NSManaged public var bookshelfs: BookShelfs?

}
