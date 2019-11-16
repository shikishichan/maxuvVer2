//
//  book_shelf.swift
//  カスタムセルのテスト
//
//  Created by Masaki Sakugawa on 2019/10/28.
//  Copyright © 2019 Masaki Sakugawa. All rights reserved.
//

import Foundation

class BookShelf:Codable{
    var id:Int
    var name:String
}

class BookShelfList:Codable{
    var entries:[BookShelf]
}
