//
//  Review.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/17/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import SwiftyJSON

class Review: BaseModel {

    var bookReviewLink: String?
    var firstChapterLink: String?
    var sundayReviewLink: String?
    
    required init(json: JSON) {
        super.init()
        
        bookReviewLink = json["book_review_link"].string
        firstChapterLink = json["first_chapter_link"].string
        sundayReviewLink = json["sunday_review_link"].string
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
