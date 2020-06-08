//
//  UICollectionViewCell + Extensions.swift
//  SuShare
//
//  Created by Jaheed Haynes on 5/29/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
public func shadowDecorate() {
    let radius: CGFloat = 1
    contentView.layer.cornerRadius = radius
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.masksToBounds = true

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 1.0)
    layer.shadowRadius = 2.0
    layer.shadowOpacity = 0.1
    layer.masksToBounds = false
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    layer.cornerRadius = radius
}
}
