//
//  MenueViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/7/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseFirestore
import Firebase

enum MenuType: Int {
    case username
    case friends
    case search
    case settings
}

class MenuViewController: UITableViewController {
    
    var didTapMenuType: ((MenuType) -> Void)?
    
    var database = DatabaseService()
    
    var menu: MenuType?
    var user: User?
    var userCell: UserCell?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userNameCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //usernameLabel.text = "something"
        tableView.delegate = self
        registerCell()
        
    }
    
    private func updateUI(){
        guard let user = Auth.auth().currentUser,
            let url = user.photoURL,
            let displayName = user.displayName
        else {
            return
        }
        self.userImageView.kf.setImage(with: url)
        self.usernameLabel.text = displayName

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.viewWillAppear(true)
//        updateUI()
//    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
    
    func registerCell(){
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "SideViewUserCell")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
           registerCell()
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideViewUserCell") as? UserCell else {
                        fatalError()
                    }
            return cell
        } else{
        return UITableViewCell()
        }
        
        
        //return cell
    }
    
}


