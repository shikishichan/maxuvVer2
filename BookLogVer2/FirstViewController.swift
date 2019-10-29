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

