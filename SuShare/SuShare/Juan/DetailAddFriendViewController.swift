//
//  DetailAddFriendViewController.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/5/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetailAddFriendViewController: UIViewController {

    let detailAddFriendView = DetailAddFriendView()
    var user: User?
    let db = DatabaseService()
    
    override func loadView() {
        view = detailAddFriendView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        detailAddFriendView.addFriendButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        configureUI()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        
        print("add friend")
        guard let currentUser = Auth.auth().currentUser else    {
            fatalError()
        }
        
        guard let selectedUser = user else  {
            fatalError()
        }
        
        db.createDatabaseFriend(user: currentUser.uid, friend: selectedUser.userId) { (result) in
            switch result   {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                print("new friend")
                DispatchQueue.main.async {
                    self.detailAddFriendView.addFriendButton.setTitle("friends", for: .normal)
                    self.detailAddFriendView.addFriendButton.isEnabled = false
                }
            }
            
        }
        
        // conditions for already friend missing
    }
    
    func configureUI()  {
        guard let selectedUser = user else  {
            fatalError()
        }
        detailAddFriendView.usernameLabel.text = selectedUser.username
        detailAddFriendView.emailLabel.text = selectedUser.email
        
        db.checkForFriendship(user: selectedUser) { (result) in
            switch result   {
            case .failure(let error):
                print(error)
            case .success:
                self.detailAddFriendView.addFriendButton.setTitle("friends", for: .normal)
                self.detailAddFriendView.addFriendButton.isEnabled = false
            }
        }
    }

}
