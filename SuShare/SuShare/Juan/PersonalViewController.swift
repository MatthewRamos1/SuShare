//
//  PersonalViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class PersonalViewController: UIViewController {
    
    private var refreshControl: UIRefreshControl!
    var user: User?
    var db = DatabaseService()
    var profileHeaderView = ProfileHeaderView()
    var headerView = HeaderView()
    var headerTag: Int?
    private var favListener: ListenerRegistration?
    private var createListner: ListenerRegistration?
    
    let authSession = AuthenticationSession()
    
    let personalView = PersonalView()
    
    var suShares = [SuShare]()   {
        didSet  {
            personalView.personalCollectionView.reloadData()
            if suShares.isEmpty {
                personalView.personalCollectionView.backgroundView = EmptyView.init(title: "Collection Empty", message: "There are currently no saved Sushare's")
            } else {
                personalView.personalCollectionView.reloadData()
                personalView.personalCollectionView.backgroundView = nil
            }
        }
    }
    
    override func loadView() {
        view = personalView
    }
    
    //-------------------------------------------------
    var sideMenuOpen = false
    let transiton = SlideInTransition()
    var topView: UIView?
    var didTapMenuType: ((MenuType) -> Void)?
    var gesture = UITapGestureRecognizer()
    
    //-------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerTag = 0
        let rightbarButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(didTapMenu))
        // temp fix for if loads from search
        if user != nil  {
            navigationItem.rightBarButtonItem = nil
        } else {navigationItem.rightBarButtonItem = rightbarButton}
        rightbarButton.tintColor = #colorLiteral(red: 0, green: 0.5178381205, blue: 0.4835408926, alpha: 1)
        view.backgroundColor = .systemBackground
        navigationItem.title = "SuShare"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.6823529412, blue: 0.631372549, alpha: 1)
        personalView.personalCollectionView.register(UINib(nibName: "HighlightsCell", bundle: nil), forCellWithReuseIdentifier: "highlightsCell")
        suShares = [SuShare]()
        personalView.personalCollectionView.dataSource = self
        personalView.personalCollectionView.delegate = self
        configureRefreshControl()
        configureSuShares()
        configureFriendsButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        createListner?.remove()
        favListener?.remove()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureSuShares2(tag: headerTag ?? 0)
    }
    
    private func configureRefreshControl()  {
        refreshControl = UIRefreshControl()
        personalView.personalCollectionView.refreshControl = refreshControl
        personalView.personalCollectionView.alwaysBounceVertical = true
        personalView.personalCollectionView.refreshControl?.tintColor = .systemGreen
        refreshControl.addTarget(self, action: #selector(refreshSuShares), for: .valueChanged)
    }
    
    @objc func refreshSuShares()    {
        personalView.personalCollectionView.refreshControl?.beginRefreshing()
        print("refreshing")
        configureSuShares2(tag: headerTag ?? 0)
        personalView.personalCollectionView.refreshControl?.endRefreshing()
    }
    
    func configureSuShares()    {
        if let selectedUser = user  {
            db.getCreatedSuShares(user: selectedUser) { (result) in
                switch result   {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let dbSuShares):
                    self.suShares = dbSuShares
                }
            }
        } else {
            db.getCreatedSuSharesForCurrentUser { (result) in
                switch result   {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let dbSuShares):
                    self.suShares = dbSuShares
                }
            }
        }
    }
    
    func configureSuShares2(tag: Int)   {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        if let selectedUser = user  {
            switch tag {
            case 0:
              createListner = Firestore.firestore().collection(DatabaseService.suShareCollection).addSnapshotListener({ (snapshot, error) in
                  if let error = error {
                      print(error.localizedDescription)
                  } else {
                      if let snapshot = snapshot {
                        let snapshotQuery = snapshot.query.whereField("userId", isEqualTo: selectedUser.userId)
                          _ = snapshotQuery.getDocuments { (snapshot, error) in
                              if let error = error {
                                  print(error.localizedDescription)
                              } else {
                                  if let snapshot = snapshot {
                                      let shares = snapshot.documents.map {SuShare($0.data())}
                                      self.suShares = shares
                                      print("triggered create")
                                  }
                              }
                          }
                      }
                  }
              })
            case 1:
                favListener = Firestore.firestore().collection(DatabaseService.favoriteCollection).addSnapshotListener({ (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {
                            let snapshotQuery = snapshot.query.whereField("userId", isEqualTo: selectedUser.userId)
                            _ = snapshotQuery.getDocuments { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    if let snapshot = snapshot {
                                        let favorites = snapshot.documents.map {SuShare($0.data())}
                                        self.suShares = favorites
                                        print("triggered fav")
                                    }
                                }
                            }
                        }
                    }
                })
            case 2:
                suShares = [SuShare]()
            default:
                print("error")
            }
            
        } else {
            switch tag {
            case 0:
                createListner = Firestore.firestore().collection(DatabaseService.suShareCollection).addSnapshotListener({ (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {
                            let snapshotQuery = snapshot.query.whereField("userId", isEqualTo: currentUser.uid)
                            _ = snapshotQuery.getDocuments { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    if let snapshot = snapshot {
                                        let shares = snapshot.documents.map {SuShare($0.data())}
                                        self.suShares = shares
                                        print("triggered create")
                                    }
                                }
                            }
                        }
                    }
                })
            case 1:
                favListener = Firestore.firestore().collection(DatabaseService.favoriteCollection).addSnapshotListener({ (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {
                            let snapshotQuery = snapshot.query.whereField("userId", isEqualTo: currentUser.uid)
                            _ = snapshotQuery.getDocuments { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    if let snapshot = snapshot {
                                        let favorites = snapshot.documents.map {SuShare($0.data())}
                                        self.suShares = favorites
                                        print("triggered fav")
                                    }
                                }
                            }
                        }
                    }
                })
            case 2:
                suShares = [SuShare]()
            default:
                print("error")
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        print("add friend")
        guard let selectedUser = user else  {
            fatalError()
        }
        db.databaseAddFriend(user: selectedUser) { (result) in
            switch result   {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                print("new friend")
                DispatchQueue.main.async {
                    self.profileHeaderView.addFriendButton.setTitle("friends", for: .normal)
                    self.profileHeaderView.addFriendButton.isEnabled = false
                }
            }
        }
    }
    
    func configureFriendsButton()  {
        guard let selectedUser = user else  {
            return
        }
        
        db.checkForFriendship(user: selectedUser) { (result) in
            switch result   {
            case .failure(let error):
                print(error)
            case .success:
                self.profileHeaderView.addFriendButton.setTitle("friends", for: .normal)
                self.profileHeaderView.addFriendButton.isEnabled = false
            }
        }
    }
    
    //-----------------------------------------------------------------
    @objc func didTapMenu(_ sender: UIBarButtonItem) {
        print("tab bar")
        let mainView: UIStoryboard = UIStoryboard(name: "ExploreTab", bundle: nil)
        let menuViewController = mainView.instantiateViewController(identifier: "MenuViewController") as! MenuViewController
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        
        let tap = UITapGestureRecognizer(target: self, action:    #selector(self.handleTap(_:)))
        transiton.dimmingView.addGestureRecognizer(tap)
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    // and delegate at bottom to transition
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        switch menuType {
        case .username:
            let storyboard: UIStoryboard = UIStoryboard(name: "UserSettings", bundle: nil)
            let settingsVC = storyboard.instantiateViewController(identifier: "SettingsViewController")
            self.navigationController?.pushViewController(settingsVC, animated: true)
            
        case .friends:
            let storyboard: UIStoryboard = UIStoryboard(name: "Friends", bundle: nil)
            let friendsVC = storyboard.instantiateViewController(identifier: "UserFriendsViewController")
            self.navigationController?.pushViewController(friendsVC, animated: true)
        case .search:
            self.navigationController?.pushViewController(AddFriendViewController(), animated: true)
        case .settings:
            self.tabBarController?.tabBar.items?[0].title = "Explore"
            self.tabBarController?.tabBar.items?[1].title = "Updates"
            self.tabBarController?.tabBar.items?[2].title = "Personal"
            self.showAlert(title: "We are still under construction", message: "please visit this at a later date ")
        }
    }
    //-----------------------------------------------------------------
    
}

