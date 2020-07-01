//
//  UserCell.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher

class UserCell: UITableViewCell {
    
    @IBOutlet weak var sideViewImage: UIImageView!
    @IBOutlet weak var sideViewUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
        updateUsername()
        imageSetup()
    }
    
    private func updateUI(){
        
        guard let user = Auth.auth().currentUser,
            let _ = user.photoURL
            else {
                return
        }
        sideViewImage.kf.setImage(with: user.photoURL)
    }
    
    private func updateUsername(){
        guard let user = Auth.auth().currentUser,
            let displayname = user.displayName
            else{
                return
        }
        sideViewUsername.text = displayname
    }
    
    func imageSetup(){
        sideViewImage.layer.borderWidth = 0.10
        sideViewImage.layer.cornerRadius = sideViewImage.frame.height / 2
        sideViewImage.layer.borderColor = UIColor.systemGray2.cgColor    }
    
}
