//
//  PersonalView.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit

class PersonalView: UIView {
    override func layoutSubviews() {
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.layer.borderWidth = 1.25
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height / 2
        profilePictureImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    public lazy var personalCollectionView: UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
    private lazy var profilePictureImageView: UIImageView =  {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (self.frame.height * 0.085), height: (self.frame.height * 0.085)))
        imageView.image = UIImage(systemName: "person.fill")
        imageView.backgroundColor = .systemTeal
        imageView.layoutSubviews()
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel =   {
        let label = UILabel()
        label.text = "Johny NoNutz"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var backedButton: UIButton =   {
        let button = UIButton()
        button.setTitle("Backed", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.tag = 0
        button.underline()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoritedButton: UIButton =   {
        let button = UIButton()
        button.setTitle("Favorited", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.removeLine()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createdButton: UIButton =   {
        let button = UIButton()
        button.setTitle("Created", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.removeLine()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonTapped(_ sender: UIButton) {
        
        switch sender.tag   {
        case 0:
            backedButton.underline()
            favoritedButton.removeLine()
            createdButton.removeLine()
        case 1:
            favoritedButton.underline()
            backedButton.removeLine()
            createdButton.removeLine()
        case 2:
            createdButton.underline()
            backedButton.removeLine()
            favoritedButton.removeLine()
        default:
            print("Button Error")
        }
    
    }
    
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
        setupBackedButtonConstraints()
        setupFavoritedButtonConstraints()
        setupCreatedButtonConstraints()
        setupPersonalCollectionViewConstraints()
    }
    
    private func setupProfilePictureImageViewConstraints() {
        addSubview(profilePictureImageView)
        profilePictureImageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(44)
            make.height.equalToSuperview().multipliedBy(0.085)
            make.left.equalToSuperview().offset(22)
            make.width.equalTo(self.snp.height).multipliedBy(0.085)
        }
    }
    
    private func setupUsernameLabelConstraints()    {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profilePictureImageView.snp.right).offset(11)
            make.centerY.equalTo(profilePictureImageView.snp.centerY)
        }
    }
    
    private func setupBackedButtonConstraints() {
        addSubview(backedButton)
        backedButton.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom).offset(66)
            make.left.equalToSuperview().offset(22)
        }
    }
    
    private func setupFavoritedButtonConstraints() {
        addSubview(favoritedButton)
        favoritedButton.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom).offset(66)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupCreatedButtonConstraints() {
        addSubview(createdButton)
        createdButton.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom).offset(66)
            make.right.equalToSuperview().offset(-22)
        }
    }
    
    private func setupPersonalCollectionViewConstraints()   {
        addSubview(personalCollectionView)
        personalCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(backedButton.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            
        }
    }
    
}
