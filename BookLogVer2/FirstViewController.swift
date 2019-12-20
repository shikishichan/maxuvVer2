//
//  FirstViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate{
    var twoDimArray = [[Books]]()
    var selectedClass = BookShelfs()
    var selectedBook = Books()
    
    var books = [Books]()
    var bookshelfs = [BookShelfs]()
//    let BookKey = "bookkey"
//    let BookShelfKey = "shelfkey"
    
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"
    
    var alertController: UIAlertController!
    
    var alertTitle = ""
    var alertMessage = ""
    
    var order = ""
    var bookId = Int()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var sortSelectButton: UIBarButtonItem!
    @IBAction func sortSelectButton(_ sender: Any) {
        print("hoge")
        let actionSheet = UIAlertController(title: "並び順", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "保管場所順", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //hogehoge
            self.order = "保管場所順"
            self.tableView.reloadData()
        })
        let action2 = UIAlertAction(title: "50音順", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //hogehoge
            self.order = "50音順"
            self.books = self.books.sorted { $0.title!.localizedStandardCompare($1.title!) == .orderedAscending }
            self.tableView.reloadData()
        })
        let action3 = UIAlertAction(title: "著者順", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //hogehoge
            self.order = "著者順"
            self.books = self.books.sorted { $0.author!.localizedStandardCompare($1.author!) == .orderedAscending }
            self.tableView.reloadData()
        })

        // To set image in ActionButton
//        action1.setValue(#imageLiteral(resourceName: "check").withRenderingMode(.alwaysOriginal), forKey: "image")

        // Add Actions to AlertController
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        let screenSize = UIScreen.main.bounds
        // ここで表示位置を調整
        // xは画面中央、yは画面下部になる様に指定
