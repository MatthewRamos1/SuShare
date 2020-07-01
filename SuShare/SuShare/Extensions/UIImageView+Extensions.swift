//
//  UIImageView+Extensions.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/30/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}


