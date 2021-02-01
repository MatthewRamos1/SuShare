//
//  StorageService.swift
//  SuShare
//
//  Created by Jaheed Haynes on 5/27/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
  
  // reference to the Firebase storage
  private let storageRef = Storage.storage().reference()
  let view = LoadingView()
  
  // default parameters in Swift e.g userId: String? = nil
    public func uploadPhoto(userId: String? = nil, sushareId: String? = nil, image: UIImage, vc: UIViewController? = nil, completion: @escaping (Result<URL, Error>) -> ()) {
    
    // convert UIImage to Data because this is the object posting to Firebase Storage
    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
      return
    }
    
    var photoReference: StorageReference! // nil
    
    if let userId = userId { // coming from PersonalViewController
      photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
    } else if let sushareId = sushareId { // coming from CreateSusuViewController
      photoReference = storageRef.child("SuSharePhotos/\(sushareId).jpg")
    }
    
    // configuring metatdata for the object being uploaded
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpg" // MIME type
    
    let uploadTask = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
      if let error = error {
        completion(.failure(error))
      } else if let _ = metadata {
        photoReference.downloadURL { (url, error) in
          if let error = error {
            completion(.failure(error))
          } else if let url = url {
            completion(.success(url))
          }
        }
      }
    }
    
    uploadTask.observe(.progress) { snapshot in
        let percentComplete = 100 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
        print(percentComplete)
        DispatchQueue.main.async {
            vc?.showUploadAlert(title: "Uploading", message: "Please Wait...")
        }
    }
    
    uploadTask.observe(.success) { snapshot in
        print("success")
        DispatchQueue.main.async {
            vc?.dismiss(animated: true, completion: nil)
            vc?.showAlert(title: "Success", message: "your profile has been updated")
        }
    }
    
  }
}
