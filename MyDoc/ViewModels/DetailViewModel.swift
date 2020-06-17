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
