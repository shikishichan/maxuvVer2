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
    
    func controlCell(book:Book) {
        self.TitleLabel.text = book.title
        self.PlaceLabel.text = book.place
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
