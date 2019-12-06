//
//  FirstViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class FirstViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate{
    var twoDimArray = [[Book]]()
    var selectedClass = ""
    var selectedBook = Book.init(title: "", place: "", author: "")
    
    var books = [Book]()
    var bookshelfs = [BookShelf]()
    let BookKey = "bookkey"
    let BookShelfKey = "shelfkey"
    
    var alertController: UIAlertController!
    
    var order = ""
    
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
            self.books = self.books.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
            self.tableView.reloadData()
        })
        let action3 = UIAlertAction(title: "著者順", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //hogehoge
            self.order = "著者順"
            self.books = self.books.sorted { $0.author.localizedStandardCompare($1.author) == .orderedAscending }
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
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
         

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
        
        order = "保管場所順"
        
        load()
        
    }
    
    func save(books: [Book], bookshelfs: [BookShelf]) {
        
        let bookData = books.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(bookData, forKey: BookKey)
        
        let bookShelfData = bookshelfs.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(bookShelfData, forKey: BookShelfKey)
    }
    
    func load(){
        guard let encodedBookData = UserDefaults.standard.array(forKey: BookKey) as? [Data] else {
            print("userdefaultsに本データが保存されていません")
            return
        }
        books = encodedBookData.map { try! JSONDecoder().decode(Book.self, from: $0) }
        
        guard let encodedBookShelfData = UserDefaults.standard.array(forKey: BookShelfKey) as? [Data] else {
            print("userdefaultsに本棚データが保存されていません")
            return
        }
        bookshelfs = encodedBookShelfData.map { try! JSONDecoder().decode(BookShelf.self, from: $0) }
        
        twoDimArray.removeAll()
        for _ in bookshelfs{
            twoDimArray.append([])
        }
        var count = 0
        for i in bookshelfs{
            for j in books{
                if i.name == j.place{
                    twoDimArray[count].append(j)
                }
            }
            count += 1
        }
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
            self.books = self.books.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        }else if order == "著者順"{
            self.books = self.books.sorted { $0.author.localizedStandardCompare($1.author) == .orderedAscending }
        }
    }
       
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              //return twoDimArray[section].count
        if order == "保管場所順"{
            if self.openedSections.contains(section) {
                return bookshelfs[section].numofbook
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
        let bookNum: String = String("\(bookshelfs[section].numofbook)")
        let label: String = bookshelfs[section].name + "  (" + bookNum + "冊)"
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
            selectedClass = bookshelfs[indexPath.section].name
            selectedBook = twoDimArray[indexPath.section][indexPath.row]
        }else{
            selectedClass = books[indexPath.row].place
            selectedBook = books[indexPath.row]
        }
        
        performSegue(withIdentifier: "toDetail",sender: nil)
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC: DetailViewController = (segue.destination as? DetailViewController)!
        detailVC.bookData = selectedBook
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

        //本の数のデクリメント
        bookshelfs[indexPath.section].numofbook -= 1
        
        //{$0 == tmp}じゃできなかった、、、
        let removebookindex = books.firstIndex(where: {$0.title == tmp.title && $0.place == tmp.place})!
        books.remove(at: removebookindex)
        save(books: books, bookshelfs: bookshelfs)

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
        
        //同一section内ならswap, 別のsectionならinsert&remove
        if(sourceIndexPath.section == destinationIndexPath.section){
            twoDimArray[sourceIndexPath.section].swapAt(sourceIndexPath.row, destinationIndexPath.row)
        }else{
            twoDimArray[sourceIndexPath.section][sourceIndexPath.row].place = bookshelfs[destinationIndexPath.section].name
            twoDimArray[destinationIndexPath.section].insert(twoDimArray[sourceIndexPath.section][sourceIndexPath.row], at: destinationIndexPath.row)
                twoDimArray[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            bookshelfs[sourceIndexPath.section].numofbook -= 1
            bookshelfs[destinationIndexPath.section].numofbook += 1
        }
        
        books = []
        for i in twoDimArray{
            for j in i{
                books.append(j)
            }
        }
        
        save(books: books, bookshelfs: bookshelfs)
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {50}//sectionの高さ
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {60}//cellの高さ
    
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }

}

