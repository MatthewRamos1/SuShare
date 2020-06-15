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
    
    private var databaseService = DatabaseService()
    
    private var listener: ListenerRegistration?
    
    private var originalValueForConstraint: CGFloat = 0
    
    private var sushare: SuShare
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    private var comments = [Comment]() {
        didSet { 
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    init?(coder: NSCoder, sushare: SuShare) {
        self.sushare = sushare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerKeyboardNotifications()
        
        listener = Firestore.firestore().collection(DatabaseService.suShareCollection).document(sushare.suShareId).collection(DatabaseService.commentCollection).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error, Please try again", message: error.localizedDescription)
                }
                
            }else if let snapshot = snapshot{
                // create comments using dictionary initializer from the Comment model
                let comments = snapshot.documents.map { Comment($0.data()) }
                // sort by date
                self.comments = comments.sorted { $0.commentDate.dateValue() > $1.commentDate.dateValue() }
            }
        })
    }
    
    
    @IBAction func postCommentPressed(_ sender: UIButton) {
        dismissKeyboard()
        
        // getting comment ready to post to firebase
        guard let commentText = commentTextField.text,
            !commentText.isEmpty else {
                showAlert(title: "Missing Fields", message: "A comment is required.")
                return
        }
        postComment(comment: commentText)

    }
    
    
    private func postComment(comment: String){
        databaseService.postComment(sushare: sushare, comment: comment) { [weak self] (result) in
            switch result{
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Try again", message: error.localizedDescription)
                }
            case.success:
                DispatchQueue.main.async {
                   print("comment posted")
                }
            }
        }
    }
    
    //MARK: REGISTER/UN-REGISTER FOR KEYBOARD NOTIFICATIONS
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    
    //MARK: KEYBOARD WILL SHOW METHOD
    @objc private func keyboardWillShow(_ notification: Notification) {
        print(notification.userInfo ?? "missing userInfo") // info keys from the userInfo
        guard let keyboardFrame = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect else {
            return
        }
        // adjust the container bottom constraint
        containerViewBottomConstraint.constant = -(keyboardFrame.height - view.safeAreaInsets.bottom)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        dismissKeyboard()
    }
    
    @objc internal override func dismissKeyboard() {
        containerViewBottomConstraint.constant = originalValueForConstraint
        commentTextField.resignFirstResponder()
    }
    
}

//--------------------------------------------------------
// MARK: EXTENSIONS

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        let comment = comments[indexPath.row]
        let dateString = comment.commentDate.dateValue().dateString()
        cell.textLabel?.text = comment.comment
        cell.detailTextLabel?.text = "@" + comment.commentedBy + " " + dateString
        return cell
    }
    
    
}

extension CommentsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
