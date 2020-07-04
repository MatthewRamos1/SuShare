//
//  PendingNotification.swift
//  SuShare
//
//  Created by Juan Ceballos on 7/4/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification   {
    public func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> ())   {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print("There are \(requests.count) pending requests.")
            completion(requests)
        }
    }
}
