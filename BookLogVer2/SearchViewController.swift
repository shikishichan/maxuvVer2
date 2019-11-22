//
//  SearchViewController.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/11/22.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mySections = [String]()
    var books = [Book]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ReUseCell", for: indexPath) as! SearchTableViewCell
        Cell.controlCell(book: books[indexPath.row])
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    @IBOutlet weak var SearchTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "ReUseCell")

        // Do any additional setup after loading the view.
        load()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "検索"
        navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
        
        SearchTableView.reloadData()
        
    }
    
    func load(){
        if UserDefaults.standard.object(forKey: "SectionList") != nil{
            mySections = UserDefaults.standard.object(forKey: "SectionList") as! [String]
        }
        books = []
        for i in mySections{
            if UserDefaults.standard.object(forKey: i) != nil {
                let x = UserDefaults.standard.object(forKey: i) as! [String]
                for j in x {
                    let book = Book.init(title: j, place: i)
                    books.append(book)
                }
            }
        }
        
        //50音順
        books = books.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        
//        SearchTableView.reloadData()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
