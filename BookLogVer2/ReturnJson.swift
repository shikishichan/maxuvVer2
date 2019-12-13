//
//  ReturnJson.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/11/16.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import Foundation
//今はいらなそう
class ReturnJson: Codable {
    var kind: String
    var totalItems: Int
    var items: [ItemJson]
}

class ItemJson: Codable {
    var volumeInfo: VolumeInfoJson
}

class VolumeInfoJson: Codable {
    // 本の名称
    var title: String
    // 著者
    var authors: [String]
    // 本の画像
    var imageLinks: ImageLinkJson
}

class ImageLinkJson: Codable {
    var smallThumbnail: URL
}
