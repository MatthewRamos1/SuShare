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
    
//    public func setupProfileUI()  {
//        guard let currentUser = Auth.auth().currentUser else    {
//            fatalError("No Current User")
//        }
//
//        if let currentUserDisplayName = currentUser.displayName, let currentUserProfilePhotoURL = currentUser.photoURL {
//            usernameLabel.text = currentUserDisplayName
//            profilePictureImageView.kf.setImage(with: currentUserProfilePhotoURL)
//        }   else    {
//            usernameLabel.text = currentUser.email
//            profilePictureImageView.image = UIImage(systemName: "person.fill")
//        }
//    }
    
    public lazy var profilePictureImageView: UIImageView =  {
        guard let currentUser = Auth.auth().currentUser else    {
            fatalError("No Current User")
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.height * 0.085), height: (UIScreen.main.bounds.size.height * 0.085)))
        
        if let currentUserProfilePhotoURL = currentUser.photoURL {
            imageView.kf.setImage(with: currentUserProfilePhotoURL)
        }   else    {
            imageView.image = UIImage(systemName: "person.fill")
        }
        
        imageView.backgroundColor = .systemTeal
        imageView.layoutSubviews()
        return imageView
    }()
    
    public lazy var usernameLabel: UILabel =   {
        guard let currentUser = Auth.auth().currentUser else    {
            fatalError("No Current User")
        }
        
        let label = UILabel()
        
        if let currentUserDisplayName = currentUser.displayName {
            label.text = currentUserDisplayName
        }   else    {
            label.text = currentUser.email
        }
        
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        setupProfilePictureImageViewConstraints()
        setupUsernameLabelConstraints()
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
    
}
