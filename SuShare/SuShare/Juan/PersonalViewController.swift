//
//  PersonalViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {

    let personalView = PersonalView()
    
    var suShares = [Susu]()   {
        didSet  {
            personalView.personalCollectionView.reloadData()
            if suShares.isEmpty {
                personalView.personalCollectionView.backgroundView = EmptyView.init(title: "Collection Empty", message: "There are currently no saved Sushare's")
            } else {
                personalView.personalCollectionView.reloadData()
                personalView.personalCollectionView.backgroundView = nil
            }
        }
    }
    
    override func loadView() {
        view = personalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "SuShare"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.6823529412, blue: 0.631372549, alpha: 1)
        personalView.personalCollectionView.register(PersonalCell.self, forCellWithReuseIdentifier: "personalCell")
        suShares = [Susu]()
        personalView.personalCollectionView.dataSource = self
        personalView.personalCollectionView.delegate = self
    }
    
    // detail view segue

}

extension PersonalViewController: UICollectionViewDataSource    {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suShares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personalCell", for: indexPath) as? PersonalCell else {
            fatalError()
        }
        // configure cell
        cell.backgroundColor = .systemBackground
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
}

extension PersonalViewController: UICollectionViewDelegateFlowLayout    {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.84
        let itemHeight: CGFloat = maxSize.height * 0.5
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // segue
    }
}

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

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.systemGray, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func removeLine()   {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
