//
//  Comment.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
 let commentDate: Timestamp
 let commentedBy: String
 let susuId: String
 let susuName: String
 let creatorName: String
 let comment: String
}
extension Comment {
 // we use this initializer when converting a snapshot firebase data object to our Swift model (Comment)
 init(_ dictionary: [String: Any]) {
  self.commentDate = dictionary["commentDate"] as? Timestamp ?? Timestamp(date: Date())
  self.commentedBy = dictionary["commentedBy"] as? String ?? "no commentedBy name"
  self.susuId = dictionary["itemId"] as? String ?? "no susuId"
  self.susuName = dictionary["itemName"] as? String ?? "no susuName"
  self.creatorName = dictionary["sellerName"] as? String ?? "no creatorName"
  self.comment = dictionary["comment"] as? String ?? "no comment."
 }
}
