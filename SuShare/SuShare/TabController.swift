//
//  TabController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    
    lazy var feedViewController: UIViewController = {
        let storyboard = UIStoryboard(name: "PostSB", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()  ?? FeedViewController()
        vc.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "pencil"), tag: 0)
        return vc
    }()
    
    lazy var eventViewController: UIViewController = {
        let storyboard = UIStoryboard(name: "EventSB", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()  ?? EventViewController()
        vc.tabBarItem = UITabBarItem(title: "Event", image: UIImage(systemName: "mic"), tag: 1)
        return vc
    }()
    
    lazy var favoriteViewController: FavoriteViewController = {
        let vc = FavoriteViewController()
        vc.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 2)
        return vc
    }()
    
    lazy var profileViewController: ProfileViewController = {
        let vc = ProfileViewController()
        vc.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [feedViewController,
                           eventViewController,
                           favoriteViewController,
                           profileViewController]
    }
    
}
