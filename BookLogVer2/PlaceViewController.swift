//
//  SecondViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit
import CoreData

class PlaceViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    
    var bookshelfs = [BookShelfs]()
    let BookShelfKeyVer2 = "shelfkeyver2"
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var id:Int16 = 0
    
    @IBOutlet weak var placeTextField: UITextField!
    
    @IBAction func placeAddBotton(_ sender: Any) {
        let shelfObject = BookShelfs(context: context)
        shelfObject.id = id
        shelfObject.name = placeTextField.text
        bookshelfs.append(shelfObject)
        
        //保存する
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
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
        do {
            let shelfRequest: NSFetchRequest<BookShelfs> = BookShelfs.fetchRequest()
            bookshelfs = try context.fetch(shelfRequest)
        } catch {
            print("Error")
        }
        if !bookshelfs.isEmpty{
            id = bookshelfs.last!.id + 1
        }
        print("-----------------")
        print(bookshelfs)
        print("-----------------")
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
