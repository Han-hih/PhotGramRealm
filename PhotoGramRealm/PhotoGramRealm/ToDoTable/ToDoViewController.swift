//
//  ToDoViewController.swift
//  PhotoGramRealm
//
//  Created by 황인호 on 2023/09/08.
//

import UIKit
import RealmSwift
import SnapKit

class ToDoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let realm = try! Realm()
    
    let tableView = UITableView()
    
    var list: Results<DetailTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
//        let data = ToDoTable(title: "영화보기", favorite: false)
//
//        let memo = Memo()
//        memo.content = "주말에 팝콘 먹으면서 영화보기"
//        memo.date = Date()
//
//        data.memo = memo
//        try! realm.write {
//            realm.add(data)
//        }
//
//        let data = ToDoTable(title: "장보기", favorite: true)
//        let detail1 = DetailTable(detail: "양파", deadline: Date())
//        let detail2 = DetailTable(detail: "사과", deadline: Date())
//        let detail3 = DetailTable(detail: "고구마", deadline: Date())
//
//        try! realm.write {
//            realm.add(data)
//            data.detail.append(detail1)
//            data.detail.append(detail2)
//            data.detail.append(detail3)
//        }
        print(realm.objects(ToDoTable.self))

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        list = realm.objects(DetailTable.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")!
//        cell.textLabel?.text = "\(list[indexPath.row].title): \(list[indexPath.row].detail.count)개 \(list[indexPath.row].memo?.content ?? "")"'
        let data = list[indexPath.row] // 서브 스크립트 문법
        cell.textLabel?.text = "\(list[indexPath.row].detail) in \(data.mainTodo.first?.title ?? "")"
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let data = list[indexPath.row]
//
//        try! realm.write {
//            //데이터 제거할 때 detail을 먼저 지워주고 data를 지워준다.
//            realm.delete(data.detail)
//            realm.delete(data)
//        }
//        tableView.reloadData()
    }
    
    func createDetail() {
        let main = realm.objects(ToDoTable.self).where {
            $0.title == "장보기"
        }.first!
        for i in 55...80 {
            let detailTodo = DetailTable(detail: "장보기 세부 할일 \(i)", deadline: Date())
            
            try! realm.write {
//                                realm.add(detailTodo)
                main.detail.append(detailTodo)
            }
        }
    }
    
    func createTodo() {
        for i in ["장보기", "영호보기", "리캡하기", "좋아요구현하기", "잠자기"] {
            let data = ToDoTable(title: i, favorite: false)
            
            try! realm.write {
                realm.add(data)
                
            }
        }
        
    }
}
