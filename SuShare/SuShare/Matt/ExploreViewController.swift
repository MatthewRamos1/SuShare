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
    
    var originalSusus = [Susu]()
    var currentSusus = [Susu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    @IBAction func tagButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            currentSusus = originalSusus.filter { $0.category == .new}
        case 1:
            currentSusus = originalSusus.filter { $0.category == .new}
        case 2:
            currentSusus = originalSusus.filter { $0.category == .new}
        case 3:
            currentSusus = originalSusus.filter { $0.category == .new}
        case 4:
            currentSusus = originalSusus.filter { $0.category == .new}
        case 5:
            currentSusus = originalSusus.filter { $0.category == .new}
        default:
            currentSusus = originalSusus.filter { $0.category == .new}

        }
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
