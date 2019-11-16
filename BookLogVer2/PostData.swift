//
//  PostData.swift
//  BookLogVer2
//
//  Created by Masaki Sakugawa on 2019/11/06.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import Foundation

class PostData{
    
    func post_book(data:Book){

        let url = URL(string: "https://booklog-api.herokuapp.com/api/books")!

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"


        do {
            request.httpBody = try JSONEncoder().encode(data)
            
        } catch let error {

            print(error.localizedDescription)
        }
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    
    func post_shelf(data:BookShelf){

        let url = URL(string: "https://booklog-api.herokuapp.com/api/bookshelfs")!

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"


        do {
            request.httpBody = try JSONEncoder().encode(data)
            
        } catch let error {

            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

}
