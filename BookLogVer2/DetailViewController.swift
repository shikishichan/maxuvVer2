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
    var bookDataid = Int16()
    
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var label: UILabel!
    @IBAction func toEdit(_ sender: Any) {
        
        performSegue(withIdentifier: "toEdit",sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let EditVC: EditViewController = (segue.destination as? EditViewController)!
//        EditVC.recieveData = bookData
        EditVC.recieveData = bookData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        label.text = "Title  :  \(bookData.title) \n\nPlace  :  \(bookData.place) \n\nauthor  :  \(bookData.author)"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let changeBookRequest:NSFetchRequest<Books> = Books.fetchRequest()
        changeBookRequest.predicate = NSPredicate(format:"id = %D",bookDataid)
        let changeBookData = try! context.fetch(changeBookRequest)
        if(!changeBookData.isEmpty){
            bookData = changeBookData[0]
        }
        print(bookData)
//        label.text = "Title  :  \(bookData.title) \n\nPlace  :  \(bookData.place) \n\nauthor  :  \(bookData.author)"
        label.text = "タイトル  :  \(bookData.title!) \n\n保管場所  :  \(bookData.bookshelfs!.name!) \n\n著者  :  \(bookData.author!)"

    }

}
