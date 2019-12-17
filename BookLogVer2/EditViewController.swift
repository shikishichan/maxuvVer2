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
    
    
    @IBOutlet weak var titleEdit: UITextField!
    @IBOutlet weak var authorEdit: UITextField!
//    @IBOutlet weak var placeEdit: UITextField!
    
    var selectedSection = BookShelfs()
    var selectedRow = Int()
    
    var recieveData = Books()
    var recieveDataId = Int16()
    var recieveShelf = BookShelfs()
    
    var returnData = Books()
    
    var books = Books()
    var bookshelfs = [BookShelfs]()
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    
    var datacontroll = DataController(){}
    
    @IBOutlet weak var sectionPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionPicker.delegate = self
        sectionPicker.dataSource = self
        
        load()

        titleEdit.text = recieveData.title
//        placeEdit.text = recieveData.place
        selectedSection = recieveShelf
        authorEdit.text = recieveData.author
        // pickerの初期値を設定したかった
//        sectionPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let DVC: DetailViewController = DetailViewController()
        DVC.bookData = returnData

    }
    
    func load(){
        bookshelfs = datacontroll.fetchShelfs()
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
