//
//  Update.swift
//  SuShare
//
//  Created by Juan Ceballos on 7/3/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import Firebase

struct Update   {
    let userId: String
    let createdAt: Timestamp
    let userJoined: String
    let susuTitle: String
    let userJoinedPhoto: String
}

extension Update {
    init(_ dictionary: [String: Any]) {
        self.userId = dictionary["userId"] as? String ?? "No user id"
        self.createdAt = dictionary["createdAt"] as? Timestamp ?? Timestamp(date: Date())
        self.userJoined = dictionary["userJoined"] as? String ?? "No user joined"
        self.susuTitle = dictionary["susuTitle"] as? String ?? "No title"
        self.userJoinedPhoto = dictionary["userJoinedPhoto"] as? String ?? "no photo"
    }
}
