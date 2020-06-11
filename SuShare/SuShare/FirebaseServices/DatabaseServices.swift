//
//  DatabaseServices.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService{
    
    static let suShareCollection = "suShare"
    static let userCollection = "users"
    static let commentCollection = "comments"
    static let favoriteCollection = "favorites"
   
   private let db = Firestore.firestore()
    
   static let shared = DatabaseService()
  
    public func createASusu(
        sushare: SuShare,
      //  susuTitle: String, description: String, potAmount: Double, numOfParticipants: Int, paymentSchedule: String, category: [String],
                        //  displayName: String,
        completion: @escaping (Result <String, Error>) -> () ) {
        
        guard let user = Auth.auth().currentUser else {
           return
                }

        let docRef = db.collection(DatabaseService.suShareCollection).document()
            print("docRef is \(docRef)")
        
        db.collection(DatabaseService.suShareCollection).document(docRef.documentID).setData([
            "securityState": sushare.securityState,
            "susuTitle": sushare.susuTitle,
            "susuImage": sushare.susuImage,
            "description": sushare.description,
            "potAmount": sushare.potAmount,
            "numOfParticipants": sushare.numOfParticipants,
            "paymentSchedule": sushare.paymentSchedule,
            "userId": user.uid,
            "createdDate": Timestamp(date: Date()),
            "category": sushare.category,
            "iD": docRef.documentID
        
        ]) { (error) in
            if let error = error {
                print("the error is inside of the database service: \(error.localizedDescription)")
            } else {
                print("this is before the success")
                completion(.success(docRef.documentID))
                print("this is after the success")
            }
        }
    } // end of create func
    
    public func delete(susu: SuShare, completion: @escaping (Result<Bool, Error>) -> ()) {
        db.collection(DatabaseService.suShareCollection).document(susu.suShareId).delete { (error) in
                  if let error = error {
                      completion(.failure(error))
                  } else {
                      completion(.success(true))
                  }}} // end of delete

    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let email = authDataResult.user.email else {
            return
        }
        
        db.collection(DatabaseService.userCollection).document(authDataResult.user.uid).setData(["email" : email, "userId": authDataResult.user.uid]) { (error) in

            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func updateDatabaseUser(username: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.userCollection).document(user.uid).updateData(["username": username]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
} 

