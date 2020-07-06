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
    
    private var updates = [Update]() {
        didSet {
            DispatchQueue.main.async {
                self.updatesView.tableView.reloadData()
            }
        }
    }
    
    private var db = DatabaseService()
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "SuShare"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.6823529412, blue: 0.631372549, alpha: 1)
        updatesView.tableView.register(UpdateCell.self, forCellReuseIdentifier: "updateCell")
        updatesView.tableView.dataSource = self
        updatesView.tableView.delegate = self
        configureRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        db.getUserUpdates { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let dbUpdates):
                self.updates = dbUpdates
            }
        }
    }
    
    private func configureRefreshControl()  {
        refreshControl = UIRefreshControl()
        updatesView.tableView.refreshControl = refreshControl
        updatesView.tableView.alwaysBounceVertical = true
        updatesView.tableView.refreshControl?.tintColor = .systemGreen
        refreshControl.addTarget(self, action: #selector(refreshUpdates), for: .valueChanged)
    }
    
    @objc func refreshUpdates()    {
        updatesView.tableView.refreshControl?.beginRefreshing()
        print("refreshing")
        db.getUserUpdates { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let dbUpdates):
                self.updates = dbUpdates
            }
        }
        updatesView.tableView.refreshControl?.endRefreshing()
    }
    
    private func removeUpdate(update: Update, atIndexPath indexPath: IndexPath)   {
        db.removeUpdate(update: update) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                DispatchQueue.main.async {
                    self.updates.remove(at: indexPath.row)
                    self.updatesView.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
}

extension UpdatesViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath) as? UpdateCell else {
            fatalError()
        }
        let update = updates[indexPath.row]
        cell.configureCell(update: update)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let update = updates[indexPath.row]
        if editingStyle == .delete  {
            removeUpdate(update: update, atIndexPath: indexPath)
        }
    }
}

extension UpdatesViewController: UITableViewDelegate    {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let maxHeaight = UIScreen.main.bounds.size.height
        let sizePerCell = maxHeaight/7
        return sizePerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

