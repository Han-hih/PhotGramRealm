//
//  ToDoTable.swift
//  PhotoGramRealm
//
//  Created by 황인호 on 2023/09/08.
//

import UIKit
import RealmSwift

class ToDoTable: Object { // 부모처럼 역할을 하고있다     큰 할일
    
    //복사해서 가지고온뒤 원하는 컬럼명으로 바꿔주면 된다.
    
    @Persisted(primaryKey: true) var _id: ObjectId // primary키 설정 /없어도 상관은 없지만 정확한 값 분별이 힘들다.
    @Persisted var title: String
    @Persisted var favorite: Bool
    //To Many Relationship
    @Persisted var detail: List<DetailTable> //배열 형태이기 때문에 빈배열이 들어간다.
    
    //To One Relationship: EmbeddedObject(무조건 옵셔널 필수) , 별도의 테이블이 생성되는 형ㅌ태는 아님
    @Persisted var memo: Memo?
    
    convenience init(title: String, favorite: Bool) {
        self.init()
        
        self.title = title
        self.favorite = favorite
        
    }
}
class DetailTable: Object { // 작은 할 일
    @Persisted(primaryKey: true) var _id: ObjectId // primary키 설정 /없어도 상관은 없지만 정확한 값 분별이 힘들다.
    @Persisted var detail: String
    @Persisted var deadline: Date
    
    //Inverse Relationship ProPerty (LinkingObjects)
    @Persisted(originProperty: "detail") var mainTodo: LinkingObjects<ToDoTable> // 링킹오브젝트는 list로 엮여있을 때 사용가능
    
    convenience init(detail: String, deadline: Date) {
        self.init()
        
        self.detail = detail
        self.deadline = deadline
    }
    
}

class Memo: EmbeddedObject {
    @Persisted var content: String
    @Persisted var date: Date
}
// 큰할일에서 작은할일로 단방향통신
