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
    
    private let refreshControl = UIRefreshControl()
    
    @IBAction func unwindPrev(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {

    }
    
    var mySections = [String]()
    var twoDimArray = [[String]]()
    var selectedClass = ""
    var selectedBook = ""
    var booklist:[Book] = []
    var view_list:[[Book]] = []
    var book_shelf_list:[BookShelf] = []
    let get_api = GetDataFromApi()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view_table.register (UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier:"reuse_cell")
        
        view_table.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(FirstViewController.refresh(sender:)), for: .valueChanged)
        
        
        load_data()
        
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
    
    func load_data(){
        let dispatchGroup = DispatchGroup()
        let shelfQueue = DispatchQueue(label: "queue", qos: .userInteractive)
        let bookQueue = DispatchQueue(label: "queue", qos: .userInteractive)
        
        //本と本棚のapiを取得するため、未完了タスクを２つ用意する
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        shelfQueue.async(group: dispatchGroup) {
            self.get_api.get_book_shelf(completion: {returnData in
                self.book_shelf_list = returnData
                
                for _ in self.book_shelf_list{
                    self.view_list.append([])
                }
                dispatchGroup.leave()
                print("shelfDone")
            })
        }
        
        
        bookQueue.async(group: dispatchGroup){
            self.get_api.get_book(completion: {returnData in
                    self.booklist = returnData
                    dispatchGroup.leave()
                    print("bookDone")
            })
        }
        
        //本と本棚両方のapiを取得後リロード
        dispatchGroup.notify(queue: .main) {
            var count:Int = 0
            
            for i in self.book_shelf_list{
                for j in self.booklist{
                    if i.id == j.place_id{
                        self.view_list[count].append(j)
                    }
                }
                count += 1
            }
            print("All Process Done!")
            self.view_table.reloadData()
            
        }

        
    }
    
    @objc func refresh(sender: UIRefreshControl) {

        
        load_data()
        refreshControl.endRefreshing()
        
    }

    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
      
}

