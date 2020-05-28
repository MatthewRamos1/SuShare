//
//  ExploreViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    @IBAction func exploreSegementedControl(_ sender: UISegmentedControl) {
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var originalSusus = [SuShare]()
    var currentSusus = [SuShare]()
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
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell", for: indexPath) as? ExploreCell else {
            fatalError("Couldn't downcast to ExploreCell, check cellForItemAt")
        }
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
        currentQuery = query
    }
}
