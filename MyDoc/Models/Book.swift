//
//  Book.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/15/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import SwiftyJSON
import CoreData

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
    
    var ranksHistory: [Rank] = []
    var reviews: [Review] = []
    
    required init(json: JSON) {
        super.init()
        
        title = json["title"].string
        desc = json["description"].string
        contributor = json["contributor"].string
        author = json["author"].string
        publisher = json["publisher"].string
        
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
    
    required init?(managedObject: NSManagedObject) {

        guard managedObject.entity.name == "Book" else {
            return nil
        }
        
        super.init()
        self.title = managedObject.value(forKey: "title") as? String
        self.desc = managedObject.value(forKey: "desc") as? String
        self.contributor = managedObject.value(forKey: "contributor") as? String
        self.author = managedObject.value(forKey: "author") as? String
        self.publisher = managedObject.value(forKey: "publisher") as? String

    }
    
    
    func createOrUpdateEntity() -> NSManagedObject? {
        let object = CoreDataManager.shared.createOrUpdateEntity(entityName: "Book", keyName: "title", keyValue: self.title ?? "")

        object?.setValue(title, forKeyPath: "title")
        object?.setValue(desc, forKeyPath: "desc")
        object?.setValue(contributor, forKeyPath: "contributor")
        object?.setValue(author, forKeyPath: "author")
        object?.setValue(publisher, forKeyPath: "publisher")
        
        return object
    }
}
