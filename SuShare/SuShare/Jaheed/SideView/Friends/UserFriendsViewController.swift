//
//  UserFriendsViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/10/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseFirestore

class UserFriendsViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let database = DatabaseService()
    
    var userFriendName = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var userFriend = [User](){
        didSet{
            tableView.reloadData()
        }
    }
    
    
    var searchQuery = "" {
        didSet {
            database.getAllUsers { (result) in
                switch result {
                case.failure(let error):
                    self.showAlert(title: "Error", message: "\(error.localizedDescription)")
                case.success(let friends):
                    self.userFriend = friends.filter{$0.username.lowercased().contains(self.searchQuery.lowercased())}
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavItems()
        configureFriendNames()
        configureDataDelegates()

    }
    
    
    func configureNavItems(){
        self.tabBarController?.tabBar.items?[0].title = "Explore"
        self.tabBarController?.tabBar.items?[1].title = "Personal"
        self.navigationController?.navigationBar.topItem?.title = "SuShare"
    }
    
    func configureUserFriends()   {
        database.getAllUsers { (result) in
            switch result   {
            case .failure(let error):
                print("error getting all users for tableview array: \(error)")
            case .success(let userFriends):
                self.userFriend = userFriends
            }
        }
    }
    
    func configureFriendNames(){
        database.updateUserFriend { (result) in
            switch result{
            case.failure(let error):
                print("\(error.localizedDescription)")
            case.success(let friendList):
                self.userFriendName = friendList
            }
        }
    }
    
    func configureDataDelegates(){
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    

  

}

extension UserFriendsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFriendName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFriendCell", for: indexPath)
        
        let friend = userFriendName[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "person")
        cell.textLabel?.text = friend
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    
}

extension UserFriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let personalVC = PersonalViewController()
//        personalVC.user = userFriend[indexPath.row]
//        navigationController?.pushViewController(personalVC, animated: true)
    }
}

extension UserFriendsViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            configureFriendNames()
            return
        }
        searchQuery = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
