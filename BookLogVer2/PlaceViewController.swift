//
//  SecondViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var mySections = [String]()

    
    @IBOutlet weak var placeTextField: UITextField!
    
    @IBAction func placeAddBotton(_ sender: Any) {
        mySections.append(placeTextField.text!)
        placeTextField.text = ""
        UserDefaults.standard.set( mySections, forKey: "SectionList" )
        
        sectionTableView.reloadData()
        
    }
    

    @IBOutlet weak var sectionTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if UserDefaults.standard.object(forKey: "SectionList") != nil{
            mySections = UserDefaults.standard.object(forKey: "SectionList") as! [String]
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySections.count
     }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = mySections[indexPath.row]
        //cell.textLabel!.font = UIFont(name: "Arial", size: 20)
        
        return cell
    }

}
