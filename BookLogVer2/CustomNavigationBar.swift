//
//  CustomNavigationBar.swift
//  BookLogVer2
//
//  Created by toma ayaka on 2019/10/26.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationBar: UINavigationBar {

    //set NavigationBar's height
    var customHeight : CGFloat = 70

    override func sizeThatFits(_ size: CGSize) -> CGSize {

        return CGSize(width: UIScreen.main.bounds.width, height: customHeight)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        frame = CGRect(x: frame.origin.x, y:  0, width: frame.size.width, height: customHeight)

        // title position (statusbar height / 2)
        setTitleVerticalPositionAdjustment(-10, for: UIBarMetrics.default)

        for subview in self.subviews {
            var stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarBackground") {
                subview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: customHeight)
                subview.backgroundColor = .brown

            }

            stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarContent") {

                subview.frame = CGRect(x: subview.frame.origin.x, y: 20, width: subview.frame.width, height: customHeight - 20)

                //subview.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.4)

            }
        }
    }


}
