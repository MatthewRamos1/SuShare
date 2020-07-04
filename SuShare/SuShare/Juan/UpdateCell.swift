//
//  UpdateCell.swift
//  SuShare
//
//  Created by Juan Ceballos on 7/2/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

 import UIKit
 import SnapKit

 class UpdateCell: UITableViewCell    {
     
     override func layoutSubviews() {
         profilePhotoImageView.clipsToBounds = true
         profilePhotoImageView.layer.borderWidth = 1.00
         profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
         profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
     }
     
     public lazy var updateLabel: UILabel = {
         let label = UILabel()
         return label
     }()
     
     public lazy var detailLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.italicSystemFont(ofSize: 12)
         return label
     }()
     
     public lazy var profilePhotoImageView: UIImageView = {
         let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.height * 0.0085, height: UIScreen.main.bounds.size.height * 0.0085))
         return imageView
     }()
     
    // had to get photo of user joined ,auth.auth might not work user.photoURL
    public func configureCell(update: Update)    {
        updateLabel.text = update.userJoined
        detailLabel.text = update.susuTitle
        profilePhotoImageView.contentMode = .scaleAspectFit
        guard let url = URL(string: update.userJoinedPhoto) else {
             profilePhotoImageView.image = UIImage(systemName: "person")
             return
         }
         profilePhotoImageView.kf.setImage(with: url)
     }
     
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: "updateCell")
         commonInit()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         commonInit()
     }
     
     private func commonInit() {
         setupProfilePhotoImageViewConstraints()
         setupUpdateLabelConstraints()
         setupDetailLabelConstraints()
     }
     
     private func setupProfilePhotoImageViewConstraints()   {
         addSubview(profilePhotoImageView)
         profilePhotoImageView.snp.makeConstraints { (make) in
             make.height.equalTo(UIScreen.main.bounds.size.height * 0.085)
             make.width.equalTo(UIScreen.main.bounds.size.height * 0.085)
             make.left.equalToSuperview()
         }
     }
     
     private func setupUpdateLabelConstraints()  {
         addSubview(updateLabel)
         updateLabel.snp.makeConstraints { (make) in
             make.left.equalTo(profilePhotoImageView.snp.right).offset(8)
             make.centerY.equalToSuperview().offset(-16)
         }
     }
     
     private func setupDetailLabelConstraints() {
         addSubview(detailLabel)
         detailLabel.snp.makeConstraints { (make) in
             make.left.equalTo(profilePhotoImageView.snp.right).offset(8)
             make.top.equalTo(updateLabel.snp.bottom).offset(8)
         }
     }
 }

