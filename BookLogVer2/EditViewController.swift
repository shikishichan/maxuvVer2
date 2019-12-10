//
//  EditViewController.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/12/06.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bookshelfs.count
    }
    
    
    @IBOutlet weak var titleEdit: UITextField!
    @IBOutlet weak var authorEdit: UITextField!
//    @IBOutlet weak var placeEdit: UITextField!
    
    var selectedSection = String()
    var selectedRow = Int()
    
    var recieveData = Books()
    var recieveDataId = Int()
    
    var returnData = Books()
    
    var books = [Books]()
    var bookshelfs = [BookShelfs]()
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    
    var ManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var sectionPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionPicker.delegate = self
        sectionPicker.dataSource = self
        
        load()
        
        recieveData = books.filter({$0.id == recieveDataId})[0]

        titleEdit.text = recieveData.title_name
//        placeEdit.text = recieveData.place
        let context:NSManagedObjectContext = ManagedObjectContext
        let shelfcatcher = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        shelfcatcher.predicate = NSPredicate(format:"id = %D",recieveData.place_id)
        let Finder = try! context.fetch(shelfcatcher) as! [BookShelfs]
        selectedSection = Finder[0].name!
        authorEdit.text = recieveData.author_name
        // pickerの初期値を設定したかった
//        sectionPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //returnData = Books.init(title: titleEdit.text!, place: selectedSection, author: authorEdit.text!, id: recieveDataId)
        returnData = Books()
        returnData.title_name = titleEdit.text!
        returnData.author_name = authorEdit.text!
        let context:NSManagedObjectContext = ManagedObjectContext
        let bookcatcher = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        bookcatcher.predicate = NSPredicate(format:"id = %@",selectedSection)
        let Catcher = try! context.fetch(bookcatcher) as! [BookShelfs]
        
        books[recieveDataId] = returnData
        
        let DVC: DetailViewController = DetailViewController()
        DVC.bookData = returnData
        print("edit")
        print("\(books[recieveDataId].place_id),\(books[recieveDataId].author_name!)")

    }
    
    func load(){
        
    }
        
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return bookshelfs[row].name
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        selectedSection = bookshelfs[row].name!
        selectedRow = row
    }

}
