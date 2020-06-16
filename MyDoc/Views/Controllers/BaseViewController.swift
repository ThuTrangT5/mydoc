//
//  BaseViewController.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/16/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var viewModel: BaseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        
        if let viewModel = viewModel {
            self.bindingBaseRx(withViewModel: viewModel, disposeBag: disposeBag)
        }
    }
    
    func startAnimating(){
        if let activityLoader = self.view.viewWithTag(999) as? UIActivityIndicatorView {
            activityLoader.startAnimating()
            return
        }
        
        let activityLoader = UIActivityIndicatorView(style: .large)
        activityLoader.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityLoader.center = self.view.center
        activityLoader.tag = 999
        activityLoader.tintColor = UIColor(red: 255.0/255.0, green: 157.0/255.0, blue: 4.0/255.0, alpha: 1)
        self.view.addSubview(activityLoader)
        activityLoader.startAnimating()
        
    }
    func stopAnimating() {
        if let activityLoader = self.view.viewWithTag(999) as? UIActivityIndicatorView {
            activityLoader.stopAnimating()
            activityLoader.removeFromSuperview()
        }
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    func bindingBaseRx(withViewModel viewModel: BaseViewModel, disposeBag: DisposeBag) {
        // binding loading && error
        viewModel.isLoading
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe(onNext: { [weak self](error) in
                if let error = error {
                    self?.showErrorMessage(message: error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}


extension Reactive where Base: BaseViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
}
