//
//  PaymentViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 6/16/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

class PaymentViewController: UIViewController {
    
    
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var paymentTableView: UITableView!
    
    private var paymentContext = STPPaymentContext()
    public var suShare: SuShare?
    private var cardPaymentView = CardPaymentView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkout"
        subscribeButton.layer.cornerRadius = 8
        subscribeButton.layer.shadowColor = UIColor.black.cgColor
        subscribeButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        subscribeButton.layer.shadowRadius = 7
        subscribeButton.layer.shadowOpacity = 0.4
        paymentTableView.dataSource = self
        paymentTableView.delegate = self
        let client = MyAPIClient.sharedClient
        let customerContext = STPCustomerContext(keyProvider: client)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext.paymentAmount = 50
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        paymentContext.addCardViewControllerFooterView = cardPaymentView
        
    }
   
    @IBAction func subscribeButtonPressed(_ sender: UIButton) {
        paymentContext.requestPayment()
    }
}

extension PaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "suShareCell", for: indexPath)
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath)
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subscribeCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            paymentContext.pushPaymentOptionsViewController()
        }
    }
    
    
}

extension PaymentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 162
        case 1:
            return 110
        case 2:
            return 400
        default:
            return 1
        }
    }
}

extension PaymentViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
       
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
        return
    }

    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        let tempData: [String: Any] = ["amount": paymentContext.paymentAmount]
        var clientSecret = ""
        Functions.functions().httpsCallable("createChargeFunction").call(tempData) {
        (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let result = result {
                clientSecret = result.data as! String
            }
        }
        guard let myCard = paymentResult.paymentMethod?.card else {
            print("whoops1")
            return
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .error:
            showAlert(title: "Error", message: error?.localizedDescription ?? "")
        case .success:
            showAlert(title: "Success!", message: "Your first payment has been processed.")
        default:
            return
    }
     
    
    
}
}

extension PaymentViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
