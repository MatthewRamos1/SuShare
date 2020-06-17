//
//  MenueViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/7/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case username
    case friends
    case search
    case settings
}

class MenuViewController: UITableViewController {
    
    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view != self
        { self.dismiss(animated: true, completion: nil) }
    }
}
