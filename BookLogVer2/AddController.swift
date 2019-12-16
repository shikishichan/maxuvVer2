//
//  AddController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit


class AddController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var twoDimArray = [[String]]()
    var selectedSection = ""
    var alertController: UIAlertController!
    
    var alertTitle = ""
    var alertMessage = ""
    
    var books = [Book]()
    var bookshelfs = [BookShelf]()
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    var selectedRow = Int()
    
    var datacontroll = DataController(){}

    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var AuthorTextField: UITextField!
    
    
    @IBAction func TodoAddButton(_ sender: Any) {
        if bookshelfs.isEmpty{
            //保管場所が存在しない時の処理
            alertTitle = "保管場所が作成されていません"
            alertMessage = "保管場所を登録してください"
            alert(alertTitle: alertTitle, alertMessage: alertMessage, isEntry: false, isCancel: false)
            return
        }
        
        if TitleTextField.text! == ""{
            //titleが入力されていない時の処理
            alertTitle = "タイトルが入力されていません"
            alertMessage = "もう一度入力してください"
            alert(alertTitle: alertTitle, alertMessage: alertMessage, isEntry: false, isCancel: false)
            return
        }
        
        if selectedSection == ""{
            selectedSection = bookshelfs[0].name
        }
        
        if books.filter({$0.title == TitleTextField.text!}).count > 0{
            let daburiplace = books.filter({$0.title == TitleTextField.text!})[0].place
            //ダブりがあった時
            alertTitle = "警告！\n[\(daburiplace)]に「\(TitleTextField.text!)」は既に登録されています。"
            alertMessage = "登録しますか？"
            alert(alertTitle: alertTitle, alertMessage: alertMessage, isEntry: true, isCancel: true)
            return
        }
        touroku(title: TitleTextField.text!, place: selectedSection, author: AuthorTextField.text!)
    }
    
    func alert(alertTitle:String, alertMessage:String, isEntry:Bool, isCancel:Bool){
        alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //OKボタンが押された時の処理
            if isEntry{
                self.touroku(title: self.TitleTextField.text!, place: self.selectedSection, author: self.AuthorTextField.text!)
            }
        }))
        if isCancel{
            alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler:{
                (action: UIAlertAction!) -> Void in
                //キャンセルボタンが押された時の処理
                self.TitleTextField.text = ""
                
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func touroku(title:String, place:String, author:String) {
        var newId = Int()
        if(books.count == 0){
            newId = 0
        }else{
            newId = books.last!.id+1
        }
        books.append(Book.init(title: title, place: place, author: author, id: newId))
        bookshelfs[selectedRow].numofbook += 1
        save(books: books, bookshelfs: bookshelfs)
        TitleTextField.text = ""
        AuthorTextField.text = ""
    }
    
    @IBOutlet weak var sectionLabel: UILabel!
    
    @IBOutlet weak var sectionSelect: UIPickerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionSelect.delegate = self
        sectionSelect.dataSource = self
        
        load()
    }
    
    func save(books: [Book], bookshelfs: [BookShelf]) {
        
        let bookData = books.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(bookData, forKey: BookKeyVer2)
        
        let bookShelfData = bookshelfs.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(bookShelfData, forKey: BookShelfKeyVer2)
    }
    
    func load(){
        //books = datacontroll.fetchBooks()
        //bookshelfs = datacontroll.fetchShelfs()
        
        guard let encodedBookShelfData = UserDefaults.standard.array(forKey: BookShelfKeyVer2) as? [Data] else {
            print("userdefaultsに本棚データが保存されていません")
            //保管場所が存在しない時の処理
            alertTitle = "保管場所が作成されていません"
            alertMessage = "保管場所を登録してください"
            alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                //OKボタンが押された時の処理
                //何もしない
            }))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        bookshelfs = encodedBookShelfData.map { try! JSONDecoder().decode(BookShelf.self, from: $0) }
        
        guard let encodedBookData = UserDefaults.standard.array(forKey: BookKeyVer2) as? [Data] else {
            print("userdefaultsに本データが保存されていません")
            return
        }
        books = encodedBookData.map { try! JSONDecoder().decode(Book.self, from: $0) }
    }
    
    //表示時のデータ更新
    override func viewWillAppear(_ animated: Bool) {
        
        load()
        sectionSelect.reloadAllComponents()
        
        super.viewWillAppear(animated)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bookshelfs.count
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
        
    @IBAction func camera(_ sender: Any) {
        let CameraViewController = self.storyboard?.instantiateViewController(withIdentifier: "camera2") as! CameraViewController
        self.present(CameraViewController, animated: true, completion: nil)
    }
}
