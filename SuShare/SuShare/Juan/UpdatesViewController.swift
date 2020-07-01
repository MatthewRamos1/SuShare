//
//  UpdatesViewController.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/28/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UpdatesViewController: UIViewController {

    private var updatesView = UpdatesView()
    
    override func loadView() {
        view = updatesView
    }
    
    private var updates = [SuShare]() {
        didSet {
            updatesView.tableView.reloadData()
        }
    }
    
    private var suShareListener: ListenerRegistration?
    private var updateListener: ListenerRegistration?
    private var db = DatabaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "SuShare"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.6823529412, blue: 0.631372549, alpha: 1)
        updatesView.tableView.dataSource = self
        updatesView.tableView.delegate = self
        getUpdates()
        configureUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getUpdates()
        configureUpdates()
    }
    
    private func configureUpdates() {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError()
        }
        
        suShareListener = Firestore.firestore().collection(DatabaseService.suShareCollection).whereField("userId", isEqualTo: currentUser.uid).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    // changed documents array
                    let updatedSuShares = snapshot.documents.map {SuShare($0.data())}
                    for update in updatedSuShares {
                        self.db.addUpdate(suShare: update) { (result) in
                            switch result {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .success:
                                print()
                            }
                        }
                    }
                }
            }
        })
    }
    
    private func getUpdates()   {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError()
        }
        
        updateListener = Firestore.firestore().collection(DatabaseService.updatesCollection).whereField("userId", isEqualTo: currentUser.uid).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    self.updates = snapshot.documents.map {SuShare($0.data())}
                }
            }
        })
    }
}

extension UpdatesViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "updatesCell")
        let update = updates[indexPath.row]
        cell.textLabel?.text = update.userId.description
        cell.detailTextLabel?.text = update.susuTitle.description
        return cell
    }
}

extension UpdatesViewController: UITableViewDelegate    {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let maxHeaight = UIScreen.main.bounds.size.height
        let sizePerCell = maxHeaight/7
        return sizePerCell
    }
}
