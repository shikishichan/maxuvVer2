//
//  SecondViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    
    var bookshelfs = [BookShelfs]()
    let BookShelfKeyVer2 = "shelfkeyver2"
    
    var datacontroll = DataController(){}
    
    var shelfnum: Int16 = 0
    
    @IBOutlet weak var placeTextField: UITextField!
    
    @IBAction func placeAddBotton(_ sender: Any) {

        datacontroll.addShelf(id: shelfnum, name: placeTextField.text!)
        placeTextField.text = ""

        load()
        sectionTableView.reloadData()
    }
    

    @IBOutlet weak var sectionTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        load()
    }
    
    
    
    func load(){
        bookshelfs = datacontroll.fetchShelfs()
        shelfnum = Int16(bookshelfs.count)
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
