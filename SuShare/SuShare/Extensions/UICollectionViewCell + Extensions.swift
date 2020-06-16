//
//  UICollectionViewCell + Extensions.swift
//  SuShare
//
//  Created by Matthew Ramos on 6/16/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    public func shadowConfig() {
        layer.borderColor = UIColor.systemGray6.cgColor
        layer.cornerRadius = 5.0
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
}
