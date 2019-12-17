//
//  DetailViewController.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/12/01.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var bookData = Books()
    var shelfData = [BookShelfs]()
    
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"

    
    var datacontroll = DataController(){}
    
    @IBOutlet weak var label: UILabel!
    @IBAction func toEdit(_ sender: Any) {
        
        performSegue(withIdentifier: "toEdit",sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let EditVC: EditViewController = (segue.destination as? EditViewController)!
//        EditVC.recieveData = bookData
        EditVC.recieveData = bookData
        EditVC.recieveShelf = shelfData[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        label.text = "Title  :  \(bookData.title) \n\nPlace  :  \(bookData.place) \n\nauthor  :  \(bookData.author)"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        load()
        shelfData = datacontroll.searchShelf(id: bookData.place_id)
        
//        label.text = "Title  :  \(bookData.title) \n\nPlace  :  \(bookData.place) \n\nauthor  :  \(bookData.author)"
        label.text = "タイトル  :  \(bookData.title!) \n\n保管場所  :  \(shelfData[0].name!) \n\n著者  :  \(bookData.author!)"

    }
    
    func load(){
    }
    

}
