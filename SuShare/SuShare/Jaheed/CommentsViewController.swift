//
//  CommentsViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 5/27/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseFirestore

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: UITextField!
    
    //private var databaseService = DatabaseServices()
    
    private var listener: ListenerRegistration?
    
    private var originalValueForConstraint: CGFloat = 0
    
    private var comments = [Comment]() {
        didSet { 
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    @IBAction func postCommentPressed(_ sender: UIButton) {
        
    }
    
   

}
