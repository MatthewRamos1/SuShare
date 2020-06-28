//
//  NewUserViewController.swift
//  SuShare
//
//  Created by Jaheed Haynes on 6/27/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseAuth

class NewUserViewController: UIViewController {
    
    
    
    // Shaniya
    /*
     these are fake iboutlets so I can code without errors
     */
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
//_______________________________________

    private let apiClient = MyAPIClient.sharedClient
    
    private let dataBase = DatabaseService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    // MARK: Call this function inside the button for where they click done
    private func retieveUserEnteredData(){
        guard let first = firstNameTextField.text, !first.isEmpty,
            let last  = lastNameTextField.text, !last.isEmpty else {
                showAlert(title: "missing fields", message: "please make sure all the fields are filled in")
                return
        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        print(user)
        let fullName = "\(first) \(last) "
        
        apiClient.createDummyUser(fullName: fullName) { (result) in
            switch result{
            case .failure(let error):
                print("the error is: \(error.localizedDescription)")
            case.success(let stripeCustomerID):
                self.updateUserDataBaseInfo(fullName: fullName, stripeCustomerId: stripeCustomerID)
            }
        }
        

    }
    
    
    private func updateUserDataBaseInfo(fullName: String, stripeCustomerId: String) {
        
        dataBase.updateFireBaseUserWithStripeStuff(fullName: fullName, stripeCustomerId: stripeCustomerId) { (result) in
            switch result {
            case .failure(let error):
                print("error is: \(error.localizedDescription)")
            case .success(let itWork):
                print(itWork)
                // dismiss to the main storyboard
                // MARK: needs to navigate to the main storyboard
                
            }
        }
    }
    
    private func requestChangesToDatabase() {
        // do I need this 
    }


}
