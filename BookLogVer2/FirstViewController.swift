//
//  FirstViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class FirstViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate{
    var twoDimArray = [[Books]]()
    var selectedClass = Int16()
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
    
    var datacontroll = DataController(){}
    
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
            self.books = self.datacontroll.fetchBooks(sort: 1)
            self.tableView.reloadData()
        })
        let action3 = UIAlertAction(title: "著者順", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //hogehoge
            self.order = "著者順"
            self.books = self.datacontroll.fetchBooks(sort: 2)
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
        
    }
    
    func load(){
        //datacontroll.AlldeleteBook()
        //datacontroll.AlldeleteShelf()
        bookshelfs = datacontroll.fetchShelfs()
        
        twoDimArray.removeAll()
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
        }else{
            for i in bookshelfs{
                let bookarray = datacontroll.searchBooks(num: 2, conditionNum: i.id, conditionStr: "")
                twoDimArray.append(bookarray)
            }
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
    
    //表示時のデータ更新
    override func viewWillAppear(_ animated: Bool) {
        
        load()
        
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
            self.books = self.datacontroll.fetchBooks(sort: 1)
        }else if order == "著者順"{
            self.books = self.datacontroll.fetchBooks(sort: 2)
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
            cell.controlCell(book: twoDimArray[indexPath.section][indexPath.row], order: order, datacontroll:datacontroll)
        }else{
            cell.controlCell(book: books[indexPath.row], order: order, datacontroll: datacontroll)
        }
        cell.textLabel!.font = UIFont(name: "Arial", size: 20)//cellのfont,size
        return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if order == "保管場所順"{
            selectedClass = bookshelfs[indexPath.section].id
            selectedBook = twoDimArray[indexPath.section][indexPath.row]
            datacontroll.changeBook(id: selectedBook.id, title: "test2", place: 0, author: "atest2", number: 1)
            load()
        }else{
            selectedClass = books[indexPath.row].place_id
            selectedBook = books[indexPath.row]
        }
        
        performSegue(withIdentifier: "toDetail",sender: nil)
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC: DetailViewController = (segue.destination as? DetailViewController)!
//        detailVC.bookData = selectedBook
        detailVC.bookData = selectedBook
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
        //dataを消してから
        twoDimArray[indexPath.section].remove(at: indexPath.row)
        
        datacontroll.deleteBook(id: tmp.id)

        //tableViewCellの削除
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
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
        let tmps = twoDimArray[sourceIndexPath.section][sourceIndexPath.row]
        let tmpd = twoDimArray[destinationIndexPath.section][destinationIndexPath.row]
        //同一section内ならswap, 別のsectionならinsert&remove
        if(sourceIndexPath.section == destinationIndexPath.section){
            datacontroll.changeBook(id: tmps.id, title: tmps.title!, place: tmps.place_id, author: tmps.author!, number: tmpd.number)
            datacontroll.changeBook(id: tmpd.id, title: tmpd.title!, place: tmpd.place_id, author: tmpd.author!, number: tmps.number)
        }else{
            for i in twoDimArray[destinationIndexPath.section]{
                if i.number >= tmpd.number{
                    datacontroll.changeBook(id: i.id, title: i.title!, place: i.place_id, author: i.author!, number: i.number+1)
                }
            }
            datacontroll.changeBook(id: tmps.id, title: tmps.title!, place: tmpd.place_id, author: tmps.author!, number: tmpd.number)
            twoDimArray[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            for j in twoDimArray[sourceIndexPath.section]{
                if j.number >= tmps.number{
                    datacontroll.changeBook(id: j.id, title: j.title!, place: j.place_id, author: j.author!, number: j.number-1)
                }
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

