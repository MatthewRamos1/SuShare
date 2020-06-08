//
//  AddFriendView.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/4/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit

class AddFriendView: UIView {
        
    public lazy var searchBar: UISearchBar =   {
        let sb = UISearchBar()
        sb.placeholder = "username"
        sb.enablesReturnKeyAutomatically = false
        return sb
    }()
    
    public lazy var tableView: UITableView =   {
        let tv = UITableView(frame: CGRect.zero, style: .plain)
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
        setupSearchBarConstraints()
        setupTableViewConstraints()
    }
    
    private func setupSearchBarConstraints()    {
        addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func setupTableViewConstraints()  {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}
