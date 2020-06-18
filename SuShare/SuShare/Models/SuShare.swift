//
//  Susu.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
enum Security: String, CaseIterable{
    
    case privateState = "privateState"
    case publicState =  "publicState"
    
}

enum Category: Int, CaseIterable {
    case technology = 0
    case payments = 1
    case travel = 2
    case furniture = 3
    case renovations = 4
    case miscellaneous = 5
    
    static let categoryNames = [
        technology : "technology",
        payments : "payments",
        travel : "travel",
        furniture : "furniture",
        renovations : "renovations",
        miscellaneous : "miscellaneous"
    ]
    
       func categoryName() -> String {
           if let categoryName = Category.categoryNames[self] {
               return categoryName
           } else {
               return "Minion inside of category enum"
           }
       }
    
    static func getCategoriesRawValue() -> [Int] {
        Category.allCases.map { $0.rawValue }
      }
    
        
}


struct SuShare{
  
    let securityState: String
    let susuTitle: String
    let susuImage: UIImage?
    let suShareDescription: String
    let potAmount: Double
    let numOfParticipants: Int
    let paymentSchedule: String
    let userId: String
    let category: [Int]
    let createdDate: String
    let suShareId: String
    let usersInTheSuShare: [String]
    
    
    // after creation
    let favId: String?
}

extension SuShare {
    init(_ dictionary: [String: Any]) {
        self.securityState = dictionary["securityState"] as? String ?? "No securityState"
        self.susuTitle = dictionary["susuTitle"] as? String ?? "No Title"
        self.susuImage = nil
        self.suShareDescription = dictionary["suShareDescription"] as? String ?? "No Description"
        self.potAmount = dictionary["potAmount"] as? Double ?? 0.0
        self.numOfParticipants = dictionary["numOfParticipants"] as? Int ?? 0
        self.paymentSchedule = dictionary["paymentSchedule"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? ""
        self.category = dictionary["category"] as? [Int] ?? []
        self.createdDate = dictionary["createdDate"] as? String ?? ""
        self.suShareId = dictionary["suShareId"] as? String ?? ""
        self.usersInTheSuShare = dictionary["users"] as? [String] ?? [""]
        self.favId = dictionary["favId"] as? String ?? ""
    }
}
