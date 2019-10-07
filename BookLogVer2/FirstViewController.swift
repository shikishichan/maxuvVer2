//
//  FirstViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoKobetsunonakami.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TodoCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        TodoCell.textLabel!.text = TodoKobetsunonakami[indexPath.row]
        return TodoCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "TodoList") != nil {
            TodoKobetsunonakami = UserDefaults.standard.object(forKey: "TodoList") as! [String]
        }
        // Do any additional setup after loading the view.
        
        //hoge
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

