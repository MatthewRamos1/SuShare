//
//  PersonalCell.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit

class PersonalCell: UICollectionViewCell {
    
    public func configureCell() {
        
    }
    
    private lazy var suShareImageView: UIImageView =    {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.haze.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var suShareDescriptionTextView: UITextView =   {
        let textView = UITextView()
        textView.text = "Sample Text"
        return textView
    }()
    
    private lazy var suShareTagLabel: UILabel = {
        let label = UILabel()
        label.text = "Electronics"
        return label
    }()
    
    private lazy var suShareTagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "tv")
        return imageView
    }()
    
    private lazy var suShareStatusSlider: UISlider =    {
        let slider = UISlider()
        return slider
    }()
    
    private lazy var suShareBackedStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "90%\nBacked"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var suShareCommitsStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "9\nCommits"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var suShareDaysToGoStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "9\nDays To Go"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var stackView: UIStackView =   {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(suShareBackedStatusLabel)
        stackView.addArrangedSubview(suShareCommitsStatusLabel)
        stackView.addArrangedSubview(suShareDaysToGoStatusLabel)
        return stackView
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
        setupSuShareImageViewConstraints()
        setupSuShareDescriptionTextViewConstraints()
        setupSuShareStatusSliderConstraints()
        setupStackViewConstraints()
        setupSuShareTagImageViewConstraints()
        setupSuShareTagLabelConstraints()
    }
    
    private func setupSuShareImageViewConstraints() {
        addSubview(suShareImageView)
        suShareImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(self.snp.height).multipliedBy(0.4)
        }
    }
    
    private func setupSuShareDescriptionTextViewConstraints()   {
        addSubview(suShareDescriptionTextView)
        suShareDescriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(suShareImageView.snp.bottom).offset(11)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
        }
    }
    
    private func setupSuShareStatusSliderConstraints()    {
        addSubview(suShareStatusSlider)
        suShareStatusSlider.snp.makeConstraints { (make) in
            make.top.equalTo(suShareDescriptionTextView.snp.bottom).offset(11)
            make.left.equalTo(self.snp.left).offset(22)
            make.right.equalTo(self.snp.right).offset(-22)
        }
    }
    
    private func setupStackViewConstraints()  {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(suShareStatusSlider.snp.bottom).offset(2)
            make.left.equalTo(suShareStatusSlider.snp.left)
            make.right.equalTo(suShareStatusSlider.snp.right)
            make.height.equalTo(self.snp.height).multipliedBy(0.15)
        }
    }
    
    private func setupSuShareTagImageViewConstraints() {
        addSubview(suShareTagImageView)
        suShareTagImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-8)
        }
    }
    
    private func setupSuShareTagLabelConstraints()  {
        addSubview(suShareTagLabel)
        suShareTagLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(suShareTagImageView.snp.centerY)
            make.left.equalTo(suShareTagImageView.snp.right).offset(8)
        }
    }
}


    

