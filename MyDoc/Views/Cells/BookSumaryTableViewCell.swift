//
//  BookSumaryTableViewCell.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/16/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import UIKit

class BookSumaryTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelPublishDate: UILabel!
    @IBOutlet weak var labelRank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .gray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData(book: Book) {
        
        labelTitle.text = book.title
        labelAuthor.text = "Author: " + (book.author ?? "")
        labelPublishDate.text = "Publisher: " + (book.publisher ?? "")
        if let rank = book.ranksHistory.first?.rank {
            labelRank.text = "Rank: \(rank)"
        } else {
            labelRank.text = nil
        }
    }
    
}
