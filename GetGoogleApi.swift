//
//  GetGoogleApi.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/11/16.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//


import Foundation

class GetGoogleApi{
    // imageLinkのデータ構造
    struct  ImageLinkJson: Codable {
        let smallThumbnail: URL?
    }
    // JSONのItem内のデータ構造
    struct VolumeInfoJson: Codable {
        // 本の名称
        let title: String?
        // 著者
        let authors: [String]?
        // 本の画像
        let imageLinks: ImageLinkJson?
    }
    
    // Jsonのitem内のデータ構造
    struct ItemJson: Codable {
        let volumeInfo: VolumeInfoJson?
    }

    // JSONのデータ構造
    struct ResultJson: Codable {
        // 複数要素
        let kind: String?
        let totalItems: Int?
        let items: [ItemJson]?
    }


    // 第一引数：keyword 検索したいワード
    func searchBook(completion: @escaping (ResultJson) -> Void,  keyword : String) {
        // 本のISBN情報をURLエンコードする
        guard keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) != nil else {
            return
        }

        // リクエストURLの組み立て
        guard let req_url = URL(string: "ビビってapiのURLを貼らない男\(keyword)") else {
            return
        }
        print(req_url)

        // リクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        // データ転送を管理するためのセッションを生成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        // リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data , response , error) in
            // セッションを終了
            session.finishTasksAndInvalidate()
            // do try catch エラーハンドリング
            do {
                //JSONDecoderのインスタンス取得
                let decoder = JSONDecoder()
                // 受け取ったJSONデータをパース(解析)して格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                completion(json)
                print(String((json.items?[0].volumeInfo?.title!)!))

            } catch {
                // エラー処理
                print("エラー？")
                print(error)
            }
        })
        // ダウンロード開始
        task.resume()
    }
}
