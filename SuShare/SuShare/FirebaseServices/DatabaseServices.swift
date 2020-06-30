//
//  DatabaseServices.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.

import Foundation
import FirebaseFirestore
import FirebaseAuth

import UIKit
import FirebaseAuth
//import LBTAComponents
//import FirebaseDatabase
//import FirebaseStorage
//import JGProgressHUD

class DatabaseService{
    
    static let suShareCollection = "suShare"
    static let userCollection = "users"
    static let commentCollection = "comments"
    static let favoriteCollection = "favorites"
    static let friendsCollection = "friends"
    
    private let db = Firestore.firestore()
    
    static let shared = DatabaseService()
    
    // anothe way to get database user
    private func anotherDatabaseUser(userId: String, completion: @escaping (Result<User, Error>) -> () ){
        db.collection(DatabaseService.userCollection).whereField("userId", isEqualTo: userId).getDocuments {  (snapshot, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let snapshot = snapshot {
                        
                        let user = snapshot.documents
                        
                        // do sorted here
                       // items.listedDate
                        //completion(.success(items.sorted(by: { $0.listedDate.seconds > $1.listedDate.seconds
                       // completion(.success(user))
                    }
                    }
    }
 
    
    public func createASuShare(
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
            //"susuImage": sushare.susuImage,
            "description": sushare.suShareDescription,
            "potAmount": sushare.potAmount,
            "numOfParticipants": sushare.numOfParticipants,
            "paymentSchedule": sushare.paymentSchedule,
            "userId": user.uid,
            "category": sushare.category,
            "createdDate": sushare.createdDate,
            "iD": docRef.documentID,
            "usersApartOfSuShare": sushare.usersInTheSuShare,
            "favId": sushare.favId
            
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
    
    public func deleteSuShare(susu: SuShare, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        db.collection(DatabaseService.suShareCollection).document(susu.suShareId).delete { (error) in
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
    
    public func createDatabaseFriend(user: String, friend: String, friendUsername: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        db.collection(DatabaseService.friendsCollection).document().setData(["currentUser": user, "friend": friend, "friendUsername": friendUsername]) { (error) in
            if let error = error    {
                completion(.failure(error))
            } else  {
                completion(.success(true))
            }
        }
    }
    
    public func checkForFriendship(user: User, completion: @escaping (Result<Bool, Error>) -> ())    {
        db.collection(DatabaseService.friendsCollection).whereField("friend", isEqualTo: user.userId).getDocuments { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            }
            else    {
                if let snapshot = snapshot  {
                    if snapshot.count > 0   {
                        completion(.success(true))
                    }
                }
            }
        }
    }
    
    public func updateDatabaseUser(username: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.userCollection).document(user.uid).updateData(["username": username]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
    
   public func updateFireBaseUserWithStripeStuff(fullName: String, stripeCustomerId: String, completion: @escaping (Result<Bool, Error>) -> () ){
           
        guard let user = Auth.auth().currentUser
            else { return }
    
        db.collection(DatabaseService.userCollection).document(user.uid).updateData([
            "fullName": fullName,
            "stripeCustomerId" : stripeCustomerId
                ]) { (error) in
            if let error  = error {
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
    
   
    
    // add refresher, or refactor to use listener
    func getCreatedSuSharesForCurrentUser(completion: @escaping (Result<[SuShare], Error>) -> ())  {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        db.collection(DatabaseService.suShareCollection).whereField("userId", isEqualTo: user.uid).getDocuments { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot  {
                    let suShares = snapshot.documents.map {SuShare($0.data())}
                    let suSharesSorted = suShares.sorted {$0.susuTitle.lowercased() < $1.susuTitle.lowercased()}
                    completion(.success(suSharesSorted))
                }
            }
        }
    }
    
    func getCreatedSuShares(user: User, completion: @escaping (Result<[SuShare], Error>) -> ())  {
        db.collection(DatabaseService.suShareCollection).whereField("userId", isEqualTo: user.userId).getDocuments { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot  {
                    let suShares = snapshot.documents.map {SuShare($0.data())}
                    let suSharesSorted = suShares.sorted {$0.susuTitle.lowercased() < $1.susuTitle.lowercased()}
                    completion(.success(suSharesSorted))
                }
            }
        }
    }
    
    //---------------------------------------------------------------------
    //MARK: JAHEED
    
    public func postComment(sushare: SuShare, comment: String,
                            completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser,
            
            let displayName = user.displayName else {
                print("missing user data")
                return
        }
        
        // getting a new document
        let docRef = db.collection(DatabaseService.suShareCollection)
            .document(sushare.suShareId)
            .collection(DatabaseService.commentCollection).document()
        
        // using the new document from above to write its contents to firebase
        db.collection(DatabaseService.suShareCollection)
            .document(sushare.suShareId)
            .collection(DatabaseService.commentCollection)
            .document(docRef.documentID).setData(
                ["comment" : comment,
                 "commentDate": Timestamp(date: Date()),
                 "susuName": sushare.susuTitle,
                 "susuId": sushare.suShareId,
                 "creatorName": sushare.userId,
                 "commentedBy": displayName]) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
        }
    }
    
    public func addToFavorites(sushare: SuShare, completion: @escaping(Result<Bool,Error>) -> ()){
        let docRef = db.collection(DatabaseService.suShareCollection).document()
        print("docRef is \(docRef)")
        guard let user = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.favoriteCollection).document(docRef.documentID).setData(["securityState": sushare.securityState,
                                                                                               "susuTitle": sushare.susuTitle,
                                                                                               "imageURL": sushare.imageURL,
                                                                                               "description": sushare.suShareDescription,
                                                                                               "potAmount": sushare.potAmount,
                                                                                               "numOfParticipants": sushare.numOfParticipants,
                                                                                               "paymentSchedule": sushare.paymentSchedule,
                                                                                               "userId": user.uid,
                                                                                               "category": sushare.category,
                                                                                               "createdDate": sushare.createdDate,
                                                                                               "iD": sushare.suShareId,
                                                                                               "favId": docRef.documentID,
                                                                                               "usersApartOfSuShare": sushare.usersInTheSuShare])
        { (error) in
            //
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
                print("added favorite")
            }
        }
    }
    
    public func removeFromFavorite(suShare: SuShare, completion: @escaping(Result<Bool,Error>) -> ()){
        guard let currentUser = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.favoriteCollection).whereField("userId", isEqualTo: currentUser.uid).whereField("iD", isEqualTo: suShare.suShareId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    snapshot.documents.forEach { (document) in
                        document.reference.delete()
                        completion(.success(true))
                    }
                }
            }
        }
    }
    
    public func isSuShareFavorite(suShare: SuShare, completion: @escaping (Result<Bool, Error>) -> ())   {
        guard let currentUser = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.favoriteCollection).whereField("iD", isEqualTo: suShare.suShareId).whereField("userId", isEqualTo: currentUser.uid).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    if snapshot.count > 0 {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                }
            }
        }
    }
    
    public func getAllFavorites(user: User, completion: @escaping (Result<[SuShare], Error>) -> ()) {
        
        db.collection(DatabaseService.favoriteCollection).whereField("userId", isEqualTo: user.userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    let favSuShares = snapshot.documents.map {SuShare($0.data())}
                    completion(.success(favSuShares))
                }
            }
        }
    }
    
    public func getAllFavoritesCurrent(completion: @escaping (Result<[SuShare], Error>) -> ()) {
        
        guard let currentUser = Auth.auth().currentUser else {return}
        
        db.collection(DatabaseService.favoriteCollection).whereField("userId", isEqualTo: currentUser.uid).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    let favSuShares = snapshot.documents.map {SuShare($0.data())}
                    completion(.success(favSuShares))
                }
            }
        }
    }
    
    public func updateDatabaseUserImage(photoURL: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection)
            .document(user.uid).updateData(["photoURL" : photoURL]) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
        }
    }
    
    public func updateUserFriend(completion: @escaping (Result<[String], Error>) -> ()){
    guard let user = Auth.auth().currentUser else {
        return
    }
    db.collection(DatabaseService.friendsCollection).whereField("currentUser", isEqualTo: user.uid).getDocuments { (snapshot, error) in
        if let error = error    {
            completion(.failure(error))
        }
        else    {
            if let snapshot = snapshot  {
                let users = snapshot.documents.map {$0.get("friendUsername") as! String}
                //let usersSorted = users.sorted  {$0.username.lowercased() < $1.username.lowercased()}
                
                completion(.success(users))
            }
        }
    }
}
    
    // MARK: THE OTHER ONE
    public func getCurrentUser(completion: @escaping (Result<User, Error>) -> ())   {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError()
        }
        
        db.collection(DatabaseService.userCollection).document(currentUser.uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshotUser = snapshot?.data()  {
                    let user = User(snapshotUser)
                    completion(.success(user))
                }
            }
        }
    }
    
    
    public func databaseAddFriend(user: User, completion: @escaping (Result<Bool, Error>) -> ()){
        let docRef = db.collection(DatabaseService.friendsCollection).document()
        guard let currentUser = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.friendsCollection).document(docRef.documentID).setData(["userId": user.userId]) { (error) in
            if let error = error{
                completion(.failure(error))
            }else{
                completion(.success(true))
            }
        }
    }
    
    public func databaseRemoveFriend(user: User, completion: @escaping(Result<Bool,Error>) -> ()){
        guard let currentUser = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.friendsCollection).whereField("userId", isEqualTo: currentUser.uid).whereField("userId", isEqualTo: user.userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    snapshot.documents.forEach { (document) in
                        document.reference.delete()
                        completion(.success(true))
                    }
                }
            }
        }
    }
} 

