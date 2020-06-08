//
//  HighlightsViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HighlightsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var databaseService = DatabaseService()
    
    private var authSession = AuthenticationSession()
    
    private var listener: ListenerRegistration?
    
    private let identifier = "highlightsCell"
    
    private var susu = [Susu]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //authSession.signOutExistingUser()
        view.backgroundColor = .systemTeal

      collectionView.delegate = self
      collectionView.dataSource = self
       collectionView.register(UINib(nibName: "HighlightsCell", bundle: nil), forCellWithReuseIdentifier: "highlightsCell")
    }
    
    
//        override func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(true)
//            listener = Firestore.firestore().collection(DatabaseServices.susuCollection).addSnapshotListener({ [weak self] (snapshot, error) in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        self?.showAlert(title: "Try again later", message: "\(error.localizedDescription)")
//                    }
//                } else if let snapshot = snapshot {
//                    let susus = snapshot.documents.map { Susu($0.data()) }
//                    self?.susu = susus
//                }
//            })
//        }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // no longer listening for changes from Firebase
        listener?.remove()
    }
    
    
    
}

extension HighlightsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "highlightsCell", for: indexPath) as? HighlightsCell else {
            //showAlert(title: "Error", message: "Could not load Data")
            fatalError("could not downcast")
        }
        //cell.shadowDecorate()
        //let item = susu[indexPath.row]
        // configure cell here
        
        return cell
    }
    
    
}

extension HighlightsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let maxSize: CGSize = UIScreen.main.bounds.size
        //let itemWidth: CGFloat = maxSize.width * 0.90
        let height = UIScreen.main.bounds.size.height / 3
        let width =
        UIScreen.main.bounds.size.width - 200
        
        return CGSize(width: width, height: height * 2)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let susus = susu[indexPath.row]
//
//        let susuDetailStoryBoard = UIStoryboard(name: "Highlights", bundle: nil)
//
//        guard let susuDetailController = susuDetailStoryBoard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else {
//
//            showAlert(title: "ok", message: "could not downcast to DetailViewController")
//            fatalError("could not downcast to DetailViewController")
//        }
//        susuDetailController.susu = susus
//
//        navigationController?.pushViewController(susuDetailController, animated: true)
    }

}
