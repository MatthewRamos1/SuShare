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
        }
    }
    
    
    private let theme = STPTheme.default()

    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Yoooooooooooooo"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = theme.smallFont
        label.textColor = theme.secondaryForegroundColor

        return label
    }()
    
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
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }

  

}
