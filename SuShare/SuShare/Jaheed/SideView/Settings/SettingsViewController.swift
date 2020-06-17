//
//  SettingsViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/8/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    @IBAction func updateImagePressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
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
            case .success:
                print("successfully updated db user")
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
