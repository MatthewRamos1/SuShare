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
    
    var suShareListener: ListenerRegistration?
    var boldFont: UIFont?
    var thinFont: UIFont?
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
        
    }
    
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
        
        currentSusus = originalSusus.filter { currentTags.contains($0.category.rawValue)}
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
