//
//  DetailViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    public var susu: Susu?
    
    private var isFavorite = false {
        didSet{
            if isFavorite {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            }else{
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func updateUI(imageURL: String, title: String, profileImage: String, username: String, description: String, pot: String, payment: String, duration: String){
        guard let susu = susu else {
            showAlert(title: "Error", message: "Could not load Sushares")
            fatalError()
        }
        imageView.kf.setImage(with: URL(string: imageURL))
        titleLabel.text = title
        userProfileImage.kf.setImage(with: URL(string: profileImage))
        usernameLabel.text = username
        descriptionLabel.text = description
        potLabel.text = pot
        paymentLabel.text = payment
        durationLabel.text = duration
        
        
    }
    

    

}


