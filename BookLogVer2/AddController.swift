//
//  AddController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/10/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit


class AddController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var mySections = [String]()
    var twoDimArray = [[String]]()
    var selectedSection = ""
    var alertController: UIAlertController!
    
    var alertTitle = ""
    var alertMessage = ""

    
    @IBOutlet weak var TodoTextField: UITextField!
    @IBAction func TodoAddButton(_ sender: Any) {
        
        if(mySections != []){
            if(TodoTextField.text! != ""){
                //titleが入力されている時の処理
                
                if(selectedSection == ""){//保管場所を選択していない時は一番目の場所にいれる
                    selectedSection = mySections[0]
                }
                
                //titleが同じものがないかの判定
                var count = 0
                loop: for i in twoDimArray{
                    
                    for j in i{
                        if(j == TodoTextField.text!){
                            //ダブりがあった時
                            alertTitle = "警告！\n[\(mySections[count])]に「\(TodoTextField.text!)」は既に登録されています。"
                            print(alertTitle)
                            alertMessage = "登録しますか？"
                            alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                            break loop
                        }else{
                            //ダブりがない時
                            alertTitle = "[\(selectedSection)]に「\(TodoTextField.text!)」を登録します。"
                            let alertMessage = "登録しますか？"
                            alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                            
                        }
                    }
                    count += 1
                }
                
                alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                    (action: UIAlertAction!) -> Void in
                    //OKボタンが押された時の処理
                    self.touroku(title: self.TodoTextField.text!, place: self.selectedSection)
                }))
                alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    //キャンセルボタンが押された時の処理
                    self.TodoTextField.text = ""
                }))
                present(alertController, animated: true, completion: nil)
                print("ok")
                
            }else{
                //titleが入力されていない時の処理
                alertTitle = "タイトルが入力されていません"
                alertMessage = "もう一度入力してください"
                alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                    (action: UIAlertAction!) -> Void in
                    //OKボタンが押された時の処理
                    //何もしない
                }))
                present(alertController, animated: true, completion: nil)
                print("titlenasi")
            }
        }else{
            //保管場所が存在しない時の処理
            alertTitle = "保管場所が作成されていません"
            alertMessage = "保管場所を登録してから入力してください"
            alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                //OKボタンが押された時の処理
                //何もしない
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func touroku(title:String, place:String) {
        if UserDefaults.standard.object(forKey: place) != nil{
            var x = UserDefaults.standard.object(forKey: place) as! [String]
            x.append(title)
            UserDefaults.standard.set(x, forKey: place)
        }else{
            var x = [String]()
            x.append(title)
            UserDefaults.standard.set(x, forKey: place)
        }
        TodoTextField.text = ""
    }
    
    @IBOutlet weak var sectionLabel: UILabel!
    
    @IBOutlet weak var sectionSelect: UIPickerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionSelect.delegate = self
        sectionSelect.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    //表示時のデータ更新
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "SectionList") != nil{
            mySections = UserDefaults.standard.object(forKey: "SectionList") as! [String]
        }else{
            //保管場所が存在しない時の処理
            alertTitle = "保管場所が作成されていません"
            alertMessage = "保管場所を登録してから入力してください"
            alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                //OKボタンが押された時の処理
                //何もしない
            }))
            present(alertController, animated: true, completion: nil)
        }
        
//        print(mySections)

        for i in mySections{
            if UserDefaults.standard.object(forKey: i) != nil {
                let x = UserDefaults.standard.object(forKey: i) as! [String]
                twoDimArray.append(x)
            }else{
                UserDefaults.standard.set([], forKey: i)
                twoDimArray.append([])
            }
        }
        sectionSelect.reloadAllComponents()
        
        super.viewWillAppear(animated)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mySections.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return mySections[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        selectedSection = mySections[row]
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
