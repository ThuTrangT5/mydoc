//
//  ListViewModel.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/16/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import RxSwift

class ListViewModel: BaseViewModel {
    var books: BehaviorSubject<[Book]> = BehaviorSubject<[Book]>(value: [])
    private var numberOfBook: Int = 0
    
    var currentPage: Int = 0
    private var hasMoreData = true
    
    override init() {
        super.init()
        
        self.getBooks(page: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getBooks(page: Int) {
        
        self.isLoading.onNext(true)
        
        if NetworkManager.shared.isOnline() {
            APIManager.shared.getListBook(page: page) { [weak self](books, error) in
                self?.getBookHandler(books: books, error: error, atPage: page)
            }
        } else {
            CoreDataManager.shared.getListBook(page: page) { [weak self](books, error) in
                self?.getBookHandler(books: books, error: error, atPage: page)
            }
        }
        //
        //
        //        //        APIManager.shared.getListBook(page: page) { [weak self](books, error) in
        //        CoreDataManager.shared.getListBook(page: page) { [weak self](books, error) in
        //            self?.isLoading.onNext(false)
        //            self?.currentPage = page
        //
        //            if let error = error {
        //                self?.error.onNext(error)
        //
        //            } else if books.isEmpty == false {
        //                var currentBooks = (try? self?.books.value()) ?? []
        //                currentBooks.append(contentsOf: books)
        //                self?.books.onNext(currentBooks)
        //                self?.isUpdated.onNext(true)
        //                self?.numberOfBook += books.count
        //
        //                self?.saveToLocal(books: books)
        //
        //            } else {
        //                self?.hasMoreData = false
        //            }
        //        }
    }
    
    private func getBookHandler(books: [Book], error: Error?, atPage page: Int) {
        self.isLoading.onNext(false)
        self.currentPage = page
        
        if let error = error {
            self.error.onNext(error)
            
        } else if books.isEmpty == false {
            var currentBooks = (try? self.books.value()) ?? []
            currentBooks.append(contentsOf: books)
            self.books.onNext(currentBooks)
            self.isUpdated.onNext(true)
            self.numberOfBook += books.count
            
            if NetworkManager.shared.isOnline() {
                // save to local
                self.saveToLocal(books: books)
            }
            
            print("NOW there are \(numberOfBook) books")
            
        } else {
            self.hasMoreData = false
        }
    }
    
    func saveToLocal(books: [Book]) {
        CoreDataManager.shared.saveAllData(books: books)
    }
    
    func loadMore() {
        if self.hasMoreData == false {
            return
        }
        
        self.getBooks(page: self.currentPage + 1)
    }
    
    func reload() {
        self.books.onNext([])
        self.hasMoreData = true
        self.currentPage = 0
        self.numberOfBook = 0
        self.getBooks(page: 1)
    }
    
    func getBook(atIndex i: Int) -> Book? {
        guard let currentBooks = try? self.books.value() else {
            return nil
        }
        
        let total = currentBooks.count
        guard i >= 0 && i < total else {
            return nil
        }
        
        return currentBooks[i]
    }
    
    func getNumberOfCurrentBook() -> Int {
        return self.numberOfBook
    }
    
    
}
