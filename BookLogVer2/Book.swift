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
    
    init(title:String, place:String) {
        self.title = title
        self.place = place
    }
}
