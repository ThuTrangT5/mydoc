//
//  Book.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/15/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import SwiftyJSON

enum BookType: String {
    case ebook = "e-book-fiction"
    case hardcover = "hardcover-fiction"
}

class Book: BaseModel {

    var title: String?
    var desc: String?
    var contributor: String?
    var author: String?
    var publisher: String?
    var price: NSNumber?
    
    var ranksHistory: [Rank] = []
    var reviews: [Review] = []
    
    required init(json: JSON) {
        super.init()
        
        title = json["title"].string
        desc = json["description"].string
        contributor = json["contributor"].string
        author = json["author"].string
        publisher = json["publisher"].string
        price = json["price"].number
        
        let reviewsJson = json["reviews"]
        if reviewsJson.isEmpty == false {
            reviews = Review.getArray(json: reviewsJson)
        }
        
        let ranksJson = json["ranks_history"]
        if ranksJson.isEmpty == false {
            ranksHistory = Rank.getArray(json: ranksJson)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
