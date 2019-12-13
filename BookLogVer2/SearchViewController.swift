//
//  SearchViewController.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/11/22.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var books = [Book]()
    let BookKey = "bookkey"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ReUseCell", for: indexPath) as! SearchTableViewCell
        Cell.controlCell(book: books[indexPath.row], order: "50音順")
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
        guard let encodedBookData = UserDefaults.standard.array(forKey: BookKey) as? [Data] else {
            print("userdefaultsに本データが保存されていません")
            return
        }
        books = encodedBookData.map { try! JSONDecoder().decode(Book.self, from: $0) }
        
        
        //50音順
        books = books.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        
    }

}
