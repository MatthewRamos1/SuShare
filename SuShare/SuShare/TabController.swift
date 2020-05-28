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
        guard let vc = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiateInitialViewController")
        }
        vc.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "gear"), tag: 1)
        return vc
    }()
    

    lazy var personalViewController: UIViewController = {
        let vc = PersonalViewController()
        vc.tabBarItem = UITabBarItem(title: "Personal", image: UIImage(systemName: "person.fill"), tag: 2)
        return vc
    }()
        
    lazy var highlightsViewController: UIViewController = {
        let storyboard = UIStoryboard(name: "Highlights", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "HighlightsViewController") as? HighlightsViewController else{
            fatalError("Couldnt instantiate ViewController")
        }
        vc.tabBarItem = UITabBarItem(title: "Spotlight", image: UIImage(systemName: "globe"), tag: 0)
        return vc
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [highlightsViewController,exploreViewController, UINavigationController(rootViewController: personalViewController)]
    }
    
}
