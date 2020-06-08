//
//  DetailAddFriendView.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/5/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit

class DetailAddFriendView: UIView {
    
    public lazy var addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Friend", for: .normal)
        return button
    }()
    
    public lazy var usernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public lazy var emailLabel: UILabel =   {
        let label = UILabel()
        return label
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
        setupAddFriendButtonConstraints()
        setupUsernameLabelConstraints()
        setupEmailLabelConstraints()
    }
    
    private func setupAddFriendButtonConstraints()  {
        addSubview(addFriendButton)
        addFriendButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupUsernameLabelConstraints()    {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addFriendButton.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupEmailLabelConstraints()   {
        addSubview(emailLabel)
        emailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
    }
    
}
