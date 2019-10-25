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
    var selectedPerson = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        if UserDefaults.standard.object(forKey: "TodoList1") != nil {
            TodoKobetsunonakami1 = UserDefaults.standard.object(forKey: "TodoList1") as! [String]
        }else if UserDefaults.standard.object(forKey: "TodoList2") != nil {
            TodoKobetsunonakami2 = UserDefaults.standard.object(forKey: "TodoList2") as! [String]
        }else if UserDefaults.standard.object(forKey: "TodoList3") != nil {
            TodoKobetsunonakami3 = UserDefaults.standard.object(forKey: "TodoList3") as! [String]
        }
        
        if UserDefaults.standard.object(forKey: "SectionList") != nil{
            Sectionkobetsunonakami = UserDefaults.standard.object(forKey: "SectionList") as! [String]
            
        }

        
        for _ in 0 ... 2{
            twoDimArray.append([])
        }

        twoDimArray[0] = TodoKobetsunonakami1
        twoDimArray[1] = TodoKobetsunonakami2
        twoDimArray[2] = TodoKobetsunonakami3
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return Sectionkobetsunonakami.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return twoDimArray[section].count
       }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sectionkobetsunonakami[section]
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = twoDimArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClass = Sectionkobetsunonakami[indexPath.section]
        selectedPerson = twoDimArray[indexPath.section][indexPath.row]
    }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
      
}

