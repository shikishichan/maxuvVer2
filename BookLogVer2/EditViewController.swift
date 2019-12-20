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
    
    var selectedSection = BookShelfs()
    var selectedRow = Int()
    
    var recieveData = Books()
    var recieveDataId = Int()
    
    var returnData = Books()
    
    var books = [Books]()
    var bookshelfs = [BookShelfs]()
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var Booknum: Int16 = 0
    
    @IBOutlet weak var sectionPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionPicker.delegate = self
        sectionPicker.dataSource = self
        
        load()

        titleEdit.text = recieveData.title
//        placeEdit.text = recieveData.place
        selectedSection = recieveData.bookshelfs!
        authorEdit.text = recieveData.author
        // pickerの初期値を設定したかった
//        sectionPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let numRequest:NSFetchRequest<Books> = Books.fetchRequest()
        numRequest.predicate = NSPredicate(format:"bookshelfs.name == %@",selectedSection.name!)
        let numData = try! context.fetch(numRequest)
        changeBook(id: recieveData.id, title: titleEdit.text!, author: authorEdit.text!, number: Int16(numData.count), shelf: selectedSection)
        
        if selectedSection != recieveData.bookshelfs!{
            let justSourRequest:NSFetchRequest<Books> = Books.fetchRequest()
            justSourRequest.predicate = NSPredicate(format:"bookshelfs.name == %@ AND number > %D",recieveData.bookshelfs!,recieveData.number)
            books = try! context.fetch(justSourRequest)
            if(!books.isEmpty){
                for i in books{
                    changeBook(id: i.id, title:i.title!, author:i.author!, number: i.number-1, shelf: i.bookshelfs!)
                }
            }
            let numRequest:NSFetchRequest<Books> = Books.fetchRequest()
            numRequest.predicate = NSPredicate(format:"bookshelfs.name == %@",selectedSection.name!)
            let numData = try! context.fetch(numRequest)
            changeBook(id: recieveData.id, title: titleEdit.text!, author: authorEdit.text!, number: Int16(numData.count), shelf: selectedSection)
        }else{
            changeBook(id: recieveData.id, title: titleEdit.text!, author: authorEdit.text!, number: recieveData.id, shelf: selectedSection)
        }
        print(selectedSection)
        
        let DVC: DetailViewController = DetailViewController()
        DVC.bookDataid = recieveData.id
        
    }
    
    func load(){
        do {
            let shelfRequest: NSFetchRequest<BookShelfs> = BookShelfs.fetchRequest()
            bookshelfs = try context.fetch(shelfRequest)
        } catch {
            print("Error")
        }
        
    }
    
    func changeBook(id:Int16, title:String, author:String, number:Int16, shelf:BookShelfs){
        let changeRequest:NSFetchRequest<Books> = Books.fetchRequest()
        changeRequest.predicate = NSPredicate(format:"id = %D",id)
        let changeData = try! context.fetch(changeRequest)
        if(!changeData.isEmpty){
            changeData[0].title! = title
            changeData[0].author! = author
            changeData[0].number = number
            changeData[0].bookshelfs! = shelf
            do{
                try context.save()
            }catch{
                print(error)
            }
        }
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
        
        selectedSection = bookshelfs[row]
        selectedRow = row
    }

}
