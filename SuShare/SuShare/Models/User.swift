//
//  User.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let email: String
    let userId: String
    let profilePhoto: String
    
}

extension User {
    init(_ dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? "No username"
        self.email = dictionary["email"] as? String ?? "No Email"
        self.userId = dictionary["userId"] as? String ?? "No user id"
        self.profilePhoto = dictionary["photoURL"] as? String ?? "No profile Photo"
    }
}