//        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        
        // 左上のボタンの下のちょうどいい位置
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 70, width: 0, height: 0)
        
         

        // Present UIAlertController
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var tableView: UITableView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "ReUseCell")
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "一覧"
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.title = "編集"
        
        order = "保管場所順"
        
        //allDeleteBook()
        //allDeleteShelf()
        
        load()
        print("-----------------")
        for i in books{
            print(i.id)
        }
        print("-----------------")
        for i in bookshelfs{
            print(i.id)
        }
        print("-----------------")
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
        
        twoDimArray.removeAll()
        for i in bookshelfs{
            let bookarray = DimMake(shelf: i)
            if !bookarray.isEmpty{
                for j in 0..<bookarray.count{
                    changeBook(id: bookarray[j].id, number: Int16(j), shelf: i)
                }
            }
            twoDimArray.append(bookarray)
        }
    }
    
    func alert(alertTitle:String, alertMessage:String, isEntry:Bool, isCancel:Bool){
        alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //OKボタンが押された時の処理
            if isEntry{
//                self.touroku(title: self.TitleTextField.text!, place: self.selectedSection, author: self.AuthorTextField.text!)
            }
        }))
        if isCancel{
            alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler:{
                (action: UIAlertAction!) -> Void in
                //キャンセルボタンが押された時の処理
//                self.TitleTextField.text = ""
                
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func DimMake(shelf:BookShelfs) -> [Books]{
        do {
            let dimRequest: NSFetchRequest<Books> = Books.fetchRequest()
            dimRequest.predicate = NSPredicate(format: "bookshelfs.name == %@",shelf.name!)
            dimRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
            let dimlist = try context.fetch(dimRequest)
            return dimlist
        } catch {
            print("Error")
        }
        return []
    }
    
    func changeBook(id:Int16, number:Int16, shelf:BookShelfs){
        let changeBookRequest:NSFetchRequest<Books> = Books.fetchRequest()
        changeBookRequest.predicate = NSPredicate(format:"id = %D",id)
        let changeBookData = try! context.fetch(changeBookRequest)
        if(!changeBookData.isEmpty){
            changeBookData[0].number = number
            changeBookData[0].bookshelfs! = shelf
            do{
                try context.save()
            }catch{
                print(error)
            }
        }
    }
    
    func allDeleteShelf(){
        let deleteRequest:NSFetchRequest<BookShelfs> = BookShelfs.fetchRequest()
        let deleteData = try! context.fetch(deleteRequest)
        if(!deleteData.isEmpty){
            for i in deleteData{
                context.delete(i)
            }
            do{
                try context.save()
            }catch{
                print(error)
            }
        }
    }
    
    func allDeleteBook(){
        let deleteRequest:NSFetchRequest<Books> = Books.fetchRequest()
        let deleteData = try! context.fetch(deleteRequest)
        if(!deleteData.isEmpty){
            for i in deleteData{
                context.delete(i)
            }
            do{
                try context.save()
            }catch{
                print(error)
            }
        }
    }
    
    //表示時のデータ更新
    override func viewWillAppear(_ animated: Bool) {
        
        load()
        
        if bookshelfs.isEmpty{
            //保管場所が存在しない時の処理
            alertTitle = "保管場所が作成されていません"
            alertMessage = "保管場所を登録してください"
            alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                        (action: UIAlertAction!) -> Void in
                        //OKボタンが押された時の処理
                        //placeviewに遷移させようかな
                    }))
                    present(alertController, animated: true, completion: nil)
            return
        }
        
        //load()後は保管場所順になっている
        sort(order: order)
        tableView.reloadData()
        super.viewWillAppear(animated)
    
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var num = Int()
        if order == "保管場所順"{
            num = bookshelfs.count
        }else if order == "50音順"{
            num = 1
        }else if order == "著者順"{
            num = 1
        }
        
        return num
     }
 
      
      /*セルの折りたたみ*/
      
      private var openedSections = Set<Int>()
      
    @IBAction func cellOpenSwitch(_ sender: UISwitch) {
        if sender.isOn {
            for i in 0..<bookshelfs.count {
                self.openedSections.insert(i)
            }

        } else {
            for i in 0..<bookshelfs.count {
                if self.openedSections.contains(i) {
                    self.openedSections.remove(i)
                }
            }
        }
        tableView.reloadData()
    }
    
    
      @objc func tapSectionHeader(sender: UIGestureRecognizer) {
          if let section = sender.view?.tag {
              if self.openedSections.contains(section) {
                  self.openedSections.remove(section)
              } else {
                  self.openedSections.insert(section)
              }

              self.tableView.reloadSections(IndexSet(integer: section), with: .fade)
          }
      }
    
    func sort(order: String){
        if order == "保管場所順"{
            //何もしない
        }else if order == "50音順"{
            self.books = self.books.sorted { $0.title!.localizedStandardCompare($1.title!) == .orderedAscending }
        }else if order == "著者順"{
            self.books = self.books.sorted { $0.author!.localizedStandardCompare($1.author!) == .orderedAscending }
        }
    }
       
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              //return twoDimArray[section].count
        if order == "保管場所順"{
            if self.openedSections.contains(section) {
                return twoDimArray[section].count
            } else {
                return 0
            }
        }else if order == "50音順"{
            if self.openedSections.contains(section) {
                return books.count
            } else {
                return 0
            }
        }else if order == "著者順"{
            if self.openedSections.contains(section) {
                return books.count
            } else {
                return 0
            }
        }
        
