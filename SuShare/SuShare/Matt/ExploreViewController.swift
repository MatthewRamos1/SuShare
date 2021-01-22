//
//  ExploreViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ExploreViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var suShareListener: ListenerRegistration?
    var emptyView = EmptyView(title: "No SuShares Available", message: "Enter valid input or try a different query")
    var boldFont: UIFont?
    var thinFont: UIFont?
    
    
    private let circularTransition = CircularTransition()
    
    //------------------------
    //Jaheed
    var sideMenuOpen = false
    let transiton = SlideInTransition()
    var topView: UIView?
    var didTapMenuType: ((MenuType) -> Void)?
    var gesture = UITapGestureRecognizer()
    var user: User?
    var database = DatabaseService()
    func updateButtonShadow(){
        createButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        createButton.layer.shadowColor = UIColor.lightGray.cgColor
        createButton.layer.shadowOpacity = 1
        createButton.layer.shadowRadius = 5
        createButton.layer.masksToBounds = false
    }
    //------------------------
    
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
            if currentSusus.isEmpty {
                collectionView.backgroundView = emptyView
            } else {
                collectionView.backgroundView = nil
            }
        }
    }
    var currentTags = [Int]()
    var currentQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        toggleExplore()
        boldFont = exploreButton.titleLabel?.font
        thinFont = friendsButton.titleLabel?.font
        setSuShareListener()
        createButton.layer.cornerRadius = (createButton.frame.size.width / 2) + (createButton.frame.size.height / 2 )
        updateButtonShadow()
        
        //        do {
        //            try Auth.auth().signOut()
        //            UIViewController.showViewController(storyBoardName: "LoginView", viewControllerId: "LoginViewController")
        //        } catch {
        //            print("error")
        //        }
    }
    
    //---------------------------------------------------------------------------------
    // JAHEED
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else{return}
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
    
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        switch menuType {
        case .username:
            // print("tapped")
            let storyboard: UIStoryboard = UIStoryboard(name: "UserSettings", bundle: nil)
            let settingsVC = storyboard.instantiateViewController(identifier: "SettingsViewController")
            self.navigationController?.pushViewController(settingsVC, animated: true)
        case .friends:
            let storyboard: UIStoryboard = UIStoryboard(name: "Friends", bundle: nil)
            let friendsVC = storyboard.instantiateViewController(identifier: "UserFriendsViewController")
            self.navigationController?.pushViewController(friendsVC, animated: true)
        case .search:
            self.navigationController?.pushViewController(AddFriendViewController(), animated: true)
//        case .settings:
//            //UIViewController.showViewController(storyBoardName: "UserSettings", viewControllerId: "SettingsViewController")
//            //            let storyboard: UIStoryboard = UIStoryboard(name: "UserSettings", bundle: nil)
//            //            let settingsVC = storyboard.instantiateViewController(identifier: "SettingsViewController")
//            //            self.navigationController?.pushViewController(settingsVC, animated: true)
//            self.tabBarController?.tabBar.items?[0].title = "Explore"
//            self.tabBarController?.tabBar.items?[1].title = "Updates"
//            self.tabBarController?.tabBar.items?[2].title = "Personal"
//            self.showAlert(title: "We are still under construction", message: "please visit this at a later date ")
        }
    }
    
    //---------------------------------------------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        suShareListener?.remove()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setSuShareListener()
        
    }
    
    private func toggleExplore() {
        exploreButton.isEnabled = false
        friendsButton.isEnabled = true
        exploreButton.underline()
        
    }
    
    private func setSuShareListener() {
        suShareListener = Firestore.firestore().collection(DatabaseService.suShareCollection).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    let allShares = snapshot.documents.map {SuShare($0.data())}
                    let sortByFlagged = allShares.filter { $0.isTheSuShareFlagged != true }
                    // take out all the ones that are flagged
                    
                    
                    let sortedAllShares = sortByFlagged.sorted {$0.createdDate.dateValue() > $1.createdDate.dateValue()}
                    self.originalSusus = sortedAllShares
                    if self.currentTags.isEmpty && self.currentQuery.isEmpty {
                        self.currentSusus = sortedAllShares
                    }
                }
            }
        })
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
        let wasPressed = tagFilter(tag: sender.tag)
        switch wasPressed {
        case true:
            sender.backgroundColor = .systemGray4
            sender.tintColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        case false:
            sender.backgroundColor = .systemGray6
            sender.tintColor = #colorLiteral(red: 0, green: 0.6613236666, blue: 0.617059052, alpha: 1)
        }
    }
    
    private func tagFilter(tag: Int) -> Bool {
        var wasPressed = false
        if !currentTags.contains(tag) {
            currentTags.append(tag)
            wasPressed.toggle()
        } else {
            guard let index = currentTags.firstIndex(of: tag) else {
                return wasPressed
            }
            currentTags.remove(at: index)
            if currentTags.isEmpty && currentQuery == "" {
                currentSusus = originalSusus
                return wasPressed
            }
        }
        currentSusus = originalSusus.filter { currentTags.contains($0.category.first ?? 0)}
        return wasPressed
    }
    
    //need to add case for returning to 0 tags, with query
    
    // createSuShare segue
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        // performSegue(withIdentifier: "goToCreateSusu", sender: self)
        
        //https://stackoverflow.com/questions/18777627/segue-from-one-storyboard-to-a-different-storyboard
        let vc = UIStoryboard(name: "CreateSusu", bundle: nil).instantiateViewController(withIdentifier: "CreateSusu") as? CreateSusuViewController
        
        //  https://www.appcoda.com/ios-programming-101-how-to-hide-tab-bar-navigation-controller/#:~:text=When%20it's%20set%20to%20YES,the%20RecipeDetailViewController%20to%20%E2%80%9CYES%E2%80%9D.
        vc?.hidesBottomBarWhenPushed = true // hides the botton tab bar
        
        self.show(vc!, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreateSusu" {
            guard let createVC = segue.destination as? CreateSusuViewController else { return }
            //  createVC.transitioningDelegate = self
            // createVC.modalPresentationStyle = .popover
            // navigationController?.pushViewController(createVC, animated: true)
            
            //            createVC.transitioningDelegate = self
            //            createVC.modalPresentationStyle = .custom
            //            navigationController?.pushViewController(createVC, animated: true)
            //    present(createVC, animated: true)
        }
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
        cell.delegate = self // will not work without it 
        cell.configureCell(suShare: suShare)
        cell.shadowConfig()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SushareDetail", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        let currentSuShare = currentSusus[indexPath.row]
        detailVC.sushare = currentSuShare
        database.getUserForSuShare(suShare: currentSuShare) { [weak self]( result) in
            switch result{
            case.failure(let error):
                print(error.localizedDescription)
            case.success(let userSuShare):
                DispatchQueue.main.async {
                    detailVC.user = userSuShare
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
        //navigationController?.pushViewController(detailVC, animated: true)
        //        let storyboard = UIStoryboard(name: "PaymentSegment", bundle: nil)
        //        guard let vc = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController else {
        //            return
        //        }
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height / 2.80
        let width =
            UIScreen.main.bounds.size.width - 100
        return CGSize(width: width, height: height * 2)
    }
    
    //need insets
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        40
    }
    
    
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.lowercased(), !query.isEmpty else {
            if !currentTags.isEmpty {
                currentSusus = originalSusus.filter { currentTags.contains($0.category.first ?? 0)}
            } else {
                currentSusus = originalSusus
            }
            return
        }
        currentQuery = query
        currentSusus = originalSusus.filter { $0.suShareDescription.lowercased().contains(query) || $0.susuTitle.lowercased().contains(query)}
        
    }
}

