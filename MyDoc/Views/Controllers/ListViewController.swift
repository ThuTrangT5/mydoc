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
    }
    
    override func setupUI() {
        self.viewModel = ListViewModel()
        
        super.setupUI()
        
        self.viewModel?.isUpdated
            .subscribe(onNext: { [weak self](updated) in
                if updated {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        self.setupTableView()
        
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.didHandleRefresh = { [weak self] () in
            (self?.viewModel as? ListViewModel)?.reload()
        }
    }
    
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel as? ListViewModel else {
            return 0
        }
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if let bookSummary = cell as? BookSumaryTableViewCell,
            let book = (self.viewModel as? ListViewModel)?.getBook(atIndex: indexPath.row) {
            bookSummary.bindData(book: book)
        }
        
        return cell ?? UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel as? ListViewModel else {
            return
        }
        
        let total = viewModel.books.count
        if indexPath.row == total - 1 {
            viewModel.loadMore()
        }
    }
}
