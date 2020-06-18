//
//  UserFriendsViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/10/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class UserFriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.items?[0].title = "Explore"
        self.tabBarController?.tabBar.items?[1].title = "Personal"
        self.navigationController?.navigationBar.topItem?.title = "SuShare"

        // Do any additional setup after loading the view.
    }
    

  

}
