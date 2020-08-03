//
//  BackendAPIAdapter.swift
//  Basic Integration
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import FirebaseFunctions

struct Product {
    let emoji: String
    let price: Int
}

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    enum APIError: Error {
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .unknown:
                return "Unknown error"
            }
        }
    }

    static let sharedClient = MyAPIClient()

    
    func createDummyUser(fullName: String, completion: @escaping (Result <String, Error>) -> () ) {
       // var customer_id = ""
        Functions.functions().httpsCallable("createStripeCustomer").call(["full_name" : "John Doe", "email" : "johndoe420-69@gmail.com"]) { (response, error) in
                   if let error = error {
                       print(error)
                   } else {
                   if let response = (response?.data as? [String: Any]) {
                   let customer_id = response["customer_id"] as! String?
                   
                    completion(.success(customer_id!))
//                       print(publishable_key)
//                       Stripe.setDefaultPublishableKey(publishable_key!)
//                       profile.stripe_customer_id = customer_id!
//                       let defaults = UserDefaults.standard
//                       currentProfile = profile
                       do {
//                           try self.db.collection("Profile").document(emailAdd).setData(from: profile)
//                           DispatchQueue.main.async {
//                               self.switchToWelcomePage()
//                           }
                        print("success!")
                       } catch let error {
                           print (error)
                       }
                   }
               }
        }
    }
    func createDummyUser2() {
            Functions.functions().httpsCallable("createStripeCustomer").call(["full_name" : "Kevin Doe", "email" : "kevindoe420-69@gmail.com"]) { (response, error) in
                       if let error = error {
                           print(error)
                       }
                       if let response = (response?.data as? [String: Any]) {
                           let customer_id = response["customer_id"] as! String?
                           print(customer_id)
                        do {
                            print("success!")
                           } catch let error {
                               print (error)
                           }
                       }
                   }
        }
    
    func createCustomAccount() {
        Functions.functions().httpsCallable("createCustomAccount").call(["full_name" : "Kevin Doe", "email" : "kevindoe420-69@gmail.com"]) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = (response?.data as? String) {
                print("Account id: \(response)")
            }
        }
    }


    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
            Functions.functions().httpsCallable("getStripeEphemeralKeys").call(["api_version" : apiVersion, "customer_id" : "cus_HZHr6xok84h97G"]) { (response, error) in
                if let error = error {
                    print(error)
                    completion(nil, error)
                }
                if let response = (response?.data as? [String: Any]) {
                    completion(response, nil)
                    print("MyStripeAPIClient response \(response)")
                }
            }
    }
    
  
}
