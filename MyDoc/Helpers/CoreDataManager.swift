//
//  CoreDataManager.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/19/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import CoreData

class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyDoc")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    // MARK: - Core Data Saving support
    
    func saveContext () {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createOrUpdateEntity(entityName: String, keyName: String, keyValue: String) -> NSManagedObject? {
        
        let filterString = "\(keyName) = \(keyValue)"
        
//        print("CreateOrUpdateEntity\n\(filterString)")
        
        let predicate = NSPredicate(format: "\(keyName) = %@", keyValue)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchOffset = 0
        
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty == false {
                return results.first
            } else {
                return self.createNewEntity(entityName: entityName)
            }
            
        } catch let error {
            print("Could not fetch. \(error), \(error.localizedDescription)")
            
            return nil
        }
    }
    
    func createNewEntity(entityName: String) -> NSManagedObject? {
//        print("createNewEntity => \(entityName)")
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.context) else {
            return nil
        }
        
        let object = NSManagedObject(entity: entity, insertInto: self.context)
        return object
    }
    
    func saveAllData(books: [Book]) {
//        _ = books.map { $0.createOrUpdateEntry() }
        
        for book in books {
            _ = book.createOrUpdateEntity()
            
            _ = book.reviews.map {
                $0.createOrUpdateEntity(withBookID: book.title)
            }
            
            _ = book.ranksHistory.map {
                $0.createOrUpdateEntity(withBookID: book.title)
            }
        }
        
         self.saveContext()
    }
    
    func saveBook(books: [Book]) {
        _ = books.map { $0.createOrUpdateEntity() }
        self.saveContext()
    }
    
    func saveReviews(reviews: [Review], forBook book: Book) {
        _ = reviews.map {
            $0.createOrUpdateEntity(withBookID: book.title)
        }
        
        self.saveContext()
    }
    
    func saveRanks(ranks: [Review], forBook book: Book) {
        _ = ranks.map {
            $0.createOrUpdateEntity(withBookID: book.title)
        }
        
        self.saveContext()
    }
    
    func getAllReviews(forBookID bookID: String, callback: (([Review], Error?) -> Void)?) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Review")
        let predicate = NSPredicate(format: "bookID BEGINSWITH %@", bookID)
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest)
            let reviews: [Review] = Review.getArray(managedObjects: results)
            callback?(reviews, nil)
            
        } catch let error {
            print("Could not fetch. \(error), \(error.localizedDescription)")
            
            callback?([], error)
        }
    }
    
    func getAllRanks(forBookID bookID: String, callback: (([Rank], Error?) -> Void)?) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Rank")
        let predicate = NSPredicate(format: "bookID BEGINSWITH %@", bookID)
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest)
            let ranks: [Rank] = Rank.getArray(managedObjects: results)
            callback?(ranks, nil)
            
        } catch let error {
            print("Could not fetch. \(error), \(error.localizedDescription)")
            
            callback?([], error)
        }
    }
}

extension CoreDataManager: BookAPIProtocol {
    
    func getListBook(page: Int, callback: (([Book], Error?) -> Void)?) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Book")
        fetchRequest.fetchLimit = kLimitItemPerPage
        fetchRequest.fetchOffset = (page - 1) * kLimitItemPerPage
        
        do {
            let results = try context.fetch(fetchRequest)
            let books: [Book] = Book.getArray(managedObjects: results)
            callback?(books, nil)
            
        } catch let error {
            print("Could not fetch. \(error), \(error.localizedDescription)")
            
            callback?([], error)
        }
    }
}
