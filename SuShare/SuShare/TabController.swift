//
//  TabController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/12/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

    lazy var exploreViewController: UIViewController = {
           let storyboard = UIStoryboard(name: "ExploreTab", bundle: nil)
           guard let vc = storyboard.instantiateInitialViewController() else {
               fatalError("Couldn't instantiateInitialViewController")
           }
           vc.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "globe"), tag: 0)
           return vc
       }()
       

    lazy var updatesViewController: UIViewController = {
        let vc = UpdatesViewController()
        vc.tabBarItem = UITabBarItem(title: "Updates", image: UIImage(systemName: "bell.fill"), tag: 1)
        return vc
    }()
    
    lazy var personalViewController: UIViewController = {
        let vc = PersonalViewController()
        vc.tabBarItem = UITabBarItem(title: "Personal", image: UIImage(systemName: "person.fill"), tag: 2)
        return vc
    }()
       
       override func viewDidLoad() {
           super.viewDidLoad()
        viewControllers = [exploreViewController, UINavigationController(rootViewController: updatesViewController), UINavigationController(rootViewController: personalViewController)]
       }
}
