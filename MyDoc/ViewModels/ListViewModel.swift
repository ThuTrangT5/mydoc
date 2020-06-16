//
//  ListViewModel.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/16/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import RxSwift

class ListViewModel: BaseViewModel {
    var books: [Book] = []
    var selectedBook: BehaviorSubject<Book?> = BehaviorSubject<Book?>(value: nil)
    var currentPage: Int = 0
    var type: BookType = .ebook
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
        APIManager.shared.getListBook(type: self.type, page: page) { [weak self](books, error) in
            self?.isLoading.onNext(false)
            self?.currentPage = page
            
            if let error = error {
                self?.error.onNext(error)
                
            } else if books.isEmpty == false {
                self?.books.append(contentsOf: books)
                self?.isUpdated.onNext(true)
                
            } else {
                self?.hasMoreData = false
            }
        }
    }
    
    func loadMore() {
        if self.hasMoreData == false {
            return
        }
        
        self.getBooks(page: self.currentPage + 1)
    }
    
    func reload() {
        self.books.removeAll()
        self.hasMoreData = true
        self.currentPage = 0
        self.getBooks(page: 1)
    }
    
    func getBook(atIndex i: Int) -> Book? {
        let total = self.books.count
        guard i >= 0 && i < total else {
            return nil
        }
        
        return books[i]
    }
    
}
