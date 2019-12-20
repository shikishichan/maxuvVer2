//
//  AddController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit
import CoreData


class AddController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedSection = BookShelfs()
    var alertController: UIAlertController!
    
    var alertTitle = ""
    var alertMessage = ""
    
    var books = [Books]()
    var bookshelfs = [BookShelfs]()
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var wherelist = [Books]()
    var id: Int16 = 0

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
        
        do {
            let whereRequest: NSFetchRequest<Books> = Books.fetchRequest()
            whereRequest.predicate = NSPredicate(format: "title == %@",TitleTextField.text!)
            wherelist = try context.fetch(whereRequest)
        } catch {
            print("Error")
        }
        
        print(selectedSection)
        
        if !wherelist.isEmpty{
            let daburiplace = books[0].bookshelfs!
            //ダブりがあった時
            alertTitle = "警告！\n[\(daburiplace.name!)]に「\(TitleTextField.text!)」は既に登録されています。"
            alertMessage = "登録しますか？"
            alert(alertTitle: alertTitle, alertMessage: alertMessage, isEntry: true, isCancel: true)
            return
        }
        touroku(id:self.id, title: self.TitleTextField.text!, shelf: self.selectedSection, author: self.AuthorTextField.text!)
    }
    
    func alert(alertTitle:String, alertMessage:String, isEntry:Bool, isCancel:Bool){
        alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //OKボタンが押された時の処理
            if isEntry{
                self.touroku(id:self.id, title: self.TitleTextField.text!, shelf: self.selectedSection, author: self.AuthorTextField.text!)
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
    
    func touroku(id:Int16, title:String, shelf:BookShelfs, author:String) {
        let number = shelf.books!.count
        let bookObject = Books(context: context)
        bookObject.id = id
        bookObject.title = title
        bookObject.author = author
        bookObject.number = Int16(number)
        bookObject.bookshelfs = shelf

        //保存する
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        TitleTextField.text = ""
        AuthorTextField.text = ""
        load()
    }
    
    @IBOutlet weak var sectionLabel: UILabel!
    
    @IBOutlet weak var sectionSelect: UIPickerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionSelect.delegate = self
        sectionSelect.dataSource = self
        
        load()
        if !bookshelfs.isEmpty{
            selectedSection = bookshelfs[0]
        }
        for i in books{
            print(i)
        }
        for j in bookshelfs{
            print(j)
        }
    }
    
    func load(){
        do {
            let shelfRequest: NSFetchRequest<BookShelfs> = BookShelfs.fetchRequest()
            bookshelfs = try context.fetch(shelfRequest)
        } catch {
            print("Error")
        }
        do {
            let bookRequest: NSFetchRequest<Books> = Books.fetchRequest()
            books = try context.fetch(bookRequest)
        } catch {
            print("Error")
        }
        if bookshelfs.isEmpty{
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
        if !books.isEmpty{
            id = books.last!.id + 1
        }
        print("-----------------")
        print(books)
        print("-----------------")
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
        
        selectedSection = bookshelfs[row]
    }
        
    @IBAction func camera(_ sender: Any) {
        let CameraViewController = self.storyboard?.instantiateViewController(withIdentifier: "camera2") as! CameraViewController
        self.present(CameraViewController, animated: true, completion: nil)
    }
}
