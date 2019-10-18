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
        if UserDefaults.standard.object(forKey: "TodoList") != nil {
            TodoKobetsunonakami = UserDefaults.standard.object(forKey: "TodoList") as! [String]
        }
        
        if UserDefaults.standard.object(forKey: "SectionList") != nil{
            Sectionkobetunonakami = UserDefaults.standard.object(forKey: "SectionList") as! [String]
        }
        // Do any additional setup after loading the view.
        
        for _ in 0 ... 2{
            twoDimArray.append([])
        }

        twoDimArray[0] = TodoKobetsunonakami
        twoDimArray[1] = ["鈴木","吉田"]
        twoDimArray[2] = ["遠藤","佐藤","村田","山田"]
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return Sectionkobetunonakami.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return twoDimArray[section].count
       }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sectionkobetunonakami[section]
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = twoDimArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClass = Sectionkobetunonakami[indexPath.section]
        selectedPerson = twoDimArray[indexPath.section][indexPath.row]
    }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
      
}

