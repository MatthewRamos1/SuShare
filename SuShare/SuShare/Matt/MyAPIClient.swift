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
//    var baseURLString: String? = nil
//    var baseURL: URL {
//        if let urlString = self.baseURLString, let url = URL(string: urlString) {
//            return url
//        } else {
//            fatalError()
//        }
//    }
    
//    func createPaymentIntent(products: [Product], shippingMethod: PKShippingMethod?, country: String? = nil, completion: @escaping ((Result<String, Error>) -> Void)) {
//        let url = self.baseURL.appendingPathComponent("create_payment_intent")
//        var params: [String: Any] = [
//            "metadata": [
//                // example-mobile-backend allows passing metadata through to Stripe
//                "payment_request_id": "B3E611D1-5FA1-4410-9CEC-00958A5126CB",
//            ],
//        ]
//        params["products"] = products.map({ (p) -> String in
//            return p.emoji
//        })
//        if let shippingMethod = shippingMethod {
//            params["shipping"] = shippingMethod.identifier
//        }
//        params["country"] = country
//        let jsonData = try? JSONSerialization.data(withJSONObject: params)
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//            guard let response = response as? HTTPURLResponse,
//                response.statusCode == 200,
//                let data = data,
//                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??),
//                let secret = json?["secret"] as? String else {
//                    completion(.failure(error ?? APIError.unknown))
//                    return
//            }
//            completion(.success(secret))
//        })
//        task.resume()
//    }
    
//    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
//        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
//        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
//        urlComponents.queryItems = [URLQueryItem(name: "api_version", value: apiVersion)]
//        var request = URLRequest(url: urlComponents.url!)
//        request.httpMethod = "POST"
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//            guard let response = response as? HTTPURLResponse,
//                response.statusCode == 200,
//                let data = data,
//                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
//                completion(nil, error)
//                return
//            }
//            completion(json, nil)
//            print("nice")
//        })
//        task.resume()
//    }
    
    func createDummyUser() {
        Functions.functions().httpsCallable("createStripeCustomer").call(["full_name" : "John Doe", "email" : "johndoe420-69@gmail.com"]) { (response, error) in
                   if let error = error {
                       print(error)
                   }
                   if let response = (response?.data as? [String: Any]) {
                       let customer_id = response["customer_id"] as! String?
                       print(customer_id)
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

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
            Functions.functions().httpsCallable("getStripeEphemeralKeys").call(["api_version" : apiVersion, "customer_id" : "cus_HX9HpktQ2oKuNs"]) { (response, error) in
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
