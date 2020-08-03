//
//  PaymentCell.swift
//  SuShare
//
//  Created by Matthew Ramos on 6/30/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class SubscribeCell: UITableViewCell {

    @IBOutlet weak var paymentFreqLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    
    func configureCell(suShare: SuShare) {
        paymentFreqLabel.text = suShare.paymentSchedule + ":"
        let paymentTotal = suShare.potAmount / Double(suShare.numOfParticipants)
        let doubleStr = String(format: "%.2f", paymentTotal)
        totalLabel.text = "$\(doubleStr)"
    }
}
