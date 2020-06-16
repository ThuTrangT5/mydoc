//
//  BaseViewModel.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/16/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import RxSwift

class BaseViewModel: NSObject {

    var isLoading: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    var error: BehaviorSubject<Error?> = BehaviorSubject<Error?>(value: nil)
    public let disposeBag = DisposeBag()
    var isUpdated: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    
    override init() {
        super.init()
        
        self.setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBinding() {
        
    }
}
