//
//  SuShareCell.swift
//  SuShare
//
//  Created by Matthew Ramos on 6/30/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher

class SuShareCell: UITableViewCell {

    @IBOutlet weak var suShareImage: UIImageView!
    @IBOutlet weak var suShareTitleLabel: UILabel!
    @IBOutlet weak var suShareDescriptionLabel: UILabel!
    
    
    func configureCell(suShare: SuShare) {
        let url = URL(string: suShare.imageURL)
        suShareImage.kf.setImage(with: url)
        suShareTitleLabel.text = suShare.susuTitle
        suShareDescriptionLabel.text = suShare.suShareDescription
    }
    
}
