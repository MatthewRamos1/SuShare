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
}



struct SuShare {
    
    // let securityState: Security
    let susuTitle: String
    let susuImage: UIImage?
    let description: String
    let potAmount: Double
    
    let numOfParticipants: Int
    
    let paymentSchedule: String
    
    let userId: String
    
    // let category: Category
    
    let createdDate: String
    
    let iD: String
    
    
    // after creation
    let favId: String
    
    
}

extension SuShare {
    init(_ dictionary: [String: Any]) {
        self.susuTitle = dictionary["susuTitle"] as? String ?? "No Title"
        self.susuImage = nil
        self.description = dictionary["description"] as? String ?? "No Description"
        self.potAmount = dictionary["potAmount"] as? Double ?? 0.0
        self.numOfParticipants = dictionary["numOfParticipants"] as? Int ?? 0
        self.paymentSchedule = dictionary["paymentSchedule"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? ""
        self.createdDate = dictionary["createdDate"] as? String ?? ""
        self.iD = dictionary["iD"] as? String ?? ""
        self.favId = dictionary["favId"] as? String ?? ""
    }
}
