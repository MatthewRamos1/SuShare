//
//  User.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation

struct User {
    let displayName: String
    let email: String
    let userId: String
}

extension User {
    init(_ dictionary: [String: Any]) {
        self.displayName = dictionary["displayName"] as? String ?? "No Display Name"
        self.email = dictionary["email"] as? String ?? "No Email"
        self.userId = dictionary["userId"] as? String ?? "No user id"
    }
}
