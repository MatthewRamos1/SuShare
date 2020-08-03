//
//  ExploreCell.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher

// delegate for action
protocol extraOptionsButtonDelegate: AnyObject {
    func buttonWasPressed(_ cellData: ExploreCell, suShareData: SuShare )
}


class ExploreCell: UICollectionViewCell {
    
    weak var delegate: extraOptionsButtonDelegate?
    
    @IBOutlet weak var susuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fundingProgressView: UIProgressView!
    
    
    @IBOutlet weak var reportButton: UIButton!
    
    private var currentSuShare: SuShare!
    
    public func configureCell(suShare: SuShare) {
        titleLabel.text = suShare.susuTitle
        let suShareCategory = suShare.suShareDescription
       // descriptionLabel.text = suShareCategory
        let url = URL(string: suShare.imageURL)
        susuImageView.kf.setImage(with: url)
        fundingProgressView.progress = Float(suShare.usersInTheSuShare.count / suShare.numOfParticipants) + 0.01
        currentSuShare = suShare
        
    }
    
    
    
    @IBAction func reportButton(_ sender: UIButton) {
        print("it was clicked")
        // we tell it what to do inside of the explore controller
        delegate?.buttonWasPressed(self, suShareData: currentSuShare)
        
        // call the delegate here because this is what it should watch, when this is pressed
        // when this is pressed the alert controller should show
    }
    
     
        
    
}
