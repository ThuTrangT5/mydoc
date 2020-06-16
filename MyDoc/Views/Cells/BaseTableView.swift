//
//  BaseTableView.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/16/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {
    
    private var refresh: UIRefreshControl?
    
    var didHandleRefresh: (()->Void)? = nil
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateStyle()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.updateStyle()
    }
    
    func updateStyle() {
        self.backgroundColor = UIColor.white
        self.rowHeight = UITableView.automaticDimension
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        self.showsVerticalScrollIndicator = false
        
        if self.refresh == nil {
            let refresh = UIRefreshControl()
            refresh.tintColor = UIColor(red: 255.0/255.0, green: 157.0/255.0, blue: 4.0/255.0, alpha: 1)
            refresh.addTarget(self, action: #selector(self.didReloadData), for: .valueChanged)
            self.addSubview(refresh)
            self.refresh = refresh
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func didReloadData() {
        self.refresh?.endRefreshing()
        self.didHandleRefresh?()
    }
}
