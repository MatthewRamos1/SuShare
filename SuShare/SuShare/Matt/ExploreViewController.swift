//
//  ExploreViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ExploreViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    
    // shaniya
    @IBOutlet weak var createSuShare: UIButton!
    
    var suShareListener: ListenerRegistration?
    var boldFont: UIFont?
    var thinFont: UIFont?
    
    //------------------------
    //Jaheed
    var sideMenuOpen = false
    let transiton = SlideInTransition()
    var topView: UIView?
    var didTapMenuType: ((MenuType) -> Void)?
    var gesture = UITapGestureRecognizer()
    //------------------------
    
    // Shaniya
    private let transitionCircle = CircularTransition()
    
    var originalSusus = [SuShare]() {
        didSet {
            if currentSusus.isEmpty {
                currentSusus = originalSusus
            }
        }
    }
    
    var currentSusus = [SuShare]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var currentTags = [Int]()
    var currentQuery = "" {
        didSet {
            currentSusus = currentSusus.filter { $0.description.contains(currentQuery) }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        toggleExplore()
        boldFont = exploreButton.titleLabel?.font
        thinFont = friendsButton.titleLabel?.font
        setSuShareListener()
        
        // shaniya
         createSuShare.layer.cornerRadius = createSuShare.frame.size.width / 2
        //------------------------
        // JAHEED
        
        //        NotificationCenter.default.addObserver(self,
        //                                               selector: #selector(didTapMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        //        gesture = UITapGestureRecognizer(target: self, action: #selector(ExploreViewController().didTapMenu))
        
        
        //------------------------
        
    }
    
    
    // Shaniya
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "goToCreateSusu" {
              guard let createVC = segue.destination as? CreateSusuViewController else { return }
                 createVC.modalPresentationStyle = .custom
            
              createVC.transitioningDelegate = self
         
          //  present(createVC,animated: true)
          }
      }
      
        
    
    //---------------------------------------------------------------------------------
    // JAHEED
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
            print("tapped")
        case .friends:
            let storyboard: UIStoryboard = UIStoryboard(name: "Friends", bundle: nil)
            let settingsVC = storyboard.instantiateViewController(identifier: "UserFriendsViewController")
            self.navigationController?.pushViewController(settingsVC, animated: true)
        case .search:
            // MARK: Shaniya edits here
            guard let addFriendsVC = storyboard!.instantiateViewController(identifier: "SettingsViewController") as? AddFriendViewController else {
                fatalError("could not access friends controller")
            }
                // +++++++++
            self.navigationController?.pushViewController( addFriendsVC, animated: true)
        case .settings:
            //UIViewController.showViewController(storyBoardName: "UserSettings", viewControllerId: "SettingsViewController")
            let storyboard: UIStoryboard = UIStoryboard(name: "UserSettings", bundle: nil)
            let settingsVC = storyboard.instantiateViewController(identifier: "SettingsViewController")
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view != self.topView
        { self.dismiss(animated: true, completion: nil) }
    }
    
    //---------------------------------------------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        suShareListener?.remove()
        
    }
    
    private func toggleExplore() {
        exploreButton.isEnabled = false
        friendsButton.isEnabled = true
        exploreButton.underline()
        
    }
    
    private func setSuShareListener() {
        suShareListener = Firestore.firestore().collection(DatabaseService.suShareCollection).addSnapshotListener( { [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error getting favorites", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let suShareData = snapshot.documents.map { $0.data() }
                let suShares = suShareData.map { SuShare($0)}
                self?.originalSusus = suShares
                
            }
            }
        )
    }
    @IBAction func exploreButtonPressed(_ sender: UIButton) {
        friendsButton.removeLine()
        exploreButton.titleLabel?.font = boldFont
        friendsButton.titleLabel?.font = thinFont
        toggleExplore()
    }
    
    @IBAction func friendsButtonPressed(_ sender: UIButton) {
        friendsButton.isEnabled.toggle()
        exploreButton.isEnabled.toggle()
        exploreButton.titleLabel?.font = thinFont
        friendsButton.titleLabel?.font = boldFont
        exploreButton.removeLine()
        friendsButton.underline()
    }
    
    
    @IBAction func tagButtonPressed(_ sender: UIButton) {
        tagFilter(tag: sender.tag)
    }
    
    private func tagFilter(tag: Int) {
        if !currentTags.contains(tag) {
            currentTags.append(tag)
        } else {
            guard let index = currentTags.firstIndex(of: tag) else {
                return
            }
            currentTags.remove(at: index)
        }
        
        currentSusus = originalSusus
        //.filter { currentTags.contains($0.category.rawValue)}
    }
    
    
    @IBAction func createASuShare(_ sender: UIButton) {
        
         performSegue(withIdentifier: "goToCreateSusu", sender: self)
        
    }
    
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentSusus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell", for: indexPath) as? ExploreCell else {
            fatalError("Couldn't downcast to ExploreCell, check cellForItemAt")
        }
        let suShare = currentSusus[indexPath.row]
        
        cell.configureCell(suShare: suShare)
        return cell
        
    }
    
    
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = UIScreen.main.bounds.size.height / 3
        let width =
            UIScreen.main.bounds.size.width - 100
        return CGSize(width: width, height: height * 2)
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        currentSusus = originalSusus.filter { $0.description.contains(query) || $0.susuTitle.contains(query)}
    }
}

//---------------------------------------------------------------------------------
// Jaheed

extension ExploreViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if source.modalPresentationStyle == .custom {
            transitionCircle.transitionMode = .present
                                    transitionCircle.startingPoint = createSuShare.center
                                    transitionCircle.circleColor = createSuShare.backgroundColor!
                                 
                             return transitionCircle

        } else {
        transiton.isPresenting = true
        return transiton
    
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //__________________________________________
//        guard let createVC = storyboard?.instantiateViewController(identifier: "CreateSusu") as? CreateSusuViewController else {
//            fatalError("is not working")
//        }
        
//        guard let vc = storyboard.instantiateViewController(identifier: "HighlightsViewController") as? HighlightsViewController else{
//                     fatalError("Couldnt instantiate ViewController")
//                 }
//
//        let createVC: UIViewController = {
//                  let storyboard = UIStoryboard(name: "CreateSusu", bundle: nil)
//                  guard let vc = storyboard.instantiateViewController(identifier: "CreateSusu") as? CreateSusuViewController else{
//                      fatalError("Couldnt instantiate ViewController")
//                  }
//                  vc.tabBarItem = UITabBarItem(title: "Spotlight", image: UIImage(systemName: "globe"), tag: 2)
//                  return vc
//              }()
//
       //  guard let createVC = segue.destination as? CreateSusuViewController else { return }
        
       // guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else{ fatalError("help me ") }
//
//        if !(animationController(forDismissed: menuViewController ) != nil) {
//            transitionCircle.transitionMode = .dismiss
//                                 transitionCircle.startingPoint = createSuShare.center
//                                 transitionCircle.circleColor = createSuShare.backgroundColor!
//            return transitionCircle
//        } else {
        
        //_____________________________________
        
              transiton.isPresenting = false
                return transiton
        //}
                     
    }
}
