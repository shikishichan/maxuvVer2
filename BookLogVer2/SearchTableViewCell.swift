//
//  SearchTableViewCell.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/11/22.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewCell: UITableViewCell {
    
    var ManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var PlaceLabel: UILabel!
    
    func controlCell(book:Books, order:String) {
        self.TitleLabel.text = book.title_name!
        if order == "保管場所順"{
            self.PlaceLabel.text = ""
        }else if order == "50音順"{
            let context:NSManagedObjectContext = ManagedObjectContext
            let shelfcatcher = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
            shelfcatcher.predicate = NSPredicate(format:"id = %D",book.place_id)
            let Finder = try! context.fetch(shelfcatcher) as! [BookShelfs]
            
            self.PlaceLabel.text = Finder[0].name!
        }else if order == "著者順"{
            self.PlaceLabel.text = book.author_name
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
