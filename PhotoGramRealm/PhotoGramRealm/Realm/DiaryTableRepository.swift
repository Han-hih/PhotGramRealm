//
//  DiaryTableRepository.swift
//  PhotoGramRealm
//
//  Created by 황인호 on 2023/09/06.
//

import UIKit
import RealmSwift

protocol DiaryTableRepositoryType: AnyObject {
    func fetch() -> Results<DiaryTable>
    func fetchFilter() -> Results<DiaryTable>
    func createItem(_ item: DiaryTable)
}


class DiaryTableRepository: DiaryTableRepositoryType {
    
   private let realm = try! Realm()
    
    private func a() { // => 다른 파일에서 쓸 일 없고, 클래스 안에서만 쓸 수 있음 => 오버라이딩 불가능 => final 키워드를 잠재적으로 유추
        
    }
    
    // 버전관련
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    func fetch() -> Results<DiaryTable> {
       let data = realm.objects(DiaryTable.self).sorted(byKeyPath: "diaryDate", ascending: true)
        return data
    }
    
    func fetchFilter() -> Results<DiaryTable> {
        //  정렬을 해서 필터를 할 수도 있다.
        let result = realm.objects(DiaryTable.self).where {
           
            $0.photo != nil
        }
        return result
    }
    
    func createItem(_ item: DiaryTable) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func updateItem(id: ObjectId, title: String, contents: String) {
        
        do {
            try realm.write {
                
                realm.create(DiaryTable.self, value: ["_id": id, "diaryTitle": title, "diaryContents": contents], update: .modified)
                
            }
        } catch {
            print("") //
        }
//        try! realm.write {
//            realm.add(item, update: .modified)
//        }
    }
    
}
