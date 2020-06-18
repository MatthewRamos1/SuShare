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
  
  // default parameters in Swift e.g userId: String? = nil
  public func uploadPhoto(userId: String? = nil, sushareId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
    
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
    
    let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
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
  }
}
