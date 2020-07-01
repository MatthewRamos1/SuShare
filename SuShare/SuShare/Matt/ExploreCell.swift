//
//  ExploreCell.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher

class ExploreCell: UICollectionViewCell {
    
    @IBOutlet weak var susuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fundingProgressView: UIProgressView!
    
    public func configureCell(suShare: SuShare) {
        titleLabel.text = suShare.susuTitle
        let suShareCategory = suShare.suShareDescription
       // descriptionLabel.text = suShareCategory
        let url = URL(string: suShare.imageURL)
        susuImageView.kf.setImage(with: url)
        fundingProgressView.progress = Float(suShare.usersInTheSuShare.count / suShare.numOfParticipants) + 0.01
        
    }
}
