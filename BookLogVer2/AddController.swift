//
//  AddController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit
var TodoKobetsunonakami1 = [String]()
var TodoKobetsunonakami2 = [String]()
var TodoKobetsunonakami3 = [String]()
var Sectionkobetsunonakami = [String]()

var selectedSection = ""

class AddController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
        
    @IBOutlet weak var SectionTextField: UITextField!
    @IBAction func SectionAddButton(_ sender: Any) {
        Sectionkobetsunonakami.append(selectedSection)
        SectionTextField.text = ""
        UserDefaults.standard.set( Sectionkobetsunonakami, forKey: "SectionList" )
//        if selectedSection == "section1" {
//
//            Sectionkobetunonakami1.append(SectionTextField.text!)
//            UserDefaults.standard.set(Sectionkobetunonakami1, forKey: "SectionList1")
//
//        }else if selectedSection == "section2" {
//
//            Sectionkobetunonakami2.append(SectionTextField.text!)
//            UserDefaults.standard.set(Sectionkobetunonakami2, forKey: "SectionList2")
//
//        }else if selectedSection == "section3" {
//
//            Sectionkobetunonakami3.append(SectionTextField.text!)
//            UserDefaults.standard.set(Sectionkobetunonakami3, forKey: "SectionList3")
//
//        }
        
        SectionTextField.text = ""
    }
    
    @IBOutlet weak var TodoTextField: UITextField!
    @IBAction func TodoAddButton(_ sender: Any) {
        if selectedSection == "section1" {
            
            TodoKobetsunonakami1.append(TodoTextField.text!)
            UserDefaults.standard.set(TodoKobetsunonakami1, forKey: "TodoList1")
            
        }else if selectedSection == "section2" {
            
            TodoKobetsunonakami2.append(TodoTextField.text!)
            UserDefaults.standard.set(TodoKobetsunonakami2, forKey: "TodoList2")
            
        }else if selectedSection == "section3" {
            
            TodoKobetsunonakami3.append(TodoTextField.text!)
            UserDefaults.standard.set(TodoKobetsunonakami3, forKey: "TodoList3")
            
        }
//        TodoKobetsunonakami.append(TodoTextField.text!)
//        TodoTextField.text = ""
//        UserDefaults.standard.set( TodoKobetsunonakami, forKey: "TodoList" )
    }
    
    @IBOutlet weak var sectionLabel: UILabel!
    
    @IBOutlet weak var sectionSelect: UIPickerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionSelect.delegate = self
        sectionSelect.dataSource = self

        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.object(forKey: "SectionList") != nil{
            Sectionkobetsunonakami = UserDefaults.standard.object(forKey: "SectionList") as! [String]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Sectionkobetsunonakami.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return Sectionkobetsunonakami[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
//        label.text = dataList[row]
        selectedSection = Sectionkobetsunonakami[row]
        
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
