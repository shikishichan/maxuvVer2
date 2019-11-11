//
//  TabBarController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/11/07.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tabBarController(_ TabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is TabBarDelegate {
            let v = viewController as! TabBarDelegate
            v.didSelectTab(tabBarController: self)
        }
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
