//
//  DataController.swift
//  BookLogVer2
//
//  Created by masami on 2019/12/15.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import Foundation
import CoreData

class DataController: NSObject{
    var persistentContainer: NSPersistentContainer!
    
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "BookDB")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
    
    var BookObject: Books!
    
    func createBook() -> Books{
        let context = persistentContainer.viewContext
        let books = NSEntityDescription.insertNewObject(forEntityName: "Books", into: context) as! Books
        return books
    }
    
    func createShelf() -> BookShelfs{
        let context = persistentContainer.viewContext
        let bookshelfs = NSEntityDescription.insertNewObject(forEntityName: "BookShelfs", into: context) as! BookShelfs
        return bookshelfs
    }
    
    func fetchBooks() -> [Books] {
        let context = persistentContainer.viewContext
        let BooksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")

        do {
            let fetchedBooks = try context.fetch(BooksFetch) as! [Books]
            return fetchedBooks
        } catch {
            fatalError("Failed to fetch Books: \(error)")
        }

        return []
    }
    
    func fetchShelfs() -> [BookShelfs] {
        let context = persistentContainer.viewContext
        let ShelfsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        do {
            let fetchedShelfs = try context.fetch(ShelfsFetch) as! [BookShelfs]
            return fetchedShelfs
        } catch {
            fatalError("Failed to fetch Books: \(error)")
        }

        return []
    }
    
    func addBook(id:Int16, title:String, author:String, place:Int16, number:Int16){
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Books", in: context)
        let book = Books(entity: entity!, insertInto: context)
        book.id = id
        book.title = title
        book.author = author
        book.place_id = place
        book.number = number
        do{
            try context.save()
        }catch{
            print("Add Book error.")
        }
    }
    
    func addShelf(id:Int16, name:String){
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "BookShelfs", in: context)
        let shelf = BookShelfs(entity: entity!, insertInto: context)
        shelf.id = id
        shelf.name = name
        do{
            try context.save()
        }catch{
            print("Add Shelf error.")
        }
    }
    
    func searchBooks(num:Int, conditionNum:Int16, conditionStr:String) -> [Books]{
        let context = persistentContainer.viewContext
        let BooksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        if num == 0{
            BooksFetch.predicate = NSPredicate(format: "id == %D", conditionNum)
        }else if(num == 1){
            BooksFetch.predicate = NSPredicate(format: "title_name = %@", conditionStr)
        }else if(num == 2){
            BooksFetch.predicate = NSPredicate(format: "place_id = %D", conditionNum)
        }
        do {
            let fetchedBooks = try context.fetch(BooksFetch) as! [Books]
            return fetchedBooks
        } catch {
            fatalError("Failed to fetch Books: \(error)")
        }

        return []
    }
    
    func whereBook(title:String) -> [BookShelfs]{
        let context = persistentContainer.viewContext
        let BooksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        BooksFetch.predicate = NSPredicate(format: "title_name = %@", title)
        var fetchedBooks: [Books] = []
        do {
            fetchedBooks = try context.fetch(BooksFetch) as! [Books]
        } catch {
            fatalError("Failed to fetch Books: \(error)")
        }
        if fetchedBooks.count == 0{
            return []
        }
        let ShelfsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        ShelfsFetch.predicate = NSPredicate(format: "id = %D", fetchedBooks[0].place_id)
        var fetchedShelfs: [BookShelfs] = []
        do {
            fetchedShelfs = try context.fetch(ShelfsFetch) as! [BookShelfs]
        } catch {
            fatalError("Failed to fetch Books: \(error)")
        }
        return fetchedShelfs
    }
}
