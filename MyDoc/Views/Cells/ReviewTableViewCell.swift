//
//  ReviewTableViewCell.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/17/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import UIKit

class ReviewTableViewCell: BaseTableViewCell {

    @IBOutlet weak var labelReviewLink: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(review: Review) {
        let reviewLink = (review.bookReviewLink ?? review.sundayReviewLink)
        
        labelReviewLink.text = (reviewLink?.isEmpty ?? true)
            ? "There is not any review link"
            : reviewLink
    }

}
