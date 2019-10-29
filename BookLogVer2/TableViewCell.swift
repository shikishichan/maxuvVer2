//
//  TableViewCell.swift
//  BookLogVer2
//
//  Created by Masaki Sakugawa on 2019/10/29.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    func control_cell(book:Book){
        self.title.text = book.title
    }
    
}
