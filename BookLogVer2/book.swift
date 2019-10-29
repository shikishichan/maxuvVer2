//
//  book.swift
//  カスタムセルのテスト
//
//  Created by Masaki Sakugawa on 2019/10/27.
//  Copyright © 2019 Masaki Sakugawa. All rights reserved.
//

import Foundation

class Book: Codable{
    
    var id:Int
    var title:String
    var place_id:Int
    
}

class BookList: Codable{
    var entries:[Book]
}
