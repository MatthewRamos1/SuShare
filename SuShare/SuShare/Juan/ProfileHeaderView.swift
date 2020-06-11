//
//  HeaderView2.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/1/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class ProfileHeaderView: UICollectionReusableView  {
    
    override func layoutSubviews() {
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.layer.borderWidth = 1.25
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height / 2
        profilePictureImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    public func determineUserUI(user: User)  {
        usernameLabel.text = user.username
    }
    
    public lazy var profilePictureImageView: UIImageView =  {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.height * 0.085), height: (UIScreen.main.bounds.size.height * 0.085)))
            imageView.image = UIImage(systemName: "person.fill")
        imageView.backgroundColor = .systemTeal
        imageView.layoutSubviews()
        return imageView
    }()
    
    public lazy var usernameLabel: UILabel =   {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    public lazy var addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Friend", for: .normal)
        return button
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
        setupProfilePictureImageViewConstraints()
        setupUsernameLabelConstraints()
        setupAddFriendButtonConstraints()
    }
    
    private func setupProfilePictureImageViewConstraints() {
        addSubview(profilePictureImageView)
        profilePictureImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(11)
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.085)
            make.left.equalTo(self.snp.left).offset(11)
            make.width.equalTo(UIScreen.main.bounds.size.height * 0.085)
        }
    }
    
    private func setupUsernameLabelConstraints()    {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profilePictureImageView.snp.right).offset(11)
            make.centerY.equalTo(profilePictureImageView.snp.centerY)
        }
    }
    
    private func setupAddFriendButtonConstraints()  {
        addSubview(addFriendButton)
        addFriendButton.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom).offset(8)
            make.left.equalTo(profilePictureImageView.snp.right).offset(11)
        }
    }
    
}
