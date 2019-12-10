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
    var mySections = [String]()
    var twoDimArray = [[String]]()
    var selectedClass = ""
    var selectedBook = ""
    var BookArray: [Books] = []
    var ShelfArray: [BookShelfs] = []
    var ManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var Booknum: Int = 0
    var Shelfnum: Int = 0
    var Bookplacesearch: [Books] = []

    @IBOutlet weak var tableView: UITableView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let AllBooks = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        do{
          BookArray = try ManagedObjectContext.fetch(AllBooks) as! [Books]
        }catch{
          print("Book Fetch Error.")
        }
        let AllShelfs = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        do{
          ShelfArray = try ManagedObjectContext.fetch(AllShelfs) as! [BookShelfs]
        }catch{
          print("BookShelf Fetch Error.")
        }
        
        let context:NSManagedObjectContext = ManagedObjectContext
        var fetchData = try! context.fetch(AllBooks)
        if(!fetchData.isEmpty){
              for i in 0..<fetchData.count{
                    let deleteObject = fetchData[i] as! Books
                    context.delete(deleteObject)
              }
              do{
                    try context.save()
              }catch{
                    print(error)
              }
        }
        
        fetchData = try! context.fetch(AllShelfs)
        if(!fetchData.isEmpty){
              for i in 0..<fetchData.count{
                    let deleteObject = fetchData[i] as! BookShelfs
                    context.delete(deleteObject)
              }
              do{
                    try context.save()
              }catch{
                    print(error)
              }
        }
        BookArray = []
        ShelfArray = []
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "一覧画面"
        navigationItem.rightBarButtonItem = editButtonItem
        
        if ShelfArray.count != 0{
            for i in ShelfArray{
                mySections.append(i.name!)
            }
        }
        
    }
        
      
    //表示時のデータ更新
    override func viewWillAppear(_ animated: Bool) {
        //本棚のフェッチ(データ入手)
        let AllShelfget = NSFetchRequest<NSFetchRequestResult>(entityName: "BookShelfs")
        do{
            ShelfArray = try ManagedObjectContext.fetch(AllShelfget)as! [BookShelfs]
        }catch{
            print("Core shelf get error.")
        }
        print("Shelf Fetch success.")
        Shelfnum = ShelfArray.count
        let mycount = mySections.count
        
        if (Shelfnum > 0) && (Shelfnum > mycount){
            for i in 0..<Shelfnum - mycount{
                mySections.append(ShelfArray[mycount + i].name!)
            }
        }else if((Shelfnum == 1) && (Shelfnum > mycount)){
            mySections.append(ShelfArray[0].name!)
        }
        
        //本のフェッチ(データ入手)
        let AllBooks = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
         do{
           BookArray = try ManagedObjectContext.fetch(AllBooks) as! [Books]
         }catch{
           print("DB Fetch Error.")
         }
         print("Book Fetch success.")
        Booknum = BookArray.count
        
        twoDimArray = []
        
        for i in 0..<Shelfnum{
            let BookSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
            BookSearch.predicate = NSPredicate(format:"place_id = %D", i)
            do{
                Bookplacesearch = try ManagedObjectContext.fetch(BookSearch)as! [Books]
            }catch{
                print("Core searchbooks get error.")
                continue
            }
            twoDimArray.append([])
            for j in 0..<Bookplacesearch.count{
                twoDimArray[i].append(Bookplacesearch[j].title_name!)
            }
        }
        
        tableView.reloadData()
        super.viewWillAppear(animated)
        print(mySections)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count

     }
     
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return twoDimArray[section].count
        }
     
      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return mySections[section]
     }
    
     
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
         cell.textLabel?.text = twoDimArray[indexPath.section][indexPath.row]
         cell.textLabel!.font = UIFont(name: "Arial", size: 20)//cellのfont,size
         return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selectedClass = mySections[indexPath.section]
         selectedBook = twoDimArray[indexPath.section][indexPath.row]
     }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing //editingはBool型でeditButtonに依存する変数
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //dataを消してから
        twoDimArray[indexPath.section].remove(at: indexPath.row)

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
            twoDimArray[destinationIndexPath.section].insert(twoDimArray[sourceIndexPath.section][sourceIndexPath.row], at: destinationIndexPath.row)
                twoDimArray[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        }

    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {50}//sectionの高さ
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {60}//cellの高さ
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let label : UILabel = UILabel()
        label.backgroundColor = UIColor.init(red: 205/255, green: 133/255, blue: 63/255, alpha: 100/100)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "  "+mySections[section]
        return label
    }//sectionの色、文字サイズ
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }

      
}

