//
//  BaseModel.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/16/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import SwiftyJSON
import CoreData

class BaseModel: NSObject {
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getArray<T: BaseModel>(json: JSON) -> [T] {
        
        var result: [T] = []
        let items = json.arrayValue
        for i in items {
            let model = T(json: i)
            result.append(model)
        }
        
        return result
    }
    
    static func getArray<T: BaseModel> (managedObjects: [NSManagedObject]) -> [T] {
        var result: [T] = []
        for obj in managedObjects {
            if let model = T(managedObject: obj) {
                result.append(model)
            }
        }
        
        return result
    }
    
    required init?(managedObject: NSManagedObject) {
        return nil
    }
}
