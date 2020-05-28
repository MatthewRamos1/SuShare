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



struct SuShare{
    
   // let securityState: Security
    let susuTitle: String
    let susuImage: UIImage
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
