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
import UserNotifications

protocol NotificationDelegate: AnyObject {
    func didSomething()
}

class UpdatesViewController: UIViewController {

    private var updatesView = UpdatesView()
    
    override func loadView() {
        view = updatesView
    }
    
    private var updates = [Update]() {
        didSet {
            updatesView.tableView.reloadData()
        }
    }
    
    private var db = DatabaseService()
    private let center = UNUserNotificationCenter.current()
    weak var notifDelegate: NotificationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForNotificationAuthorization()
        //center.delegate = self
        //createNotification()

        view.backgroundColor = .systemBackground
        navigationItem.title = "SuShare"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.6823529412, blue: 0.631372549, alpha: 1)
        updatesView.tableView.register(UpdateCell.self, forCellReuseIdentifier: "updateCell")
        updatesView.tableView.dataSource = self
        updatesView.tableView.delegate = self
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
    
    private func requestNotificationsPermissions()  {
        center.requestAuthorization(options: [.badge, .sound]) { (granted, error) in
            if let error = error    {
                print("error requesting authorization: \(error)")
                return
            }
            if granted  {
                print("access was granted")
            }
            else    {
                print("access denied")
            }
        }
    }
    
    private func checkForNotificationAuthorization()    {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized  {
                print("app is authorized for notifications")
            }
            else    {
                self.requestNotificationsPermissions()
            }
        }
    }
    
    private func createNotification()   {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.badge = 1
        
        UIApplication.shared.applicationIconBadgeNumber = 1
        
        let identifier = UUID().uuidString

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(), repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error    {
                print("error adding request \(error)")
            }
            else    {
                print("request added")
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
}

extension UpdatesViewController: UITableViewDelegate    {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let maxHeaight = UIScreen.main.bounds.size.height
        let sizePerCell = maxHeaight/7
        return sizePerCell
    }
}

// Notification Delegate w/ func
extension UpdatesViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.badge)
    }
}
