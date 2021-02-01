//
//  SettingsViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/8/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

enum SettingsType{
    case username
    case paymentOption
    case signOut
}

class UserSettingsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    private let databaseService = DatabaseService()
    private let storageService = StorageService()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        // tells the gesture what is should do when the action happens
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
    }()
    
    private func configureUserImageSettings(){
        databaseService.getCurrentUser { [weak self](result) in
            switch result{
            case.failure(let error):
                DispatchQueue.main.async {
                    print("ERROR: \(error.localizedDescription)")
                }
            case.success(let user):
                DispatchQueue.main.async {
                    self?.usernameLabel.text = user.username
                    let url = URL(string: user.profilePhoto)
                    self?.imageView.kf.indicatorType = .activity
                    self?.imageView.kf.setImage(with: url)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarSetup()
        updateUI()
        view.backgroundColor = .systemBackground
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(longPressGesture)
        setUpImageView()
        configureUserImageSettings()
    }
    
    private func setUpImageView(){
        imageView.layer.borderWidth = 0.75
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    private func tabBarSetup(){
        self.tabBarController?.tabBar.items?[0].title = "Explore"
        self.tabBarController?.tabBar.items?[1].title = "Updates"
        self.tabBarController?.tabBar.items?[2].title = "Personal"
        self.navigationController?.navigationBar.topItem?.title = "SuShare"
    }
    
    private func updateUI(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        imageView.kf.setImage(with: user.photoURL)
        usernameLabel.text = user.displayName
    }
    
    @objc private func showPhotoOptions() {
        let alertController = UIAlertController(title: "Choose photo Option", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        
        let photoLibrary = UIAlertAction(title: "Photos", style: .default) {
            actionAlert in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            // if there is no camera avaiable then the camera option is not avaialble either
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func updateStorageServices(userId: String, image: UIImage){
        //activityIndicator.startAnimating()
        storageService.uploadPhoto(userId: userId, image: image, vc: self) {
            [weak self]
            (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "cant access storage right now", message: "please try again \(error.localizedDescription)")
                }
            case .success(let imageURl):
                self?.updateDatabaseUser(photoURL: imageURl.absoluteString)
            }
        }
    }
    
    private func updateDatabaseUser(photoURL: String) {
        databaseService.updateDatabaseUserImage(photoURL: photoURL) { (result) in
            switch result {
            case .failure(let error):
                print("failed to update db user: \(error.localizedDescription)")
            case .success:
                //print("successfully updated db user")
                self.requestChangesToDatabase(url: URL(string: photoURL)!)
                
            }
        }
    }
    
    private func requestChangesToDatabase(url: URL) {
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.photoURL = url
        request?.commitChanges(completion: { (error) in
            if let error = error {
                print("this aint work \(error.localizedDescription)")
            } else {
                print()
            }
        })
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        print("button pressed")
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(storyBoardName: "LoginView", viewControllerId: "LoginViewController")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error signing out", message: "\(error.localizedDescription)")
            }
        }
    }
    
}


extension UserSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        guard let user = Auth.auth().currentUser, let savedImage = selectedImage else {
            return
        }
        updateStorageServices(userId: user.uid, image: savedImage)
        dismiss(animated: true)
    }
}
