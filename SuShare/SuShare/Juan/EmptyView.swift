//
//  EmptyView.swift
//  SuShare
//
//  Created by Juan Ceballos on 5/28/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class EmptyView: UIView {
  
  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.numberOfLines = 1
    label.textAlignment = .center
    label.text = "Empty State"
    return label
  }()
  
  public lazy var messageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .subheadline)
    label.numberOfLines = 4
    label.textAlignment = .center
    label.text = "There are no items currently in your collection."
    return label
  }()
  
  init(title: String, message: String) {
    super.init(frame: UIScreen.main.bounds)
    titleLabel.text = title
    messageLabel.text = message
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    setupMessageLabelConstraints()
    setupTitleLabelConstraints()
  }
  
  private func setupMessageLabelConstraints() {
    addSubview(messageLabel)
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
  }
  
  private func setupTitleLabelConstraints() {
    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
    
  }
}
