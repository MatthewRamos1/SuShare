//
//  TabController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    
    lazy var exploreViewController: UIViewController = {
        let storyboard = UIStoryboard(name: "ExploreTab", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() ?? CreateSusuViewController()
        vc.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "gear"), tag: 1)
        return vc
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [exploreViewController]
    }
    
}