//
//  Book.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/11/22.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import Foundation

class Book: Codable, Equatable{
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.title == rhs.title && lhs.place == rhs.place && lhs.author == rhs.author
    }
    
    var title: String
    var place: String
    var author: String
    
    init(title:String, place:String, author:String) {
        self.title = title
        self.place = place
        self.author = author
    }
}

class BookShelf: Codable{
    var name: String
    var numofbook: Int
    
    init(name:String, numofbook:Int) {
        self.name = name
        self.numofbook = numofbook
    }
}
