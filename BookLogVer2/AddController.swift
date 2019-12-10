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
    
    var twoDimArray = [[String]]()
    var selectedSection = ""
    var alertController: UIAlertController!
    
    var alertTitle = ""
    var alertMessage = ""
    
    var BookArray: [Books] = []
    var ShelfArray: [BookShelfs] = []
    var ManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var Searchresult: [BookShelfs] = []
    var Booknum: Int = 0
    var idnum: Int16 = 0
    var mySections:[String] = []
    
    var mynum: Int = 0
    var Shelfnum: Int = 0

    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var AuthorTextField: UITextField!
    
    
    @IBAction func TodoAddButton(_ sender: Any) {
        if Shelfnum == 0{
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
            selectedSection = ShelfArray[0].name!
        }
        
        if Booknum == 0{
            alertTitle = "[\(selectedSection)]に「\(TitleTextField.text!)」を登録します。"
            alertMessage = "登録しますか？"
            alert(alertTitle: alertTitle, alertMessage: alertMessage, isEntry: true, isCancel: true)
        }else{
            let context:NSManagedObjectContext = ManagedObjectContext
            let bookcatcher = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
            bookcatcher.predicate = NSPredicate(format:"title_name = %@",TitleTextField.text!)
            let Catcher = try! context.fetch(bookcatcher) as! [Books]
            if Catcher.count != 0{
                //ダブりがあった時
                let context:NSManagedObjectContext = ManagedObjectContext
                let finder = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
                finder.predicate = NSPredicate(format:"id = %D", Catcher[0].place_id)
                let Checker = try! context.fetch(finder) as! [BookShelfs]
                    
                alertTitle = "警告！\n[\(Checker[0].name!)]に「\(TitleTextField.text!)」は既に登録されています。"
                print(alertTitle)
                alertMessage = "登録しますか？"
                alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            }else{
                alertTitle = "[\(selectedSection)]に「\(TitleTextField.text!)」を登録します。"
                alertMessage = "登録しますか？"
                alert(alertTitle: alertTitle, alertMessage: alertMessage, isEntry: true, isCancel: true)
            }
            
        }
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
        let Shelfsearch = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        Shelfsearch.predicate = NSPredicate(format:"name = %@", place)
        do{
            Searchresult = try ManagedObjectContext.fetch(Shelfsearch)as! [BookShelfs]
        }catch{
            print("Core searchshelfs get error.")
        }
        let BookObject = Books(context: self.ManagedObjectContext)
        BookObject.id = idnum
        BookObject.title_name = title
        BookObject.place_id = Searchresult[0].id
        BookObject.author_name = author
        self.BookArray.append(BookObject)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let AllBookget = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        do{
            BookArray = try ManagedObjectContext.fetch(AllBookget)as! [Books]
        }catch{
            print("Core book get error.")
        }
        Booknum = BookArray.count
        idnum += 1
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
    
    func load(){
            let AllShelfs = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
            do{
              ShelfArray = try ManagedObjectContext.fetch(AllShelfs) as! [BookShelfs]
            }catch{
              print("BookShelf Fetch Error.")
            }
            mynum = BookArray.count
            Shelfnum = ShelfArray.count
            if mynum == 0{
                //保管場所が存在しない時の処理
                alertTitle = "保管場所が作成されていません"
                alertMessage = "保管場所を登録してから入力してください"
                alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                    (action: UIAlertAction!) -> Void in
                    //OKボタンが押された時の処理
                    //何もしない
                }))
                present(alertController, animated: true, completion: nil)
            }else if (mynum < Shelfnum){
                for i in 0..<Shelfnum-mynum{
                    mySections.append(ShelfArray[mynum+i].name!)
                }
            }else if(mynum > Shelfnum){
                for i in 0..<mynum{
                    mySections[i] = ShelfArray[i].name!
                }
            }
            
            if Booknum > 0{
                idnum = Int16(BookArray[Booknum - 1].id) + 1
            }
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
        return ShelfArray.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return ShelfArray[row].name!
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        selectedSection = ShelfArray[row].name!
    }
        
    @IBAction func camera(_ sender: Any) {
        let CameraViewController = self.storyboard?.instantiateViewController(withIdentifier: "camera2") as! CameraViewController
        self.present(CameraViewController, animated: true, completion: nil)
    }
}
