//
//  SearchTableViewCell.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/11/22.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var PlaceLabel: UILabel!
    
    func controlCell(book:Books, order:String, datacontroll:DataController) {
        let place = datacontroll.searchShelf(id: book.place_id)
        self.TitleLabel.text = book.title
        if order == "保管場所順"{
            self.PlaceLabel.text = ""
        }else if order == "50音順"{
            self.PlaceLabel.text = place[0].name!
        }else if order == "著者順"{
            self.PlaceLabel.text = book.author
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
