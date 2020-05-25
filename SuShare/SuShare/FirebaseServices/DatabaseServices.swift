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
    
    static let susuCollection = "SusuCollection"
    
   private let db = Firestore.firestore()
    
//    private init {
//
//    }
    
    /*
     susuTitle
     susuDes
     AmountofPot
     numOfParticipants
     PaymentSchdeuele
     */
    public func createASusu(susuTitle: String, description: String, potAmount: Double, numOfParticipants: Int, paymentSchedule: String, displayName: String, completion: @escaping (Result <String, Error>) -> () ) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        

        let docRef = db.collection(DatabaseService.susuCollection).document()
            
        db.collection(DatabaseService.susuCollection).document(docRef.documentID).setData([
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
                completion(.success(docRef.documentID))
            }
        }
    } // end of create func
    
    public func delete(susu: Susu, completion: @escaping (Result<Bool, Error>) -> ()) {
        db.collection(DatabaseService.susuCollection).document(susu.iD).delete { (error) in
                  if let error = error {
                      completion(.failure(error))
                  } else {
                      completion(.success(true))
                  }}} // end of delete
    
    
}

