//
//  DetailViewController.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/12/01.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var hoge = String()
    var bookData = Book.init(title: "", place: "", author: "")
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Title  :  \(bookData.title) \n\nPlace  :  \(bookData.place) \n\nauthor  :  \(bookData.author)"

        // Do any additional setup after loading the view.
    }
    

}
