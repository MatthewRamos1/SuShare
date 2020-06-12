//
//  DetailAddFriendView.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/5/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class DetailAddFriendView: UIView {
    
    override func layoutSubviews() {
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.layer.borderWidth = 1.5
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height / 2
        profilePictureImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    public lazy var profilePictureImageView: UIImageView =    {
        guard let currentUser = Auth.auth().currentUser else    {
            fatalError("No Current User")
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.height * 0.2), height: (UIScreen.main.bounds.size.height * 0.2)))
        
        if let currentUserProfilePhotoURL = currentUser.photoURL {
            imageView.kf.setImage(with: currentUserProfilePhotoURL)
        }   else    {
            imageView.image = UIImage(systemName: "person.fill")
        }
        
        imageView.backgroundColor = .systemTeal
        imageView.layoutSubviews()
        
        return imageView
    }()
    
    public lazy var addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Friend", for: .normal)
        button.backgroundColor = .systemGray6
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
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
        setupProfilePictureViewConstraints()
        setupUsernameLabelConstraints()
        setupEmailLabelConstraints()
        setupAddFriendButtonConstraints()
    }
    
    private func setupProfilePictureViewConstraints()   {
        addSubview(profilePictureImageView)
        profilePictureImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY)
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.2)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.height * 0.2)
        }
    }
    
    private func setupUsernameLabelConstraints()    {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profilePictureImageView.snp.bottom).offset(11)
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
    
    private func setupAddFriendButtonConstraints()  {
        addSubview(addFriendButton)
        addFriendButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailLabel.snp.bottom).offset(11)
            make.width.equalTo(200)
        }
    }
    
}
