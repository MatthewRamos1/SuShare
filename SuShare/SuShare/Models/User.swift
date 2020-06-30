//
//  User.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Foundation

class singleUser: NSObject {
    static let currentUserrr = singleUser()

      var username: User?
    
    
    
}

struct User {
    let username: String
    let email: String
    let userId: String
    let profilePhoto: String
    let fullName: String
    let stripeCustomerId: String
}

extension User {
    init(_ dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? "No username"
        self.email = dictionary["email"] as? String ?? "No Email"
        self.userId = dictionary["userId"] as? String ?? "No user id"
        self.profilePhoto = dictionary["photoURL"] as? String ?? "No profile Photo"
        self.fullName = dictionary["fullName"] as? String ?? "No full name avaiable"
        self.stripeCustomerId = dictionary["stripeCustomerId"] as? String ?? "no Stripe Id has been made"
    }
}
