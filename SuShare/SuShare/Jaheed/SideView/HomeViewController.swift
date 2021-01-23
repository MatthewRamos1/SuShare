//
//  HomeViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/7/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let transiton = SlideInTransition()
      var topView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    

    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else{return}
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }

        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title

        topView?.removeFromSuperview()
        switch menuType {
        case .username:
            let view = UIView()
            view.backgroundColor = .systemYellow
            view.frame = self.view.bounds
            self.view.addSubview(view)
            self.topView = view
        case .friends:
            let view = UIView()
            view.backgroundColor = .systemBlue
            view.frame = self.view.bounds
            self.view.addSubview(view)
            self.topView = view
        case .search:
            let view = UIView()
            view.backgroundColor = .systemPurple
            view.frame = self.view.bounds
            self.view.addSubview(view)
            self.topView = view
//        case .settings:
//            UIViewController.showViewController(storyBoardName: "UserSettings", viewControllerId: "UserSettingsViewController")
        }
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
