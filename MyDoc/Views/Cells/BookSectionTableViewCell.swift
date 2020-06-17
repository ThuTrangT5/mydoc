//
//  BookSectionTableViewCell.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/17/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import UIKit

enum BookSectionType: String {
    case review = "Reviews"
    case ranks = "Ranks history"
    case unknown
}

class BookSectionTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    var sectionType: BookSectionType = .unknown {
        didSet {
            self.labelTitle.text = sectionType.rawValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }
    
}
