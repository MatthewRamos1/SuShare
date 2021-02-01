//
//  LoadingView.swift
//  SuShare
//
//  Created by Juan Ceballos on 1/30/21.
//  Copyright © 2021 Matthew Ramos. All rights reserved.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    
    public lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Please Wait..."
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
    
    private func commonInit()   {
       setupLabelConstraints()
    }
    
    private func setupLabelConstraints() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
