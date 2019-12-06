//
//  SecondViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit
import CoreData

class PlaceViewController: UIViewController {
    
    var mySections = [String]()

    var ShelfArray: [BookShelfs] = []
    var ManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var Shelfnum: Int = 0
    var placeid: Int16 = 0
    
    @IBOutlet weak var placeTextField: UITextField!
    
    @IBAction func placeAddBotton(_ sender: Any) {
        let ShelfObject = BookShelfs(context: self.ManagedObjectContext)
        ShelfObject.id = placeid
        ShelfObject.name = placeTextField.text!
        self.ShelfArray.append(ShelfObject)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let AllShelfget = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        do{
            ShelfArray = try ManagedObjectContext.fetch(AllShelfget)as! [BookShelfs]
        }catch{
            print("Core shelf get error.")
        }
        placeid += 1
        
        
        mySections.append(placeTextField.text!)
        placeTextField.text = ""
        UserDefaults.standard.set( mySections, forKey: "SectionList" )
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if UserDefaults.standard.object(forKey: "SectionList") != nil{
            mySections = UserDefaults.standard.object(forKey: "SectionList") as! [String]
        }
        
        let AllShelfs = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        do{
          ShelfArray = try ManagedObjectContext.fetch(AllShelfs) as! [BookShelfs]
        }catch{
          print("Shelf Fetch Error.")
        }
        Shelfnum = ShelfArray.count
        placeid = Int16(ShelfArray[Shelfnum - 1].id) + 1
        
    }

}
