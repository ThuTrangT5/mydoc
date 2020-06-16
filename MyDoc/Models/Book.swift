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
    var publishedDate: String?
    var price: NSNumber?
    var amazonLink: String?
    var rank: Int = 0
    
    required init(json: JSON) {
        super.init()
        
        let book_details = json["book_details"].arrayValue.first
        title = book_details?["title"].string
        desc = book_details?["description"].string
        contributor = book_details?["contributor"].string
        author = book_details?["author"].string
        publisher = book_details?["publisher"].string
        price = book_details?["price"].number
        
        publishedDate = json["published_date"].string
        rank = json["rank"].intValue
        amazonLink = json["amazon_product_url"].string
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
