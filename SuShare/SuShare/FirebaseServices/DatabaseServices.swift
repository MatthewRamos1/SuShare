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
    static let friendsCollection = "friends"
    
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
    
    public func delete(susu: SuShare, completion: @escaping (Result<Bool, Error>) -> ()) {
        
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
    
    public func addToFavorites(item: SuShare, completion: @escaping(Result<Bool,Error>) -> ()){
        guard let user = Auth.auth().currentUser else {return}
        
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.favoriteCollection).document(item.suShareId).setData(
            ["susuTitle":item.susuTitle,
             "susuImage": item.susuImage ?? UIImage(named: "suShareLogo-White-eggShell")! ,
             "favortieDate": Timestamp(date: Date()),
             "suShareId": item.suShareId
        ]) { (error) in
            if let error = error {
                completion(.failure(error))
            }else{
                completion(.success(true))
            }
        }
        
    }
    
    public func removeFromFavorite(item: SuShare, completion: @escaping(Result<Bool,Error>) -> ()){
        guard let user = Auth.auth().currentUser else {return}
        
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.favoriteCollection).document(item.suShareId).delete(){ (error) in
            if let error = error{
                completion(.failure(error))
            }else{
                completion(.success(true))
            }
        }
        
    }
    
    public func updateDatabaseUserImage(
        photoURL: String,
        completion: @escaping (Result<Bool, Error>) -> ()) {
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
    
    public func updateUserFriend( completion: @escaping
        (Result<[String], Error>) -> ())    {
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
    
} 

