//
//  DetailViewController.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/15/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: BaseTableView!
    private let sectionInfo = 0
    private let sectionRank = 1
    private let sectionReview = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        (self.viewModel as? DetailViewModel)?.selectedBook
            .subscribe(onNext: { [weak self](book) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch section {
        case sectionInfo:
            rows = 1
            break
        case sectionRank:
            rows = (self.viewModel as? DetailViewModel)?.getTotalRanksHistory() ?? 0
            rows += (rows > 0) ? 1 : 0 // 1 more row for section title
            break
        case sectionReview:
            rows = (self.viewModel as? DetailViewModel)?.getTotalReviews() ?? 0
            rows += (rows > 0) ? 1 : 0 // 1 more row for section title
            break
        default:
            break
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch indexPath.section {
        case sectionInfo:
            cell = self.cellInfo()
            break
        case sectionRank:
            cell = (indexPath.row == 0)
                ? self.cellSection(type: BookSectionType.ranks)
                : self.cellRank(indexPath: indexPath)
            break
        case sectionReview:
            cell =  (indexPath.row == 0)
                ? self.cellSection(type: BookSectionType.review)
                : self.cellReview(indexPath: indexPath)
            break
        default:
            break
        }
        
        return cell ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == sectionReview  else { return }
        
        let index = indexPath.row - 1 // 1st row for section title
        guard let review = (self.viewModel as? DetailViewModel)?.getReview(atIndex: index) else {
            return
        }
        
        guard let link = review.bookReviewLink ?? review.sundayReviewLink,
            link.isEmpty == false else {
                return
        }
        if let url = URL(string: link),
            UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    // MARK:-
    
    private func cellSection(type: BookSectionType) -> UITableViewCell? {
        guard let section = tableView.dequeueReusableCell(withIdentifier: BookSectionTableViewCell.cellIdentifier) as? BookSectionTableViewCell else {
            return nil
        }
        
        section.sectionType = type
        
        return section
    }
    
    private func cellInfo() -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookInfoTableViewCell.cellIdentifier) as? BookInfoTableViewCell else {
            return nil
        }
        
        if let book = try? (self.viewModel as? DetailViewModel)?.selectedBook.value() {
            cell.bindData(book: book)
        }
        
        return cell
    }
    
    private func cellRank(indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewCell.cellIdentifier) as? RankTableViewCell else {
            return nil
        }
        
        let index = indexPath.row - 1 // 1st row for section title
        if let rank = (self.viewModel as? DetailViewModel)?.getRank(atIndex: index) {
            cell.bindData(rank: rank)
        }
        
        return cell
    }
    
    private func cellReview(indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.cellIdentifier) as? ReviewTableViewCell else {
            return nil
        }
        
        let index = indexPath.row - 1 // 1st row for section title
        if let review = (self.viewModel as? DetailViewModel)?.getReview(atIndex: index) {
            cell.bindData(review: review)
        }
        
        return cell
    }
}
