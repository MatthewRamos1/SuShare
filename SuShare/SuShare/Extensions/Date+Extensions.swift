//
//  Date+Extensions.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/25/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation

extension Date {
public func dateString(_ format: String = "EEEE, MMM d, h:mm a") -> String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = format
  return dateFormatter.string(from: self)
}
}
