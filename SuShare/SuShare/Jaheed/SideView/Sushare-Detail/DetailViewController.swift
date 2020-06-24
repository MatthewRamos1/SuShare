//
//  DetailViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseFirestore
import FirebaseAuth

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
    
    @IBOutlet weak var tableView: UITableView!
    
    private var databaseService = DatabaseService()
    private var listener: ListenerRegistration?
    
    public var sushare: SuShare?
    
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
        updateHeartUI()
    }
    
    @IBAction func joinSushareButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "PaymentSegment", bundle: nil)
        guard let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController else {
             return
        }
        navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        print("favorite")
        if isFavorite{
            databaseService.removeFromFavorite(suShare: sushare!) {[weak self] (result) in
                switch result{
                case.failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
                    }
                case.success:
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Item removed from favorites", message: "")
                        self?.isFavorite = false
                    }
                }
            }
        }else{
            databaseService.addToFavorites(suShare: sushare!) { [weak self] (result) in
                switch result{
                case.failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case.success:
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Favorited", message: "")
                        self?.isFavorite = true
                    }
                }
            }
        }
    }
    
    private func updateHeartUI()    {
        databaseService.isSuShareFavorite(suShare: sushare!) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let isFavoriteDB):
                if isFavoriteDB {
                    self.isFavorite = true
                } else {
                    if self.sushare?.userId == Auth.auth().currentUser?.uid {
                        self.navigationItem.rightBarButtonItem = nil 
                    }
                    self.isFavorite = false
                }
            }
        }
    }
    
    
    private func updateUI(imageURL: String, title: String, profileImage: String, username: String, description: String, pot: String, payment: String, duration: String){
         let susu = sushare
//        else {
//            self.showAlert(title: "Error", message: "Could not load Sushares")
//            fatalError()
//        }
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


