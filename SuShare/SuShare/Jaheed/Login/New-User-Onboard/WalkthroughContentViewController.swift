//
//  WalkthroughContentViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/28/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
       
       @IBOutlet var headingLabel: UILabel! {
           didSet {
               headingLabel.numberOfLines = 0
           }
       }
       
       @IBOutlet var subHeadingLabel: UILabel! {
           didSet {
               subHeadingLabel.numberOfLines = 0
           }
       }
       
       @IBOutlet var contentImageView: UIImageView!
       
       var index = 0
       var heading = ""
       var subHeading = ""
       var imageFile = ""

       override func viewDidLoad() {
           super.viewDidLoad()
           
           headingLabel.text = heading
           subHeadingLabel.text = subHeading
           contentImageView.image = UIImage(named: imageFile)
       }
       

       /*
       // MARK: - Navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       }
       */
}
