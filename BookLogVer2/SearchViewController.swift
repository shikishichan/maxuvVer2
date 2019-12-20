//
//  SearchViewController.swift
//  BookLogVer2
//
//  Created by uehara kazuma on 2019/12/13.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var twoDimArray = [[Book]]()
        
    var books = [Book]()
    var bookshelfs = [BookShelf]()
        
    let BookKeyVer2 = "bookkeyver2"
    let BookShelfKeyVer2 = "shelfkeyver2"

//SearchBarインスタンス
    private var mySearchBar: UISearchBar!
//テーブルビューインスタンス
    private var myTableView: UITableView!
//テーブルビューに表示する配列
    private var items: Array<Book> = []
//検索結果が入る配列
    private var searchResult: Array<Book> = []
// SearchBarの高さ
    private var searchBarHeight: CGFloat = 44
// SafeAreaの高さ
    var topSafeAreaHeight: CGFloat = 0
    
    let scopeList = ["タイトル","著者"]
    
    var searchCategory = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//テーブルビューに表示する配列
//        items = ["りんご", "すいか", "もも", "さくらんぼ", "ぶどう", "なし", "みかん", "ぱっしょんふるーつ", "どらごんふるーつ", "まんごー", "めろん", "かき", "びわ", "いちご", "らいち", "らーめん", "すてーき", "ゆず", "れもん", "さくらもち", "ぷりん", "ぜりー"]
//        searchResult = items
        load()
        items = books
// MARK: NavigationBar関連
        //タイトル、虫眼鏡ボタンの作成
        let myNavItems = UINavigationItem()
        myNavItems.title = "検索付きテーブルビュー"
let rightNavBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(rightBarBtnClicked(sender:)))
        rightNavBtn.action = #selector(rightBarBtnClicked(sender:))
self.navigationItem.rightBarButtonItem = rightNavBtn
// MARK: SearchBar関連
        //SearchBarの作成
        mySearchBar = UISearchBar()
//デリゲートを設定
        mySearchBar.delegate = self
//大きさの指定
        mySearchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: searchBarHeight)
//キャンセルボタンの追加
        mySearchBar.showsCancelButton = true
        
        mySearchBar.showsScopeBar = true
        mySearchBar.scopeButtonTitles = scopeList
        searchCategory = "タイトル"
// MARK: TableView関連
        //テーブルビューの初期化
        myTableView = UITableView()
//デリゲートの設定
        myTableView.delegate = self
        myTableView.dataSource = self
//テーブルビューの大きさの指定
        myTableView.frame = view.frame
//先ほど作成したSearchBarを作成
        myTableView.tableHeaderView = mySearchBar
//サーチバーの高さだけ初期位置を下げる
//        myTableView.contentOffset = CGPoint(x: 0, y: searchBarHeight)
//テーブルビューの設置
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        view.addSubview(myTableView)
    }
    
    func load(){
        guard let encodedBookData = UserDefaults.standard.array(forKey: BookKeyVer2) as? [Data] else {
            print("userdefaultsに本データが保存されていません")
            return
        }
        books = encodedBookData.map { try! JSONDecoder().decode(Book.self, from: $0) }
        
        guard let encodedBookShelfData = UserDefaults.standard.array(forKey: BookShelfKeyVer2) as? [Data] else {
            print("userdefaultsに本棚データが保存されていません")
            return
        }
        bookshelfs = encodedBookShelfData.map { try! JSONDecoder().decode(BookShelf.self, from: $0) }
        
        twoDimArray.removeAll()
        for _ in bookshelfs{
            twoDimArray.append([])
        }
        var count = 0
        for i in bookshelfs{
            for j in books{
                if i.name == j.place{
                    twoDimArray[count].append(j)
                }
            }
            count += 1
        }
    }

    
override func viewDidLayoutSubviews() {
super.viewDidLayoutSubviews()
// viewDidLayoutSubviewsではSafeAreaの取得ができている
        topSafeAreaHeight = view.safeAreaInsets.top
print(topSafeAreaHeight)
    }
//MARK: - ナビゲーションバーの右の虫眼鏡が押されたら呼ばれる
    @objc func rightBarBtnClicked(sender: UIButton) {
// 一瞬で切り替わると不自然なのでアニメーションを付与する
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
self.myTableView.contentOffset = CGPoint(x: 0, y: -self.topSafeAreaHeight)
            }, completion: nil)
    }
//MARK: - 渡された文字列を含む要素を検索し、テーブルビューを再表示する
    func searchItems(searchText: String, searchCategory: String) {
//要素を検索する
        if searchText != "" {
            searchResult = items.filter { item in
                if searchCategory == "タイトル"{
                    //return item.title.contains(searchText)
                    return item.title.lowercased().contains(searchText)
                }else if searchCategory == "著者"{
                    //return item.author.contains(searchText)
                    return item.author.lowercased().contains(searchText)
                }else{
                    return true
                }
            } as Array
        } else {
//渡された文字列が空の場合は全てを表示
            searchResult = items
        }
//tableViewを再読み込みする
        myTableView.reloadData()
    }
// MARK: - Search Bar Delegate Methods
    // テキストが変更される毎に呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//検索する
        searchItems(searchText: searchText, searchCategory: searchCategory)
    }
// キャンセルボタンが押されると呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        searchResult = items
//tableViewを再読み込みする
        myTableView.reloadData()
    }
// Searchボタンが押されると呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
//検索する
        searchItems(searchText: searchBar.text! as String, searchCategory: searchCategory)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0{
            searchCategory = scopeList[0]
        }else if selectedScope == 1{
            searchCategory = scopeList[1]
        }
//        searchResult.removeAll()
//        myTableView.reloadData()
        searchItems(searchText: searchBar.text!, searchCategory: searchCategory)
    }
// MARK: - TableView Delegate Methods
    // テーブルビューのセルの数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//テーブルビューのセルの数はmyItems配列の数とした
        return searchResult.count
    }
// テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//myItems配列の中身をテキストにして登録した
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))! as UITableViewCell
        cell.textLabel?.text = self.searchResult[indexPath.row].title
return cell
    }
// テーブルビューのセルが押されたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
print(searchResult[indexPath.row])
    }
}
