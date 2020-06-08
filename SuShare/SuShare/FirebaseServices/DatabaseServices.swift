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

class DatabaseService{
    
    static let suShareCollection = "suShare"
    static let userCollection = "users"
    static let commentCollection = "comments"
    static let favoriteCollection = "favorites"
    static let friendsCollection = "friends"
    
    private let db = Firestore.firestore()
    
    static let shared = DatabaseService()
    
    public func createASusu(susuTitle: String, description: String, potAmount: Double, numOfParticipants: Int, paymentSchedule: String,
                            //  displayName: String,
        completion: @escaping (Result <String, Error>) -> () ) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        
        let docRef = db.collection(DatabaseService.suShareCollection).document()
        print("docRef is \(docRef)")
        
        
        db.collection(DatabaseService.suShareCollection).document(docRef.documentID).setData([
            "susuTitle": susuTitle,
            "description": description,
            "potAmount": potAmount,
            "numOfParticipants": numOfParticipants,
            "paymentSchedule": paymentSchedule,
            "userId": user.uid,
            "createdDate": Timestamp(date: Date()),
            //"category": category,
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
        db.collection(DatabaseService.suShareCollection).document(susu.iD).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }}} // end of delete
    
    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        let user = authDataResult.user
        
        db.collection(DatabaseService.userCollection).document(authDataResult.user.uid).setData(["email" : user.email ?? "", "userId": user.uid, "username": user.displayName ?? ""]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func createDatabaseFriend(user: String, friend: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        db.collection(DatabaseService.friendsCollection).document().setData(["currentUser": user, "friend": friend]) { (error) in
            if let error = error    {
                completion(.failure(error))
            } else  {
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
    
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> ())  {
        db.collection(DatabaseService.userCollection).getDocuments { (snapshot, error) in
            if let error = error    {
                print("error retrieving all user docs in collection: \(error)")
                completion(.failure(error))
            } else  {
                if let snapshot = snapshot  {
                    let users = snapshot.documents.map {User($0.data())}
                    let usersSorted = users.sorted  {$0.username.lowercased() < $1.username.lowercased()}
                    completion(.success(usersSorted))
                }
            }
        }
    }
    
    func getSingleUser(userEmail: String, completion: @escaping (Result<User, Error>) -> ()) {
        db.collection(DatabaseService.userCollection).document(userEmail).getDocument { (document, error) in
            if let error = error    {
                print(error.localizedDescription)
                completion(.failure(error))
            } else  {
                if let document = document?.data()  {
                    let user = User(document)
                    completion(.success(user))
                }
            }
        }
    }
    
} 

