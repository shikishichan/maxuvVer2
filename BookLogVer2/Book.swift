//
//  Book.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/11/22.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import Foundation

class Book: Codable{
    
    var title: String
    var place: String
    var author: String
    var id : Int
    
    init(title:String, place:String, author:String, id:Int) {
        self.title = title
        self.place = place
        self.author = author
        self.id = id
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
