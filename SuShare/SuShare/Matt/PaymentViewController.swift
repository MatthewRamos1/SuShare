//
//  PaymentViewController.swift
//  SuShare
//
//  Created by Matthew Ramos on 6/16/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var paymentTableView: UITableView!
    
    private var paymentContext = STPPaymentContext()
    public var suShare: SuShare?
    private var paymentView = PaymentView()
    
    
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
        client.baseURLString = "https://stripe-backend-demo309.herokuapp.com"
        let customerContext = STPCustomerContext(keyProvider: client)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext.paymentAmount = 5000
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        
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
            paymentContext.requestPayment()
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
        return
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
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        return
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        return
    }
    
    
}

class PaymentView: UIView {
    
    private lazy var paymentTable: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        return tv
    }()
    
    
    private lazy var joinSuShareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 25)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.6613236666, blue: 0.617059052, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 7
        button.layer.shadowOpacity = 0.4
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(paymentTable)
        addSubview(joinSuShareButton)
        paymentTable.translatesAutoresizingMaskIntoConstraints = false
        joinSuShareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paymentTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            paymentTable.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            paymentTable.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            paymentTable.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            joinSuShareButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
            joinSuShareButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            joinSuShareButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            joinSuShareButton.heightAnchor.constraint(equalToConstant: 50)
        ])
            
    }
}
