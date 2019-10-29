//
//  FirstViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class FirstViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var view_table: UITableView!
    
    var mySections = [String]()
    var twoDimArray = [[String]]()
    var selectedClass = ""
    var selectedBook = ""
    var booklist:[Book] = []
    var view_list:[[Book]] = []
    var book_shelf_list:[BookShelf] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view_table.register (UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier:"reuse_cell")
        
        let get_api = GetDataFromApi()
        
        get_api.get_book_shelf(completion: {returnData in
            self.book_shelf_list = returnData
            
            for _ in self.book_shelf_list{
                self.view_list.append([])
            }

            //DispatchQueue.main.async {
            //    self.mytable.reloadData()
            //}
        })
        
        get_api.get_book(completion: {returnData in
            self.booklist = returnData
            
            var count:Int = 0
            
            for i in self.book_shelf_list{
                for j in self.booklist{
                    if i.id == j.place_id{
                        self.view_list[count].append(j)
                    }
                }
                count += 1
            }
            
            DispatchQueue.main.async {
                self.view_table.reloadData()
            }
        })
        
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return book_shelf_list.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return view_list[section].count
       }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return book_shelf_list[section].name
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse_cell", for: indexPath) as! TableViewCell
        cell.control_cell(book: view_list[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClass = book_shelf_list[indexPath.section].name
        selectedBook = view_list[indexPath.section][indexPath.row].title
        
        print(selectedBook)
    }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
      
}

