//
//  AddFriendCell.swift
//  SuShare
//
//  Created by Juan Ceballos on 7/1/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit

class AddFriendCell: UITableViewCell    {
    
    override func layoutSubviews() {
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.layer.borderWidth = 1.00
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
        profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    public lazy var usernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12)
        return label
    }()
    
    public lazy var profilePhotoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.height * 0.0085, height: UIScreen.main.bounds.size.height * 0.0085))
        return imageView
    }()
    
    public func configureCell(user: User)    {
        usernameLabel.text = user.username
        userEmailLabel.text = user.email
        profilePhotoImageView.contentMode = .scaleAspectFit
        guard let url = URL(string: user.profilePhoto) else {
            profilePhotoImageView.image = UIImage(systemName: "person")
            return
        }
        profilePhotoImageView.kf.setImage(with: url)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "addFriendCell")
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupProfilePhotoImageViewConstraints()
        setupUsernameLabelConstraints()
        setupUserEmailLabelConstraints()
    }
    
    private func setupProfilePhotoImageViewConstraints()   {
        addSubview(profilePhotoImageView)
        profilePhotoImageView.snp.makeConstraints { (make) in
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.085)
            make.width.equalTo(UIScreen.main.bounds.size.height * 0.085)
            make.left.equalToSuperview()
        }
    }
    
    private func setupUsernameLabelConstraints()  {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profilePhotoImageView.snp.right).offset(8)
            make.centerY.equalToSuperview().offset(-16)
        }
    }
    
    private func setupUserEmailLabelConstraints() {
        addSubview(userEmailLabel)
        userEmailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profilePhotoImageView.snp.right).offset(8)
            make.top.equalTo(usernameLabel.snp.bottom).offset(8)
        }
    }
}
