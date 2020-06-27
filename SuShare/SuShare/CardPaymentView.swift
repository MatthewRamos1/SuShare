//
//  CardPaymentView.swift
//  SuShare
//
//  Created by Matthew Ramos on 6/20/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Stripe

class CardPaymentView: UIView {

   var insetMargins: UIEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)

    var text: String = "" {
        didSet {
            textLabel.text = text
           // textLabel.font = UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
            textLabel.textColor = UIColor.gray
        }
    }
    
    
//     var theme = STPTheme.default() {
//        didSet {
//             textLabel.font = theme.smallFont
//             textLabel.textColor = theme.secondaryForegroundColor
//         }
//     }
    
    fileprivate let textLabel = UILabel()

//    public lazy var textLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Yoooooooooooooo"
//        label.numberOfLines = 0
//        label.textAlignment = .left
//        label.font = theme.smallFont
//        label.textColor = theme.secondaryForegroundColor
//
//        return label
//    }()

    
    convenience init(text: String) {
         self.init()
         textLabel.numberOfLines = 0
         textLabel.textAlignment = .left
        textLabel.textColor = .gray
         self.addSubview(textLabel)

         self.text = text
         textLabel.text = text

     }
    
    override func layoutSubviews() {
            textLabel.frame = self.bounds.inset(by: insetMargins)
        }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
         // Add 10 pt border on all sides
         var insetSize = size
         insetSize.width -= (insetMargins.left + insetMargins.right)
         insetSize.height -= (insetMargins.top + insetMargins.bottom)

         var newSize = textLabel.sizeThatFits(insetSize)

         newSize.width += (insetMargins.left + insetMargins.right)
         newSize.height += (insetMargins.top + insetMargins.bottom)

         return newSize
     }
    
    
    /*
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupTextLabelConstraints()
    }
    
    private func setupTextLabelConstraints() {
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }

  */

}
