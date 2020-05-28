//
//  TabController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    
    lazy var create: UIViewController = {
        let storyboard = UIStoryboard(name: "CreateSusu", bundle: nil)
      guard let vc = storyboard.instantiateViewController(identifier: "CreateSusuViewController") as? CreateSusuViewController else {
            fatalError("not working")
        }
        vc.tabBarItem = UITabBarItem(title: "create", image: UIImage(systemName: "gear"), tag: 1)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [create]
    }
    
}
