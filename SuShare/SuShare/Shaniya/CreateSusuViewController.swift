//
//  CreateSusuViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 5/23/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreateSusuViewController: UIViewController {
    
    
    // whichever one that is not done the label will turn red... the labels are below
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    
    
    // the actual items
    @IBOutlet weak var SusuImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var potAmount: UITextField!
    @IBOutlet weak var participaintsSlider: UISlider!
    @IBOutlet weak var participaintsStepper: UIStepper!
    
    
     private let db = DatabaseService()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        
        
        
    }
    
    // helper functions
    private func configureController(){
        // the delegates and the data source
    }
    
    
    
    private func addSusu(){
        
        // call the datasource function here to add this susu
        print("the function is working...")
        
    guard let susuTitle = titleTextField.text , !susuTitle.isEmpty,
            let susuDes = descriptionTextView.text, !susuDes.isEmpty,
        let AmountofPot = potAmount.text, !AmountofPot.isEmpty
       // let participants = participaintsSlider.value ,
        
             
            else {
                print("error ")
                return
        }
        
        // for right now if they dont have a user name then they cannot create a post
        guard let displayName =
            Auth.auth().currentUser?.displayName else {
                       showAlert(title: "Incomplete Profile", message: "Please complete your profile")
                       return
                   }
        
        let num = Double(AmountofPot)
        
        db.createASusu(susuTitle: susuTitle, description: susuDes, potAmount: num!, numOfParticipants: 0, paymentSchedule: "updateThisShaniya", displayName: displayName) { (result) in
            switch result {
            case .failure(let error):
                print("it didn't work, currently inside of the create controller\(error.localizedDescription)")
            case .success(let docId) :
                print("it was successfully added\(docId)")
                // need to do storage services for to add image by docId. 
            }
        }
        
        
    }
    
    
    // the slider action
    
    
    // the stepper action
    
    
    
    
    
    
    // Actions
    @IBAction func addSusu(_ sender: UIButton) {
        print("button has been pressed")
        
        addSusu()
    }
    
    
    
}// end of class



//extensions...
