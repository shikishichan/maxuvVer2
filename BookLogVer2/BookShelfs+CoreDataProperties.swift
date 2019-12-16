//
//  BookShelfs+CoreDataProperties.swift
//  BookLogVer2
//
//  Created by masami on 2019/12/14.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//
//

import Foundation
import CoreData


extension BookShelfs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookShelfs> {
        return NSFetchRequest<BookShelfs>(entityName: "BookShelfs")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var books: NSSet?

}

// MARK: Generated accessors for books
extension BookShelfs {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Books)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Books)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}
