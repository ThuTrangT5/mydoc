//
//  BookInfoTableViewCell.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/17/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import UIKit

class BookInfoTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelContributor: UILabel!
    @IBOutlet weak var labelPublisher: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData(book: Book) {
        labelTitle.text = book.title
        labelDescription.text = book.desc
        labelAuthor.text = "Author: " + (book.author ?? "")
        labelContributor.text = "Contributor: " + (book.contributor ?? "")
        labelPublisher.text = "Publisher: " + (book.publisher ?? "")
    }
    
}
