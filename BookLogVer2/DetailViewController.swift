//
//  DetailViewController.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/12/01.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var bookData = Books()
    var bookDataId = Int()
    
    var books = [Books]()
    var bookshelfs = [BookShelfs]()
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    
    var ManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var label: UILabel!
    @IBAction func toEdit(_ sender: Any) {
        
        performSegue(withIdentifier: "toEdit",sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let EditVC: EditViewController = (segue.destination as? EditViewController)!
//        EditVC.recieveData = bookData
        EditVC.recieveDataId = bookDataId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        label.text = "Title  :  \(bookData.title) \n\nPlace  :  \(bookData.place) \n\nauthor  :  \(bookData.author)"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        load()
        
        bookData = books.filter({$0.id == bookDataId})[0]
        
        let context:NSManagedObjectContext = ManagedObjectContext
        let shelfcatcher = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        shelfcatcher.predicate = NSPredicate(format:"id = %D",bookData.place_id)
        let Finder = try! context.fetch(shelfcatcher) as! [BookShelfs]
        
        label.text = "Title  :  \(bookData.title_name!) \n\nPlace  :  \(Finder[0].name!) \n\nauthor  :  \(bookData.author_name!)"
        print("detail")
        print(bookData.author_name!)
        print(bookData.place_id)

    }
    
    func load(){
    }
    

}
