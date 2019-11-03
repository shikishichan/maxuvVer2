//
//  get_book_data.swift
//  カスタムセルのテスト
//
//  Created by Masaki Sakugawa on 2019/10/28.
//  Copyright © 2019 Masaki Sakugawa. All rights reserved.
//

import Foundation

class GetDataFromApi{
    
    
    func get_book(completion: @escaping ([Book])->Void){
        let urlString = "https://booklog-api.herokuapp.com/api/books"

        guard let url = URLComponents(string: urlString) else { return }

        // HTTPメソッドを実行
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            guard let _data = data else { return }

            // JSONデコード
            let booklist = try! JSONDecoder().decode(BookList.self, from: _data)
            
            completion(booklist.entries)
        }
        task.resume()
    }
    
    
    func get_book_shelf(completion: @escaping ([BookShelf])->Void){
        let urlString = "https://booklog-api.herokuapp.com/api/bookshelfs"

        guard let url = URLComponents(string: urlString) else { return }

        // HTTPメソッドを実行
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            guard let _data = data else { return }

            // JSONデコード
            let bookshelflist = try! JSONDecoder().decode(BookShelfList.self, from: _data)
            
            completion(bookshelflist.entries)
        }
        task.resume()
    }

    
}
