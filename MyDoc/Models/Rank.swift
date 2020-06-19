//
//  Rank.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/17/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import SwiftyJSON
import CoreData

class Rank: BaseModel {
    
    var name: String?
    var rank: Int = 0
    var publishedDate: String?
    var bestsellersDate: String?
    
    required init(json: JSON) {
        super.init()
        
        name = json["display_name"].string
        rank = json["rank"].intValue
        publishedDate = json["published_date"].string
        bestsellersDate = json["bestsellers_date"].string
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(managedObject: NSManagedObject) {
        fatalError("init(managedObject:) has not been implemented")
    }
    
    func createOrUpdateEntity(withBookID: String? = nil) -> NSManagedObject? {
        let object = CoreDataManager.shared.createOrUpdateEntity(entityName: "Rank", keyName: "bookID", keyValue: withBookID ?? "")
        
        object?.setValue(name, forKeyPath: "name")
        object?.setValue(rank, forKeyPath: "rank")
        object?.setValue(publishedDate, forKeyPath: "publishedDate")
        object?.setValue(bestsellersDate, forKeyPath: "bestsellersDate")
        
        if let bookID = withBookID {
            object?.setValue(bookID, forKeyPath: "bookID")
        }
        
        return object
    }
}
