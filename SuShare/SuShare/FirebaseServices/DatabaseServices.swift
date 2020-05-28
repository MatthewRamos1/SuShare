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
    
   private let db = Firestore.firestore()
    
    public func createASusu(susuTitle: String, description: String, potAmount: Double, numOfParticipants: Int, paymentSchedule: String,
                        //  displayName: String,
                            completion: @escaping (Result <String, Error>) -> () ) {
        
        //guard let user = Auth.auth().currentUser else {
          //  return
              //  }
        

        let docRef = db.collection(DatabaseService.suShareCollection).document()
            print("docRef is \(docRef)")
        
        
        db.collection(DatabaseService.suShareCollection).document(docRef.documentID).setData([
            "susuTitle": susuTitle,
            "description": description,
            "potAmount": potAmount,
            "numOfParticipants": numOfParticipants,
            "paymentSchedule": paymentSchedule,
        //    "userId": user.uid,
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
    
    public func delete(susu: Susu, completion: @escaping (Result<Bool, Error>) -> ()) {
        db.collection(DatabaseService.suShareCollection).document(susu.iD).delete { (error) in
                  if let error = error {
                      completion(.failure(error))
                  } else {
                      completion(.success(true))
                  }}} // end of delete
    
    
}

