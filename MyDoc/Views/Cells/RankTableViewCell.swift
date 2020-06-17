//
//  RankTableViewCell.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/17/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import UIKit

class RankTableViewCell: BaseTableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPublishDate: UILabel!
    @IBOutlet weak var labelBestSellerDate: UILabel!
    @IBOutlet weak var labelRank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(rank: Rank) {
        labelName.text = rank.name
        labelPublishDate.text = "Publish date: " + (rank.publishedDate ?? "")
        labelBestSellerDate.text = "Best seller date: " + (rank.bestsellersDate ?? "")
        labelRank.text = "Rank: \(rank.rank)"
    }

}
