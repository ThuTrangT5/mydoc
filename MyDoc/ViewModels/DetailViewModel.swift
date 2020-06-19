//
//  DetailViewModel.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/17/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import RxSwift

class DetailViewModel: BaseViewModel {
    
    var selectedBook: BehaviorSubject<Book?> = BehaviorSubject<Book?>(value: nil)
    
    init(book: Book) {
        
        super.init()
        self.selectedBook.onNext(book)
        if NetworkManager.shared.isOnline() == false {
            self.getAllReviews()
            self.getAllRanks()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getAllReviews() {
        guard let bookID = (try? self.selectedBook.value())?.title else {
            return
        }
        
        CoreDataManager.shared.getAllReviews(forBookID: bookID) { [weak self](reviews, error) in
            if reviews.isEmpty == false,
                let book = try? self?.selectedBook.value() {
                book.reviews = reviews
                self?.selectedBook.onNext(book)
                self?.isUpdated.onNext(true)
            }
        }
    }
    
    func getAllRanks() {
        guard let bookID = (try? self.selectedBook.value())?.title else {
            return
        }
        
        CoreDataManager.shared.getAllRanks(forBookID: bookID) { [weak self](ranks, error) in
            if ranks.isEmpty == false,
                let book = try? self?.selectedBook.value() {
                book.ranksHistory = ranks
                self?.selectedBook.onNext(book)
                self?.isUpdated.onNext(true)
            }
        }
    }
    
    func getTotalReviews() -> Int {
        guard let selected = try? self.selectedBook.value() else {
            return 0
        }
        
        return selected.reviews.count
    }
    
    func getTotalRanksHistory() -> Int {
        guard let selected = try? self.selectedBook.value() else {
            return 0
        }
        
        return selected.ranksHistory.count
    }
    
    func getReview(atIndex i: Int) -> Review? {
        guard let selected = try? self.selectedBook.value() else {
            return nil
        }
        
        guard i >= 0 && i < selected.reviews.count else {
            return nil
        }
        
        return selected.reviews[i]
    }
    
    func getRank(atIndex i: Int) -> Rank? {
        guard let selected = try? self.selectedBook.value() else {
            return nil
        }
        
        guard i >= 0 && i < selected.ranksHistory.count else {
            return nil
        }
        
        return selected.ranksHistory[i]
    }
}
