//
//  DatabaseServices.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseServices {
    
    static let userCollection = "users"
    static let commentCollection = "comments"
    static let favoriteCollection = "favorites"
    
    let db = Firestore.firestore()
    
    static let shared = DatabaseServices()
    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let email = authDataResult.user.email else {
            return
        }
        
        db.collection(DatabaseServices.userCollection).document(authDataResult.user.uid).setData(["email" : email, "userId": authDataResult.user.uid]) { (error) in

            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func updateDatabaseUser(username: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseServices.userCollection).document(user.uid).updateData(["username": username]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
}
