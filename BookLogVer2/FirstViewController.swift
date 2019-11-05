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
    

    @IBOutlet weak var tableView: UITableView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.object(forKey: "SectionList") != nil{
            mySections = UserDefaults.standard.object(forKey: "SectionList") as! [String]
        }

        for i in mySections{
            if UserDefaults.standard.object(forKey: i) != nil {
                let x = UserDefaults.standard.object(forKey: i) as! [String]
                twoDimArray.append(x)
            }else{
                UserDefaults.standard.set([], forKey: i)
                twoDimArray.append([])
            }
        }
        
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "一覧画面"
        navigationItem.rightBarButtonItem = editButtonItem

        
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
        UserDefaults.standard.set(twoDimArray[indexPath.section], forKey: mySections[indexPath.section])

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
        
        //変更を保存
        var count = 0
        for i in mySections{
            UserDefaults.standard.set(twoDimArray[count], forKey: i)
            count += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
      
}

