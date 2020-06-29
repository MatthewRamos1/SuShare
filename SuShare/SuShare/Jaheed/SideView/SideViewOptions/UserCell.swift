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
    
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        updateUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //let user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
        imageSetup()
    }
    
    private func updateUI(){
        
        guard let user = Auth.auth().currentUser,
           // let url = user.photoURL,
            let displayName = user.displayName
        else {
            return
        }
       //print(url)
        //self.sideViewImage.kf.setImage(with: URL(string: "https://firebasestorage.googleapis.com/v0/b/sushare-54d09.appspot.com/o/UserProfilePhotos%2F1vOusbyPJpTU3BLvQeH5sOH6DLm1.jpg?alt=media&token=ee196a13-998e-4053-b24f-8b952acca884"))
        print(user.photoURL)
        self.sideViewImage.kf.setImage(with: user.photoURL)
        self.sideViewUsername.text = displayName

    }
    
    func imageSetup(){
        sideViewImage.layer.borderWidth = 0.10
        sideViewImage.layer.cornerRadius = sideViewImage.frame.height / 2
        sideViewImage.layer.borderColor = UIColor.systemGray2.cgColor    }
    
}
