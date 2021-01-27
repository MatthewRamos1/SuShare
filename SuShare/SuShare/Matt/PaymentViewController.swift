//
//  PaymentViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 6/16/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
//import Stripe
import FirebaseFunctions
import Kingfisher

class PaymentViewController: UIViewController {
    
    
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var paymentTableView: UITableView!
    

     //private var paymentContext = STPPaymentContext()
     public var suShare: SuShare?

     private var cardPaymentView = CardPaymentView()
     //private var cardVC = STPAddCardViewController()
     private var clientSecret = ""

 //   private var cardPaymentView = CardPaymentView()


    
    
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
        //let client = MyAPIClient.sharedClient
       // let customerContext = STPCustomerContext(keyProvider: client)
        //paymentContext = STPPaymentContext(customerContext: customerContext)
        let paymentAmount = (suShare!.potAmount / Double(suShare!.numOfParticipants))
        let paymentInt = Int(paymentAmount * 100)
       // paymentContext.paymentAmount = paymentInt
       // paymentContext.delegate = self
        //paymentContext.hostViewController = self
        tabBarController?.tabBar.isHidden = true
        
        
        
//        let infoForFooter = CardPaymentView(text: """
//This card will be saved under settings as your default payment method
//    you can access your settings to change the card later
//"""
//        )
        // paymentContext.paymentOptionsViewControllerFooterView = infoForFooter
        //    let addCardFooter = CardPaymentView(text: "You can add custom footer views to the add card screen.")
        
        //paymentContext.addCardViewControllerFooterView = infoForFooter
        /*
         paymentSelectionFooter.theme = settings.theme
         paymentContext.paymentOptionsViewControllerFooterView = paymentSelectionFooter
         */
        
        // paymentContext.addCardViewControllerFooterView =  cardPaymentView
        // paymentContext.addCardViewControllerFooterView.backgroundColor = .blue
        //paymentTableView.tableFooterView?.backgroundColor = .blue
    }
    
    @IBAction func subscribeButtonPressed(_ sender: UIButton) {
        //paymentContext.requestPayment()
    }
}

extension PaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "suShareCell", for: indexPath) as? SuShareCell else {
                return UITableViewCell()
            }
            cell.configureCell(suShare: suShare!)
            return cell

        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "subscribeCell", for: indexPath) as? SubscribeCell else {
                return UITableViewCell()
            }
            cell.configureCell(suShare: suShare!)
            cell.isUserInteractionEnabled = false
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            //paymentContext.pushPaymentOptionsViewController()
        }
    }
    
    
}

extension PaymentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 162
        case 1:
            return 100
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // let paymentInfoView = CardPaymentView(text: "now will it work???!??!")
        let vw  = UIView()
        vw.backgroundColor = UIColor.clear
        let xPosition = UIScreen.main.bounds.width * 0.1
        let yPosition = UIScreen.main.bounds.height * 0.3
        let titleLabel = UILabel(frame: CGRect(x: xPosition, y: yPosition, width:350, height:150))
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .gray
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont(name: "courier", size: 12)
        titleLabel.text  = """
        Thank you for selecting this SuShare
        some things to remember: (1)The amount above is what you will be contributing to this sushare. (2)Payments are taken from your account like a subscription service. (3)Opting out of this suShare will result in delaying future enrollement in other SuShares

        Please be kind
        """
        vw.addSubview(titleLabel)
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
    
}

//extension PaymentViewController: STPPaymentContextDelegate {
//    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
//        let data: [String: Any] = ["amount": paymentContext.paymentAmount]
//        Functions.functions().httpsCallable("createChargeFunction").call(data)  {
//            (result, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else if let result = result {
//                self.clientSecret = result.data as! String
//                print(self.clientSecret)
//            }
//        }
//    }
//
//
//    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
//        let alertController = UIAlertController(
//            title: "Error",
//            message: error.localizedDescription,
//            preferredStyle: .alert
//        )
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
//            _ = self.navigationController?.popViewController(animated: true)
//        })
//        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
//            self.paymentContext.retryLoading()
//        })
//        alertController.addAction(cancel)
//        alertController.addAction(retry)
//        self.present(alertController, animated: true, completion: nil)
//        return
//    }
//
//
//    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
//
//
//        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
//        paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
//
//        // Confirm the PaymentIntent
//        STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
//            switch status {
//            case .succeeded:
//                // Your backend asynchronously fulfills the customer's order, e.g. via webhook
//                completion(.success, nil)
//            case .failed:
//                completion(.error, error) // Report error
//            case .canceled:
//                completion(.userCancellation, nil) // Customer cancelled
//            @unknown default:
//                completion(.error, nil)
//            }
//        }
//    }
//
//
//    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
//        switch status {
//        case .error:
//            showAlert(title: "Error", message: error?.localizedDescription ?? "")
//        case .success:
//            showAlert(title: "Success!", message: "Your first payment has been processed.")
//        default:
//            return
//        }
//    }
//}

//extension PaymentViewController: STPAddCardViewControllerDelegate {
//
//  func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//    navigationController?.popViewController(animated: true)
//  }
//
//  func addCardViewController(_ addCardViewController: STPAddCardViewController,
//                             didCreateToken token: STPToken,
//                             completion: @escaping STPErrorBlock) {
//    print("yesssssss")
//  }
//}
//
//extension PaymentViewController: STPPaymentOptionsViewControllerDelegate {
//    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didFailToLoadWithError error: Error) {
//        return
//    }
//
//    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
//        return
//    }
//
//    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
//        print("cool")
//    }
//
//
//}
