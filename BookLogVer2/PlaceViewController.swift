//
//  SecondViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var mySections = [String]()
    
    var bookshelfs = [BookShelf]()
    let BookShelfKey = "shelfkey"

    
    @IBOutlet weak var placeTextField: UITextField!
    
    @IBAction func placeAddBotton(_ sender: Any) {
        let newbookshelf = BookShelf.init(name: placeTextField.text!, numofbook: 0)
        bookshelfs.append(newbookshelf)
        placeTextField.text = ""
        save(bookshelfs: bookshelfs)
                        
        sectionTableView.reloadData()
    }
    

    @IBOutlet weak var sectionTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        load()
    }
    
    func save(bookshelfs:[BookShelf]){
        let bookShelfData = bookshelfs.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(bookShelfData, forKey: BookShelfKey)
    }
    
    func load(){
        guard let encodedBookShelfData = UserDefaults.standard.array(forKey: BookShelfKey) as? [Data] else {
            print("userdefaultsに本棚データが保存されていません")
            return
        }
        bookshelfs = encodedBookShelfData.map { try! JSONDecoder().decode(BookShelf.self, from: $0) }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookshelfs.count
        
     }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = bookshelfs[indexPath.row].name
        //cell.textLabel!.font = UIFont(name: "Arial", size: 20)
        
        return cell
    }

}
