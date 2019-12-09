//
//  DetailViewController.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/12/01.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var bookData = Book.init(title: "", place: "", author: "", id: 0)
    var bookDataId = Int()
    
    var books = [Book]()
    var bookshelfs = [BookShelf]()
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    
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
        label.text = "Title  :  \(bookData.title) \n\nPlace  :  \(bookData.place) \n\nauthor  :  \(bookData.author)"
        print("detail")
        print(bookData.author)
        print(bookData.place)

    }
    
    func load(){
        guard let encodedBookData = UserDefaults.standard.array(forKey: BookKeyVer2) as? [Data] else {
            print("userdefaultsに本データが保存されていません")
            return
        }
        books = encodedBookData.map { try! JSONDecoder().decode(Book.self, from: $0) }
    }
    

}
