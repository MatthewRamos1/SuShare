//
//  HeaderView.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/1/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit

public enum PersonalType {
    case backed
    case created
    case favorites
}

protocol HeaderDelegate: AnyObject {
    func selectedHeader(tag: Int)
}

class HeaderView: UICollectionReusableView  {
    
    var pt: PersonalType = .backed
    weak var delegate: HeaderDelegate?
    
    public lazy var createdButton: UIButton =   {
        let button = UIButton()
        button.setTitle("Created", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = 0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.underline()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    public lazy var favoritedButton: UIButton =   {
        let button = UIButton()
        button.setTitle("Favorites", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.removeLine()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    public lazy var backedButton: UIButton =   {
        let button = UIButton()
        button.setTitle("Backed", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.tag = 2
        button.removeLine()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag   {
        case 0:
            createdButton.underline()
            backedButton.removeLine()
            favoritedButton.removeLine()
            delegate?.selectedHeader(tag: 0)
            pt = .created
            print("i do this in view")
        case 1:
            favoritedButton.underline()
            backedButton.removeLine()
            createdButton.removeLine()
            delegate?.selectedHeader(tag: 1)
            pt = .favorites
        case 2:
            backedButton.underline()
            favoritedButton.removeLine()
            createdButton.removeLine()
            delegate?.selectedHeader(tag: 2)
            pt = .backed
        default:
            print("Button Error")
        }
    }
    
    public lazy var segmentedControl: UISegmentedControl =  {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Created", at: 0, animated: false)
        sc.insertSegment(withTitle: "Favorites", at: 1, animated: false)
        sc.insertSegment(withTitle: "Backed", at: 2, animated: false)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .clear
        sc.tintColor = .white
        sc.selectedSegmentTintColor = .white
        
        sc.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 16) ?? 16,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        
        sc.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 16) ?? 16,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .selected)
        return sc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit()   {
        setupCreatedButtonConstraints()
        setupFavoritedButtonConstraints()
        setupBackedButtonConstraints()
    }
    
    private func setupCreatedButtonConstraints() {
        addSubview(createdButton)
        createdButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(22)
        }
    }
    
    private func setupFavoritedButtonConstraints() {
        addSubview(favoritedButton)
        favoritedButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBackedButtonConstraints() {
        addSubview(backedButton)
        backedButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-22)
        }
    }
    
}