extension PersonalViewController: UICollectionViewDataSource    {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }   else    {
            return suShares.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "highlightsCell", for: indexPath) as? HighlightsCell else {
            fatalError()
        }
        
        cell.layer.borderColor = UIColor.systemGray6.cgColor
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        let suShare = suShares[indexPath.row]
        
        cell.delgateForHighlights = self
        cell.configureCell(for: suShare)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let section = indexPath.section
        if section == 0 {
            profileHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeader", for: indexPath) as! ProfileHeaderView
            
            profileHeaderView.backgroundColor = .white
            
            guard let searchedUser = user
                else    {
                    db.getCurrentUser { (result) in
                        switch result   {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let user):
                            let photoURL = URL(string: user.profilePhoto)
                            // using auth.currentuser.photo doesnt work
                            self.profileHeaderView.profilePictureImageView.kf.setImage(with: photoURL)
                            self.profileHeaderView.determineUserUI(user: user)
                            self.profileHeaderView.addFriendButton.isHidden = true
                        }
                    }
                    return profileHeaderView
            }
            
            let photoURL = URL(string: searchedUser.profilePhoto)
            profileHeaderView.profilePictureImageView.kf.setImage(with: photoURL)
            profileHeaderView.determineUserUI(user: searchedUser)
            profileHeaderView.addFriendButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            return profileHeaderView
            
        }   else  {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderView
            headerView.backgroundColor = .white
            headerView.delegate = self
            return headerView
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 100, height: 88)
        }   else    {
            return CGSize(width: 50, height: 55)
        }
    }
    
}

extension PersonalViewController: UICollectionViewDelegateFlowLayout    {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = UIScreen.main.bounds.size.height / 3.55
        let width =
            UIScreen.main.bounds.size.width * 0.84
        return CGSize(width: width, height: height * 2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SushareDetail", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
             return
        }
        detailVC.sushare = suShares[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

//----------------------------------------------------------------------------
extension PersonalViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
//----------------------------------------------------------------------------

extension PersonalViewController: HeaderDelegate    {
    func selectedHeader(tag: Int) {
        configureSuShares2(tag: tag)
        headerTag = tag
    }
}

extension PersonalViewController: extraOptionsButtonHighlightsDelegate {
    func buttonWasPressed(_ cellData: HighlightsCell, suShareData: SuShare) {
       
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                           let reportAction = UIAlertAction(title: "Report", style: .destructive) {
                               alertAction in
                               
                               print("here is where was change the status on the suShare")
                               print("we should also reload the sushare list and hid the sushare once its confirmed ")
                             // self.imagePickerController.sourceType = .camera
                             //  self.present(self.imagePickerController, animated: true)
                           }
                           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                       
                          alertController.addAction(cancelAction)
                           alertController.addAction(reportAction)
                         present(alertController, animated: true)
                       
       }
}
