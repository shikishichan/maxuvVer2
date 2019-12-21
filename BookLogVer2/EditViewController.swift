//
//  EditViewController.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/12/06.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bookshelfs.count
    }
    
    
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var titleEdit: UITextField!
    @IBOutlet weak var authorEdit: UITextField!
//    @IBOutlet weak var placeEdit: UITextField!
    
    var selectedSection = String()
    var selectedRow = Int()
    
    var recieveData = Book.init(title: "", place: "", author: "", id: 0)
    var recieveDataId = Int()
    
    var returnData = Book.init(title: "", place: "", author: "", id: 0)
    
    var books = [Book]()
    var bookshelfs = [BookShelf]()
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        load()
        
        recieveData = books.filter({$0.id == recieveDataId})[0]

        titleEdit.text = recieveData.title
//        placeEdit.text = recieveData.place
        selectedSection = recieveData.place
        authorEdit.text = recieveData.author
        place.text = recieveData.place
        place.font = UIFont(name: "Menlo", size: 50)
        place.textAlignment = .center
        place.numberOfLines = 1
        place.adjustsFontSizeToFitWidth = true
        // pickerの初期値を設定したかった
//        sectionPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        returnData = Book.init(title: titleEdit.text!, place: selectedSection, author: authorEdit.text!, id: recieveDataId)
        
        books[recieveDataId] = returnData
        
        save(books: books)

    }
    
    func load(){
        guard let encodedBookData = UserDefaults.standard.array(forKey: BookKeyVer2) as? [Data] else {
            print("userdefaultsに本データが保存されていません")
            return
        }
        books = encodedBookData.map { try! JSONDecoder().decode(Book.self, from: $0) }
        
        guard let encodedBookShelfData = UserDefaults.standard.array(forKey: BookShelfKeyVer2) as? [Data] else {
            print("userdefaultsに本棚データが保存されていません")
            return
        }
        bookshelfs = encodedBookShelfData.map { try! JSONDecoder().decode(BookShelf.self, from: $0) }
    }
    
    func save(books: [Book]) {
        
        let bookData = books.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(bookData, forKey: BookKeyVer2)
        
        //保管場所変更時のnumofbookの更新
        for (index, element) in bookshelfs.enumerated(){
            bookshelfs[index].numofbook = books.filter({$0.place == element.name}).count
        }
        
        let bookShelfData = bookshelfs.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(bookShelfData, forKey: BookShelfKeyVer2)
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
        
        selectedSection = bookshelfs[row].name
        selectedRow = row
    }

}
