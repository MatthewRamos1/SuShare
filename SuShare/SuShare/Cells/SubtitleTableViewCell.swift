//
//  SubtitleTableViewCell.swift
//  SuShare
//
//  Created by Juan Ceballos on 6/5/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
