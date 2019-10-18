//
//  AddController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit
var TodoKobetsunonakami = [String]()
var Sectionkobetunonakami = [String]()

class AddController: UIViewController {
    @IBOutlet weak var SectionTextField: UITextField!
    @IBAction func SectionAddButton(_ sender: Any) {
        Sectionkobetunonakami.append(SectionTextField.text!)
        SectionTextField.text = ""
        UserDefaults.standard.set(Sectionkobetunonakami, forKey: "SectionList")
    }
    
    @IBOutlet weak var TodoTextField: UITextField!
    @IBAction func TodoAddButton(_ sender: Any) {
        TodoKobetsunonakami.append(TodoTextField.text!)
        TodoTextField.text = ""
        UserDefaults.standard.set( TodoKobetsunonakami, forKey: "TodoList" )
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
