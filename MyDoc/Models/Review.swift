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
        guard managedObject.entity.name == "Review" else {
            return nil
        }
        
        super.init()
        self.bookReviewLink = managedObject.value(forKey: "bookReviewLink") as? String
        self.firstChapterLink = managedObject.value(forKey: "firstChapterLink") as? String
        self.sundayReviewLink = managedObject.value(forKey: "sundayReviewLink") as? String
    }
    
    func createOrUpdateEntity(withBookID: String? = nil) -> NSManagedObject? {
        
        var primaryValue = ""
        if let bookID = withBookID {
            primaryValue += bookID + "_"
            primaryValue += bookReviewLink ?? ""
        }
        
        let object = CoreDataManager.shared.createOrUpdateEntity(entityName: "Review", keyName: "bookID", keyValue: primaryValue)
        
        object?.setValue(bookReviewLink, forKeyPath: "bookReviewLink")
        object?.setValue(firstChapterLink, forKeyPath: "firstChapterLink")
        object?.setValue(sundayReviewLink, forKeyPath: "sundayReviewLink")
        
        object?.setValue(primaryValue, forKeyPath: "bookID")
        
        return object
    }
    
}
