//
//  SettingsViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/8/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

enum SettingsType{
    case username
    case paymentOption
    case signOut
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let databaseService = DatabaseService()
    private let storageService = StorageService()
    
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tabBarController?.tabBar.items?[0].title = "Explore"
         self.tabBarController?.tabBar.items?[1].title = "Personal"
        self.navigationController?.navigationBar.topItem?.title = "SuShare"
        updateUI()
        view.backgroundColor = .systemBackground
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(longPressGesture)
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
           
           let photoLibrary = UIAlertAction(title: "photoLibrary", style: .default) {
               actionAlert in
               self.imagePickerController.sourceType = .photoLibrary
               self.present(self.imagePickerController, animated: true)
           }
           let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
           if UIImagePickerController.isSourceTypeAvailable(.camera){
               // if there is no camera avaiable then the camera option is not avaialble either
               alertController.addAction(cameraAction)
           }
           alertController.addAction(photoLibrary)
           alertController.addAction(cancelAction)
           present(alertController, animated: true)
       }
    
    @IBAction func updateImagePressed(_ sender: UIButton) {
        
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
 
    private func updateDatabaseUser(photoURL: String) {
        databaseService.updateDatabaseUserImage(photoURL: photoURL) { (result) in
            switch result {
            case .failure(let error):
                print("failed to update db user: \(error.localizedDescription)")
            case .success(let docId):
               //print("successfully updated db user")
                break
            }
        }
    }
}



extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
}
