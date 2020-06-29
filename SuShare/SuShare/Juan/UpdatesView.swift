//
//  UpdatesView.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/28/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit

class UpdatesView: UIView {
        
    public lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit()   {
        setupTableViewConstraints()
    }
    
    private func setupTableViewConstraints()    {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}
