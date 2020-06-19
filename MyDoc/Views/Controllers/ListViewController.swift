//
//  ListViewController.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/16/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import UIKit
import RxSwift

class ListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: BaseTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NetworkManager.shared.networkStatusChangedHandler = { [weak self](changed) in
            if changed {
                (self?.viewModel as? ListViewModel)?.reload()
                
                self?.navigationItem.rightBarButtonItem?.title = NetworkManager.shared.isOnline()
                    ? "Online"
                    : "Offline"
            }
        }
        
        NetworkManager.shared.startMonitoring()
    }
    
    override func setupUI() {
        self.viewModel = ListViewModel()
        
        super.setupUI()
        self.setupNavigationBar()
        self.setupTableView()
        
        self.viewModel?.isUpdated
            .subscribe(onNext: { [weak self](updated) in
                if updated {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func setupNavigationBar() {
        
        self.title = "Best Sellers"
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4;
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.navigationController?.navigationBar.layer.shadowRadius = 7
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = kTintColor
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.init(name: "AvenirNext-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        ]
    }
    
    
    func setupTableView() {
        
        self.tableView.didHandleRefresh = { [weak self] () in
            (self?.viewModel as? ListViewModel)?.reload()
        }
        
        (self.viewModel as? ListViewModel)?.books
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: BookSumaryTableViewCell.self)) { (row, model,cell) in
                cell.bindData(book: model)
        }
        .disposed(by: disposeBag)
        
        self.tableView.rx
            .willDisplayCell
            .asObservable()
            .subscribe(onNext: { [weak self](cell, indexPath) in
                guard let viewModel = self?.viewModel as? ListViewModel else {
                    return
                }
                let total = viewModel.getNumberOfCurrentBook()
                if total > 0 && indexPath.row == total - 1 {
                    viewModel.loadMore()
                }
            })
            .disposed(by: disposeBag)
        
        self.tableView.rx
            .modelSelected(Book.self)
            .subscribe(onNext: { [weak self](book) in
                self?.performSegue(withIdentifier: "segueDetail", sender: book)
            })
            .disposed(by: disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController,
            let book = sender as? Book {
            
            let viewModel = DetailViewModel()
            viewModel.selectedBook.onNext(book)
            detailVC.viewModel = viewModel
            
        }
    }
    
}
