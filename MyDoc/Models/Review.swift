//
//  Review.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/17/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import SwiftyJSON
import CoreData

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
    
    required init?(managedObject: NSManagedObject) {
        fatalError("init(managedObject:) has not been implemented")
    }
    
    func createOrUpdateEntity(withBookID: String? = nil) -> NSManagedObject? {
        let object = CoreDataManager.shared.createOrUpdateEntity(entityName: "Review", keyName: "bookID", keyValue: withBookID ?? "")
        
        object?.setValue(bookReviewLink, forKeyPath: "bookReviewLink")
        object?.setValue(firstChapterLink, forKeyPath: "firstChapterLink")
        object?.setValue(sundayReviewLink, forKeyPath: "sundayReviewLink")
        
        if let bookID = withBookID {
            object?.setValue(bookID, forKeyPath: "bookID")
        }
        
        return object
    }
    
}