//---------------------------------------------------------------------------------
// Jaheed

extension ExploreViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if source.modalPresentationStyle == .custom {
            circularTransition.transitionMode = .present
            //circularTransition.startingPoint = createButton.center
            // circularTransition.circleColor = createButton.backgroundColor!
            
            return circularTransition
        } else {
            transiton.isPresenting = true
            return transiton
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

extension ExploreViewController: extraOptionsButtonDelegate {
    func buttonWasPressed(_ cellData: ExploreCell, suShareData: SuShare) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Report", style: .destructive) {
            alertAction in
            
            print("here is where was change the status on the suShare")
            print("we should also reload the sushare list and hid the sushare once its confirmed ")
            
            self.updateSushareFlagged(suShare: suShareData)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(reportAction)
        present(alertController, animated: true)
        
    }
    
    private func updateSushareFlagged(suShare: SuShare){
        database.updateFlaggedInSuShare(suShareId: suShare.suShareId) { (result) in
            switch result {
            case .failure(let error):
                print("this is inside of updateSushareFlagged function: \(error.localizedDescription)")            case .success(let isItDone):
                    print("is it done: \(isItDone) inside of explore controller")
                    // should show alert and refresh the controller
                    self.addSuShareToFlaggedList(suShare: suShare)
            }
        }
    }
    
  private func addSuShareToFlaggedList(suShare: SuShare){
        // once done should show alert that its done
        database.flagASuShare(suShare: suShare) { (result) in
            switch result {
            case .failure(let error):
                print("this is inside of addSuShareToFlaggedList function: \(error.localizedDescription)")
            case .success(let good):
                self.showAlert(title: "this SuShare has been flagged", message: "we got your report")
                print("this is inside of addSuShareToFlaggedList \(good)")
            }
        }
    }
    func reportAlertAction() {
        
    }
}
