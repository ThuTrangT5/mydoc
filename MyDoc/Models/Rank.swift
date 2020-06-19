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
        guard managedObject.entity.name == "Rank" else {
            return nil
        }
        
        super.init()
        
        self.name = managedObject.value(forKey: "name") as? String
        self.rank = (managedObject.value(forKey: "rank") as? Int) ?? 0
        self.publishedDate = managedObject.value(forKey: "publishedDate") as? String
        self.bestsellersDate = managedObject.value(forKey: "bestsellersDate") as? String
    }
    
    func createOrUpdateEntity(withBookID: String? = nil) -> NSManagedObject? {
        
        var primaryValue = ""
        if let bookID = withBookID {
            primaryValue += bookID + "_"
            primaryValue += (self.name ?? "") + "_"
            primaryValue += (self.publishedDate ?? "") + "_"
        }
        
        let object = CoreDataManager.shared.createOrUpdateEntity(entityName: "Rank", keyName: "bookID", keyValue: primaryValue)
        
        object?.setValue(name, forKeyPath: "name")
        object?.setValue(rank, forKeyPath: "rank")
        object?.setValue(publishedDate, forKeyPath: "publishedDate")
        object?.setValue(bestsellersDate, forKeyPath: "bestsellersDate")
        object?.setValue(primaryValue, forKeyPath: "bookID")
       
        
        return object
    }
}
