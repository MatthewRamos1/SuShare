//
//  UILabel+Extensions.swift
//  SuShare
//
//  Created by Juan Ceballos on 5/26/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