//          if self.openedSections.contains(section) {
//              return bookshelfs[section].numofbook
//          } else {
//              return 0
//          }
        return 0
       }
      
      
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if order != "保管場所順"{
            let view = UITableViewHeaderFooterView()
            return view
        }
        //let label : UILabel = UILabel()
        let bookNum: String = String("\(twoDimArray[section].count)")
        let label: String = bookshelfs[section].name! + "  (" + bookNum + "冊)"
        let view = UITableViewHeaderFooterView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapSectionHeader(sender:)))
        view.addGestureRecognizer(gesture)
        view.tag = section
        
        view.contentView.backgroundColor = UIColor.init(red: 205/255, green: 133/255, blue: 63/255, alpha: 100/100)
        view.textLabel?.textColor = UIColor.white
        view.textLabel?.font = UIFont.systemFont(ofSize: 20)
        view.textLabel?.textAlignment = .right
        view.textLabel?.text = label
        //sectionの色、文字サイズ
        return view
      
      }/*折りたたみ終わり*/
      
    
     
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReUseCell", for: indexPath) as! SearchTableViewCell
        
        if order == "保管場所順"{
            cell.controlCell(book: twoDimArray[indexPath.section][indexPath.row], order: order)
        }else{
            cell.controlCell(book: books[indexPath.row], order: order)
        }
        cell.textLabel!.font = UIFont(name: "Arial", size: 20)//cellのfont,size
        return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if order == "保管場所順"{
            selectedClass = twoDimArray[indexPath.section][indexPath.row].bookshelfs!
            selectedBook = twoDimArray[indexPath.section][indexPath.row]
        }else{
            selectedClass = books[indexPath.row].bookshelfs!
            selectedBook = books[indexPath.row]
        }
        
        performSegue(withIdentifier: "toDetail",sender: nil)
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC: DetailViewController = (segue.destination as? DetailViewController)!
//        detailVC.bookData = selectedBook
        detailVC.bookDataid = selectedBook.id
        print(selectedBook.id)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing //editingはBool型でeditButtonに依存する変数
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let tmp = twoDimArray[indexPath.section][indexPath.row]
        
        let deleteRequest:NSFetchRequest<Books> = Books.fetchRequest()
        deleteRequest.predicate = NSPredicate(format:"id = %D",tmp.id)
        let deleteData = try! context.fetch(deleteRequest)
        if(!deleteData.isEmpty){
                let deleteObject = deleteData[0] as Books
                context.delete(deleteObject)
            do{
                try context.save()
            }catch{
                print(error)
            }
        }

        //tableViewCellの削除
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        load()
        
    }
    
    //通常時(editモードでない)にセルを左にスワイプするとdeleteが出てくるのをなくす
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    //並び替えボタン
    func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath) {
        
        print(destinationIndexPath)
        
        let tmps = twoDimArray[sourceIndexPath.section][sourceIndexPath.row]
        let tmp = tmps.number
        let destrow = destinationIndexPath.row
        
        if twoDimArray[destinationIndexPath.section].isEmpty{
            changeBook(id: tmps.id, number: 0, shelf: bookshelfs[destinationIndexPath.section])
            load()
        }else{
            //同一section内ならswap, 別のsectionならinsert&remove
            if(sourceIndexPath.section == destinationIndexPath.section){
                let tmpd = twoDimArray[destinationIndexPath.section][destinationIndexPath.row]
                changeBook(id: tmps.id, number: tmpd.number, shelf: tmpd.bookshelfs!)
                changeBook(id: tmpd.id, number: tmp, shelf: tmps.bookshelfs!)
                load()
            }else{
                
                
                
                let justSourRequest:NSFetchRequest<Books> = Books.fetchRequest()
                justSourRequest.predicate = NSPredicate(format:"bookshelfs.name == %@ AND number >= %D",tmps.bookshelfs!,tmp)
                books = try! context.fetch(justSourRequest)
                if(!books.isEmpty){
                    for i in books{
                        changeBook(id: i.id, number: i.number-1, shelf: i.bookshelfs!)
                    }
                }
                let place = bookshelfs[destinationIndexPath.section]
                let changeRequest:NSFetchRequest<Books> = Books.fetchRequest()
                changeRequest.predicate = NSPredicate(format:"bookshelfs.name == %@ AND number >= %D",place.name!,Int16(destrow))
                let changeData = try! context.fetch(changeRequest)
                if(!changeData.isEmpty){
                    for i in changeData{
                        changeBook(id: i.id, number: i.number+1, shelf: i.bookshelfs!)
                    }
                }
                changeBook(id: tmps.id, number: Int16(destrow), shelf: place)
            }
        }
        load()
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {50}//sectionの高さ
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {60}//cellの高さ
    
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }

}

