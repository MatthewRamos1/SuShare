//
//  TabController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/12/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth

class TabController: UITabBarController {
    
    private var user = singleUser.currentUserrr.username
    
    private let db = DatabaseService.self
    
//    private func getUser() {
//         db.shared.getCurrentUser { (result) in
//             switch result {
//             case .failure(let error):
//                 print("the error is located inside the getUsers inside of the explore view controller \(error.localizedDescription)")
//             case .success(let user):
//                 self.user = user
//             }
//         }
//     }
    
    /*
     let image = newsDetailView.newImageView.image ?? UIImage(systemName: "photo")!
     let storyboard = UIStoryboard(name: "ZoomImage", bundle: nil)
     let zoomImageVC = storyboard.instantiateViewController(identifier: "ZoomImageViewController", creator: { (coder)  in
     
       return ZoomImageViewController(coder: coder, image: image)
     })
     zoomImageVC.modalTransitionStyle = .crossDissolve
     present(zoomImageVC, animated: true)
     */
 
    
//    lazy var exploreViewController: UIViewController = {
//           let storyboard = UIStoryboard(name: "ExploreTab", bundle: nil)
//        guard let vc = storyboard.instantiateInitialViewController(creator: { (coder) in
//            return ExploreViewController(coder: coder)
//        }) else {
//            fatalError("the tab bar explore part isnt working")
//        }
//
//           vc.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "globe"), tag: 0)
//           return vc
//       }()
       
    lazy var exploreViewController: UIViewController = {
              let storyboard = UIStoryboard(name: "ExploreTab", bundle: nil)
              guard let vc = storyboard.instantiateInitialViewController() else {
                  fatalError("Couldn't instantiateInitialViewController")
              }
              vc.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "globe"), tag: 0)
              return vc
          }()

    lazy var updatesViewController: UIViewController = {
        let vc = PersonalViewController()
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
      //  getUser()
        viewControllers = [exploreViewController, UINavigationController(rootViewController: updatesViewController), UINavigationController(rootViewController: personalViewController)]
       }
}
