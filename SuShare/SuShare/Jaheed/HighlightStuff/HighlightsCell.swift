//
//  HighlightsCell.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class HighlightsCell: UICollectionViewCell {
    
    @IBOutlet weak var susuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageBackedLabel: UILabel!
    @IBOutlet weak var numPercentageBackedLabel: UILabel!
    @IBOutlet weak var commitsLabel: UILabel!
    @IBOutlet weak var numCommitsLabel: UILabel!
    @IBOutlet weak var daysRemainLabel: UILabel!
    @IBOutlet weak var numdaysRemainLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
     func configureCell(){
    
        shadowDecorate()
    }
   
    
}
