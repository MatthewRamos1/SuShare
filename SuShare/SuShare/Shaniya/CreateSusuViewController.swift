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
    @IBOutlet weak var numberOfParticipaintLabel: UILabel!
    
    
    //  @IBOutlet weak var numberLabel: UILabel!
    
    // the actual items
    @IBOutlet weak var SusuImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var potAmount: UITextField!
    @IBOutlet weak var sliderForParticipaints: UISlider!
    @IBOutlet weak var stepperForparticipaints: UIStepper!
    
     private let db = DatabaseService()
    
    
    // properties that will be determined based on what the user types
    // the default number is 5
    private var amountOfParticipants: Int?
    private var schedule: String?
    
    // will it change when they click it.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureController()
       configureSlider()
        
    }
   
    // helper functions
    private func configureController(){
        // the delegates and the data source
      

               stepperForparticipaints.value = 4.0
               stepperForparticipaints.minimumValue = 2.0
               stepperForparticipaints.maximumValue = 10.0
               stepperForparticipaints.stepValue = 1

        numberLabel.text = "\(stepperForparticipaints.value)"
 
    }
    
    func configureSlider(){
        sliderForParticipaints.minimumValue = 2.0
                      sliderForParticipaints.maximumValue = 10.0
                      sliderForParticipaints.value = 4.0
    }
    
   
    
    @IBAction func participantSlider(_ sender: UISlider) {
        // change the number label
        // assign the number label.
        
        let amount = sender.value

        sliderForParticipaints?.value = amount
        stepperForparticipaints?.value = Double(amount)
        amountOfParticipants = Int(amount)
       // numberLabel.text = "\(amount)"
               // sampleSizeLabel.text = "The size is now\(sender.value)"
         
        numberLabel.text = "\(amount)"
    }
    
    
    @IBAction func participantStepper(_ sender: UIStepper) {
        
                 let amount = sender.value
        numberLabel.text = "\(amount)"

              //sampleSizeLabel.text = "The size is now\(sender.value)"
        sliderForParticipaints?.value = Float(amount)
              stepperForparticipaints?.value = amount
        amountOfParticipants = Int(amount) // need to change it
         
    }
    
    
    @IBAction func paymentSchedule(_ sender: UIButton) {
        
        switch sender.restorationIdentifier {
        case "weekly":
            schedule = sender.restorationIdentifier
        case "bi-weekly":
            schedule = sender.restorationIdentifier
        case "monthly":
            schedule = sender.restorationIdentifier
        default :
            print("the alert should show that they didnt pick one. ")
        }
        
    }
    
    
    private func addSusu(){
        // call the datasource function here to add this susu
        print("the function is working...")
    guard let susuTitle = titleTextField.text , !susuTitle.isEmpty,
            let susuDes = descriptionTextView.text, !susuDes.isEmpty,
        let AmountofPot = potAmount.text, !AmountofPot.isEmpty,
          let num = Double(AmountofPot),
           let participants = amountOfParticipants,
        let paymentSchedule = schedule
             else {
                print("error ")
                return
        }
        // for right now if they dont have a user name then they cannot create a post
//        guard let displayName =
//            Auth.auth().currentUser?.displayName else {
//                       showAlert(title: "Incomplete Profile", message: "Please complete your profile")
//                       return
//                   }
        
        // there is a default amount of participants.
//        let participants = Int(amountOfParticipants)
        
        db.createASusu(susuTitle: susuTitle, description: susuDes, potAmount: num, numOfParticipants: participants, paymentSchedule: paymentSchedule
            //, displayName: displayName
        ) { (result) in
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
        // dismiss controller
        print("function done")
    }
    
    
    
}// end of class

//extensions...

