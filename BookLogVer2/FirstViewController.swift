//
//  FirstViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class FirstViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate{
    var mySections = [String]()
    var twoDimArray = [[String]]()
    var selectedClass = ""
    var selectedBook = ""
    var booklist:[Book] = []
    var view_list:[[Book]] = []
    var book_shelf_list:[BookShelf] = []
    let get_api = GetDataFromApi()
    

    @IBOutlet weak var tableView: UITableView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "一覧画面"
        navigationItem.rightBarButtonItem = editButtonItem
        
        //カスタムセルの設定
        tableView.register (UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier:"reuse_cell")
        
        //データベースからデータのロード
        load_data()
    }
        
      
    //表示時のデータ更新
    override func viewWillAppear(_ animated: Bool) {


//        if UserDefaults.standard.object(forKey: "SectionList") != nil{
//            mySections = UserDefaults.standard.object(forKey: "SectionList") as! [String]
//        }
//        twoDimArray = []
//        for i in mySections{
//            if UserDefaults.standard.object(forKey: i) != nil {
//                let x = UserDefaults.standard.object(forKey: i) as! [String]
//                twoDimArray.append(x)
//
//            }else{
//                UserDefaults.standard.set([], forKey: i)
//                twoDimArray.append([])
//            }
//        }

        tableView.reloadData()
//        super.viewWillAppear(animated)

    }
    
    func load_data(){
    let dispatchGroup = DispatchGroup()
    let shelfQueue = DispatchQueue(label: "queue", qos: .userInteractive)
    let bookQueue = DispatchQueue(label: "queue", qos: .userInteractive)
    
    //本と本棚のapiを取得するため、未完了タスクを２つ用意する
    dispatchGroup.enter()
    dispatchGroup.enter()
    
    shelfQueue.async(group: dispatchGroup) {
        self.get_api.get_book_shelf(completion: {returnData in
            self.book_shelf_list = returnData
            
            for _ in self.book_shelf_list{
                self.view_list.append([])
            }
            dispatchGroup.leave()
            print("shelfDone")
        })
    }
    
    
    bookQueue.async(group: dispatchGroup){
        self.get_api.get_book(completion: {returnData in
                self.booklist = returnData
                dispatchGroup.leave()
                print("bookDone")
        })
    }
    
    //本と本棚両方のapiを取得後リロード
    dispatchGroup.notify(queue: .main) {
        var count:Int = 0
        
        for i in self.book_shelf_list{
            for j in self.booklist{
                if i.id == j.place_id{
                    self.view_list[count].append(j)
                }
            }
            count += 1
        }
        print("All Process Done!")
        self.tableView.reloadData()
        
    }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return book_shelf_list.count

     }
     
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return view_list[section].count
        }
     
      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return book_shelf_list[section].name
     }
    
     
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "reuse_cell", for: indexPath) as! TableViewCell
          cell.control_cell(book: view_list[indexPath.section][indexPath.row])
          return cell
      }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClass = book_shelf_list[indexPath.section].name
        selectedBook = view_list[indexPath.section][indexPath.row].title
     }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing //editingはBool型でeditButtonに依存する変数
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //dataを消してから
        view_list[indexPath.section].remove(at: indexPath.row)
        //データベースにdeleteする
        //UserDefaults.standard.set(twoDimArray[indexPath.section], forKey: book_shelf_list[indexPath.section])

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
            view_list[sourceIndexPath.section].swapAt(sourceIndexPath.row, destinationIndexPath.row)
        }else{
            view_list[sourceIndexPath.section][sourceIndexPath.row].place_id = book_shelf_list[destinationIndexPath.section].id
            view_list[destinationIndexPath.section].insert(view_list[sourceIndexPath.section][sourceIndexPath.row], at: destinationIndexPath.row)
            view_list[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        }
        
        //変更を保存
//        var count = 0
//        for i in book_shelf_list{
//            UserDefaults.standard.set(twoDimArray[count], forKey: i)
//            count += 1
//        }
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {50}//sectionの高さ
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {60}//cellの高さ
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let label : UILabel = UILabel()
        label.backgroundColor = UIColor.init(red: 205/255, green: 133/255, blue: 63/255, alpha: 100/100)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "  "+book_shelf_list[section].name
        return label
    }//sectionの色、文字サイズ
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }

      
}

