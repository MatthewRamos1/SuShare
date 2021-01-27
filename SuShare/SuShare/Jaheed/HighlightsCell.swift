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

protocol extraOptionsButtonHighlightsDelegate: AnyObject {
    func buttonWasPressed(_ cellData: HighlightsCell, suShareData: SuShare )
}


class HighlightsCell: UICollectionViewCell {
    
    weak var delgateForHighlights : extraOptionsButtonHighlightsDelegate?
    
    @IBOutlet weak var susuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentageBackedLabel: UILabel!
    @IBOutlet weak var numPercentageBackedLabel: UILabel!
    @IBOutlet weak var commitsLabel: UILabel!
    @IBOutlet weak var numCommitsLabel: UILabel!
    @IBOutlet weak var numdaysRemainLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    
    @IBOutlet weak var extraOptionsButton: UIButton!
    
    
    private var currentSuShare: SuShare!
    
    public func configureCell(for suShare: SuShare) {
        currentSuShare = suShare
        titleLabel.text = suShare.susuTitle
        descriptionLabel.text = suShare.suShareDescription
        let url = URL(string: suShare.imageURL)
        susuImageView.kf.setImage(with: url)
    }
    
    @IBAction func extraOptionsAction(_ sender: Any) {
        delgateForHighlights?.buttonWasPressed(self, suShareData: currentSuShare)
    }
    
   
    
}
