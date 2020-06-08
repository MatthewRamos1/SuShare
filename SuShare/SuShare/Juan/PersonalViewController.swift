//
//  PersonalViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class PersonalViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "SuShare"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.6823529412, blue: 0.631372549, alpha: 1)
        personalView.personalCollectionView.register(PersonalCell.self, forCellWithReuseIdentifier: "personalCell")
        suShares = [SuShare]()
        personalView.personalCollectionView.dataSource = self
        personalView.personalCollectionView.delegate = self
    }

}

extension PersonalViewController: UICollectionViewDataSource    {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }   else    {
            return 5
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personalCell", for: indexPath) as? PersonalCell else {
            fatalError()
        }
        // configure cell
        cell.backgroundColor = .systemBackground
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let section = indexPath.section
        if section == 0 {
            guard let profileHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeader", for: indexPath) as? ProfileHeaderView   else    {
                fatalError()
            }
            profileHeaderView.backgroundColor = .white
            return profileHeaderView
        }   else  {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderView   else    {
                fatalError()
            }
            headerView.backgroundColor = .white
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
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.84
        let itemHeight: CGFloat = maxSize.height * 0.5
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // segue
    }
    
}
