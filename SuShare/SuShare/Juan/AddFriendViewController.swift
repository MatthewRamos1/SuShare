//
//  AddFriendViewController.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/4/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddFriendViewController: UIViewController {
    
    let addFriendView = AddFriendView()
    let db = DatabaseService()
    
    override func loadView() {
        view = addFriendView
    }
    
    var allUsersSorted = [User]()    {
        didSet  {
            addFriendView.tableView.reloadData()
        }
    }
    
    var searchQuery = ""    {
        didSet  {
            db.getAllUsers { (result) in
                switch result   {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let filteredUsers):
                    self.allUsersSorted = filteredUsers.filter{$0.username.lowercased().contains(self.searchQuery.lowercased())}
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addFriendView.tableView.dataSource = self
        addFriendView.tableView.delegate = self
        addFriendView.searchBar.delegate = self
        addFriendView.tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "friendsToAddCell")
        navigationItem.title = "SuShare"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.6823529412, blue: 0.631372549, alpha: 1)
        self.tabBarController?.tabBar.items?[1].title = "Personal"
        configureUsers()
    }
    
    func configureUsers()   {
        db.getAllUsers { (result) in
            switch result   {
            case .failure(let error):
                print("error getting all users for tableview array: \(error)")
            case .success(let users):
                self.allUsersSorted = users
            }
        }
    }
}

extension AddFriendViewController: UITableViewDataSource    {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsersSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsToAddCell", for: indexPath)
        
        let user = allUsersSorted[indexPath.row]
        
        cell.imageView?.image = UIImage(systemName: "person")
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
}

extension AddFriendViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let maxHeaight = UIScreen.main.bounds.size.height
        let sizePerCell = maxHeaight/10
        return sizePerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personalVC = PersonalViewController()
        personalVC.user = allUsersSorted[indexPath.row]
        navigationController?.pushViewController(personalVC, animated: true)
    }
}

extension AddFriendViewController: UISearchBarDelegate  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard !searchText.isEmpty   else    {
            configureUsers()
            return
        }
        
        searchQuery = searchText
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
