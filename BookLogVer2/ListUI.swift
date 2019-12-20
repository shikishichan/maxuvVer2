//
//  ListUI.swift
//  BookLogVer2
//
//  Created by Masaki Sakugawa on 2019/12/20.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import Foundation
import UIKit

protocol SortDelegate:class {
    
    func sort(order:String)
    func hidden_book()
    
}

class CalloutView: UIView {
    var delegate: SortDelegate?
    //FirstViewで使用する
    var listString: [String]
    var buttonList: [UIButton]
    
    init(labelList: [String], imageNameList: [String], frame: CGRect) {
        self.listString = labelList
        self.buttonList = zip(imageNameList, labelList).map { (imageName, label) in
            let button = UIButton()
            let image = UIImage(named: imageName)
            button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 190);
            button.setImage(image, for: .init())
            button.setTitle(label, for: .init())
            button.titleLabel?.textColor = .white
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
            //button.titleLabel?.textAlignment = .right
            return button
        }
        super.init(frame: frame)
        self.backgroundColor = .orange
        
        self.buttonList.forEach { button in
            button.addTarget(self, action: #selector(self.tappedButton(button:)), for: .touchUpInside)
            self.addSubview(button)
        }
        
        
    }
    
    @objc func tappedButton(button: UIButton) {
        if button.titleLabel?.text == "保管場所順" {
            print("保管場所順")
            self.delegate?.sort(order: "保管場所順")
        } else if button.titleLabel?.text == "タイトル順" {
            print("タイトル順")
            self.delegate?.sort(order: "タイトル順")
        } else {
            print("著者順")
            self.delegate?.sort(order: "著者順")
        }
        
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let width = self.frame.width
        let height = self.frame.height
        
        self.layer.cornerRadius = width*0.1
        
        let buttonHeight = height*0.9 / CGFloat(self.buttonList.count)
        for (idx, button) in self.buttonList.enumerated() {
            button.frame = CGRect(x: 0, y: buttonHeight*CGFloat(idx), width: width*0.8, height: buttonHeight)
        }
    }
    
}

class CalloutView2: UIView {
    var delegate: SortDelegate?
    //FirstViewで使用する
    var listString: [String]
    var buttonList: [UIButton]
    
    init(labelList: [String], imageNameList: [String], frame: CGRect) {
        self.listString = labelList
        self.buttonList = zip(imageNameList, labelList).map { (imageName, label) in
            let button = UIButton()
            let image = UIImage(named: imageName)
            button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 190);
            button.setImage(image, for: .init())
            button.setTitle(label, for: .init())
            button.titleLabel?.textColor = .white
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.font = UIFont.systemFont(ofSize: 23)
            //button.titleLabel?.textAlignment = .right
            return button
        }
        super.init(frame: frame)
        self.backgroundColor = .orange
        
        self.buttonList.forEach { button in
            button.addTarget(self, action: #selector(self.tappedButton(button:)), for: .touchUpInside)
            self.addSubview(button)
        }
        
        
    }
    
    @objc func tappedButton(button: UIButton) {
        if button.titleLabel?.text == "本棚を編集する" {
            print("編集")
            //self.delegate?.sort(order: "保管場所順")
        } else {
            print("隠す")
            self.delegate?.hidden_book()
            //self.delegate?.sort(order: "著者順")
        }
        
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let width = self.frame.width
        let height = self.frame.height
        
        self.layer.cornerRadius = width*0.1
        
        let buttonHeight = height*0.9 / CGFloat(self.buttonList.count)
        for (idx, button) in self.buttonList.enumerated() {
            button.frame = CGRect(x: 0, y: buttonHeight*CGFloat(idx), width: width*0.8, height: buttonHeight)
        }
    }
    
}
