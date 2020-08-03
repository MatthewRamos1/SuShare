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
    @IBOutlet weak var commentsButtonLabel: UILabel!
    @IBOutlet weak var numOfCommentsLabel: UILabel!
    
    @IBOutlet weak var extraOptionsButton: UIButton!
    
    private var databaseService = DatabaseService()
    private var listener: ListenerRegistration?
    
    public var sushare: SuShare?
    public var user: User?
    private var comment: Comment?
    
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
        loadUI()
        tabBarController?.tabBar.isHidden = true
        durationLabel.isHidden = true
        setUpUserProfileImageView()
    }
    
    private func setUpUserProfileImageView(){
        userProfileImage.layer.cornerRadius = (userProfileImage.frame.size.width ) / 2
        userProfileImage.clipsToBounds = true
        userProfileImage.layer.borderWidth = 3.0
        userProfileImage.layer.borderColor = UIColor.white.cgColor
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    // current user is added to sushare field partOfSuShare
    // this is added as an update
    // update appears in updatesVC
    private func updateSushareFlagged(suShare: SuShare){
          databaseService.updateFlaggedInSuShare(suShareId: suShare.suShareId) { (result) in
              switch result {
              case .failure(let error):
                  print("this is inside of updateSushareFlagged function: \(error.localizedDescription)")            case .success(let isItDone):
                      print("is it done: \(isItDone) inside of explore controller")
                      // should show alert and refresh the controller
                      self.addSuShareToFlaggedList(suShare: suShare)
              }
          }
      }
      
    private func addSuShareToFlaggedList(suShare: SuShare){
          // once done should show alert that its done
          databaseService.flagASuShare(suShare: suShare) { (result) in
              switch result {
              case .failure(let error):
                  print("this is inside of addSuShareToFlaggedList function: \(error.localizedDescription)")
              case .success(let good):
                  self.showAlert(title: "this SuShare has been flagged", message: "we got your report")
                  print("this is inside of addSuShareToFlaggedList \(good)")
              }
          }
      }
    private func buttonWasPressed(suShareData: SuShare) {
           let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           
           let reportAction = UIAlertAction(title: "Report", style: .destructive) {
               alertAction in
               
               print("here is where was change the status on the suShare")
               print("we should also reload the sushare list and hid the sushare once its confirmed ")
               
               self.updateSushareFlagged(suShare: suShareData)
               
           }
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
           
           alertController.addAction(cancelAction)
           alertController.addAction(reportAction)
           present(alertController, animated: true)
           
       }
    
    @IBAction func extraOptionsButton(_ sender: Any) {
        
        buttonWasPressed(suShareData: sushare!)
        
    }
    
    
    @IBAction func joinSushareButtonPressed(_ sender: UIButton) {
        
        // add to partof
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        
        
        let storyboard = UIStoryboard(name: "PaymentSegment", bundle: nil)
        
        guard let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController,
            var sushare = sushare else {
            return
        }
        
        sushare.usersInTheSuShare.append(currentUser.uid)
        
        // userId added to array in db
        // user here is person that created, need to grab user that joined for his photo
        databaseService.joinUserToSuShare(suShare: sushare) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                print("user joined")
                self.databaseService.getCurrentUser { (result) in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let dbUser):
                        self.databaseService.addUpdate(user: dbUser, suShare: sushare) { (result) in
                            switch result   {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .success:
                                print("added update")
                            }
                        }
                    }
                }
                
            }
        }
        
        // add to updates
        
        
        paymentVC.suShare = sushare
        paymentVC.hidesBottomBarWhenPushed = true
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
            databaseService.addToFavorites(sushare: sushare!) { (result) in
                switch result   {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success:
                    DispatchQueue.main.async {
                        self.showAlert(title: "Favorited", message: "")
                        self.isFavorite = true
                    }
                }
            }
        }
    }
    
    @IBAction func commentsButtonPressed(_ sender: UIButton) {
        guard let sushare = sushare else {
            return
        }
        let storyboard = UIStoryboard(name: "SushareDetail", bundle: nil)
        let commentVC = storyboard.instantiateViewController(identifier: "CommentsViewController") { coder in
            return CommentsViewController(coder: coder, sushare: sushare)
        }
        databaseService.getCurrentUser { (result) in
            switch result{
            case.failure(let error):
                print("ERROR: \(error.localizedDescription)")
            case.success(let user):
                commentVC.user = user
            }
        }
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    private func updateHeartUI()  {
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
    
    
//        private func updateUI(imageURL: String, title: String, profileImage: String, username: String, description: String, pot: String, payment: String, duration: String){
//           guard let susu = sushare
//                    else {
//                        self.showAlert(title: "Error", message: "Could not load Sushares")
//                        fatalError()
//                    }
//            imageView.kf.setImage(with: URL(string: imageURL))
//            titleLabel.text = title
//            userProfileImage.kf.setImage(with: URL(string: profileImage))
//            usernameLabel.text = username
//            descriptionLabel.text = description
//            potLabel.text = pot
//            paymentLabel.text = payment
//            durationLabel.text = duration
//        }
    
    private func loadUI(){

        guard let imageURL = sushare?.imageURL,
            let userImage = user?.profilePhoto,
            let potAmount = sushare?.potAmount
            else{
                imageView.image = UIImage(systemName: "sun")
                return
        }
        imageView.kf.setImage(with: URL(string: imageURL))
        titleLabel.text = sushare?.susuTitle
        userProfileImage.kf.setImage(with: URL(string: userImage))
        usernameLabel.text = user?.username
        descriptionLabel.text = sushare?.suShareDescription
        let convertedPot = String(format: "%.2f", potAmount)
        potLabel.text = "Pot: $\(convertedPot)"
        paymentLabel.text = "Payment Schedule: \(sushare?.paymentSchedule ?? "")"
        //durationLabel.text = "Duration Number here"
        progressView.progress = Float((sushare?.usersInTheSuShare.count)! / sushare!.numOfParticipants) + 0.01
        commentsButtonLabel.text = comment?.comment.count.description
    }
    
    //    private func getUser(){
    //        databaseService.getCurrentUser { (result) in
    //            switch result{
    //            case.failure(let error):
    //                fatalError()
    //
    //            }
    //        }
    //    }
    
    
    
}


