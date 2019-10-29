//
//  title.swift
//  BookLogVer2
//
//  Created by toma ayaka on 2019/10/24.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import Foundation
import UIKit
 
class TitleViewController: UIViewController {
    var timer:Timer = Timer()                            //追加
     
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 2.0,                            //
                                                       target: self,                   //
                                                       selector: #selector(changeView),         //
                                                       userInfo: nil,                  //
                                                       repeats: false)                 //追加
        // Do any additional setup after loading the view, typically from a nib.
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @objc func changeView() {                                      //
        self.performSegue(withIdentifier: "toTabBarController", sender: nil)                        //
    }                                                                                  //追加
}
