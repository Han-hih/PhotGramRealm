//
//  RealmModel.swift
//  PhotoGramRealm
//
//  Created by 황인호 on 2023/09/04.
//

import Foundation
import RealmSwift //realm말고 realmswift

//   ID(필수) 제목(필수) 날짜(필수) 내용(옵션) 사진url(옵션)

class DiaryTable: Object {
    //복사해서 가지고온뒤 원하는 컬럼명으로 바꿔주면 된다.
    
    @Persisted(primaryKey: true) var _id: ObjectId // primary키 설정
    @Persisted var diaryTitle: String //일기 제목(필수)
    @Persisted var diaryDate: Date //일기 등록 날짜(필수)
    @Persisted var contents: String? //일기내용(옵셔널)
    @Persisted var photo: String? //사진URL(옵션)
    @Persisted var diaryLike: Bool // 즐겨찾기 기능(필수)
//    @Persisted var diaryPin: Bool // 새로 추가
    @Persisted var diarySummary: String
    
    
    convenience init(diaryTitle: String, diaryDate: Date, diaryContents: String? = nil, diaryPhoto: String? = nil) {
        self.init()
        
        self.diaryTitle = diaryTitle
        self.diaryDate = diaryDate
        self.contents = diaryContents
        self.photo = diaryPhoto
        self.diaryLike = true
        self.diarySummary = "제목은 '\(diaryTitle)'이고, 내용은 '\(diaryContents ?? "")'입니다"
    }
    
    
}

