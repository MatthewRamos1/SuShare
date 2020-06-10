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

enum allCategories: String, CaseIterable {
    
    case categories = "shows category list"
    case selectedCategories = "shows users selected categories"
    
}

class CreateSusuViewController: UIViewController {
    // whichever one that is not done the label will turn red... the labels are below
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var numberOfParticipaintLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    
    //  @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tableviewheight: NSLayoutConstraint!
    // the actual items
    
    @IBOutlet weak var SusuImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var potAmount: UITextField!
    @IBOutlet weak var categoryOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sliderForParticipaints: UISlider!
    @IBOutlet weak var stepperForparticipaints: UIStepper!
    
    private let db = DatabaseService()
    private let ss = StorageService()
    
    // properties that will be determined based on what the user types
    // the default number is 5
    private var amountOfParticipants: Int?
    private var schedule: String?
    private var categoryList = [Category].self
    //private var currentTag = 0
    
    // I will add the categories they select here
    private var selectedCategories = [Category]() // when passing value inside of sushare func it should be the raw values
    // will it change when they click it.
    
    //true or false to show category list
    private var showingAllCategories: Bool?
    
    // allows for the image to be selected
    private lazy var imagePickerController: UIImagePickerController = {
        let picker =  UIImagePickerController()
        picker.delegate = self // need to conform to UIImagePickerController and UINavigationControllerDelegate
        return picker
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        // tells the gesture what is should do when the action happens
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
    }()
    
    private var selectedImage: UIImage? {
        didSet{
            SusuImage.image = selectedImage
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    // MARK: helper functions
        // configure all the elements
    private func configureController(){
        // image picker configuration
        showingAllCategories = false // should show users categories, which at this point should be empty
        SusuImage.isUserInteractionEnabled = true
        SusuImage.addGestureRecognizer(longPressGesture)
        // tableView configuration
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableviewheight.constant = 0
        
        // Stepper configuration
        stepperForparticipaints.value = 4.0
        stepperForparticipaints.minimumValue = 2.0
        stepperForparticipaints.maximumValue = 10.0
        stepperForparticipaints.stepValue = 1
        
        numberLabel.text = "\(stepperForparticipaints.value)"
        
        // Slider Configuration
        sliderForParticipaints.minimumValue = 2.0
        sliderForParticipaints.maximumValue = 10.0
        sliderForParticipaints.value = 4.0
    }
    
    // what parts of the camera is avaiable based on device
    @objc private func showPhotoOptions() {
        let alertController = UIAlertController(title: "Choose photo Option", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        
        let photoLibrary = UIAlertAction(title: "photoLibrary", style: .default) {
            actionAlert in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            // if there is no camera avaiable then the camera option is not avaialble either
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction func WhenClickedDropDownButton(_ sender: UIButton) {
        // toggle to see more categories
        if  showingAllCategories! { // when it is false it should toggle and change it to true
            
//            if tableView.isHidden  {
            animate(toogle: false) // show tableview
//            } else {
//                animate(toogle: false)
//            }
        } else {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                a
//                //                func viewWillLayoutSubviews() {
//                //                      super.updateViewConstraints()
//                //                      self.tableviewheight?.constant = self.tableView.contentSize.height
//                //                  }
//
//            }
            animate(toogle: true) // hide table view
        }
    }
    
    
    
    private func animate(toogle: Bool) {
        // the table view should only be hidden when first creating a suShare otherwise it should either show all the categories or only the categories the user selected.
        
        if toogle { // when they click the button one time
            UIView.animate(withDuration: 0.5) {
                self.tableView.isHidden = false // showing collection view
                self.showingAllCategories = true
               self.tableviewheight.constant = 200 // need this
            }
        } else { // when they click the button a second time, it should show the users selected categories
            UIView.animate(withDuration: 0.5) {
             //   self.tableView.isHidden = true // hide the collect
                self.showingAllCategories = false // only the users categories
                //self.tableviewheight.constant = 0
            }
        }
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
    
// should I do a function to convert the added string values into their corresponding categories
     
    
    private func addSusu(){
        // call the datasource function here to add this susu
        print("the function is working...")
        guard let susuTitle = titleTextField.text , !susuTitle.isEmpty,
            let susuDes = descriptionTextView.text, !susuDes.isEmpty,
            let AmountofPot = potAmount.text, !AmountofPot.isEmpty,
            let num = Double(AmountofPot),
            let participants = amountOfParticipants,
            let paymentSchedule = schedule,
            let selectedImage = selectedImage else {
                //TODO
                 showAlert(title: "Missing Fields", message: "All fields are required, along with a photo")
               // print("error ")
                return
                
        }
        // for right now if they dont have a user name then they cannot create a post
//                guard let displayName =
//                    Auth.auth().currentUser?.displayName else {
//                               showAlert(title: "Incomplete Profile", message: "Please complete your profile")
//                               return
//                           }
        
        let user = Auth.auth().currentUser
        // there is a default amount of participants.
        //        let participants = Int(amountOfParticipants)
        
        let type = Security.privateState
        
        
//        for string in selectedCategories {
//            if Category.contains(string) {
//
//            }
           
        
        
        // categories can be empty or left nil so that is okay.
        let resizeImage = UIImage.resizeImage(originalImage: selectedImage, rect: SusuImage.bounds)
    
    /*
        db.createASusu(sushare: SuShare(securityState: type, susuTitle: susuTitle, susuImage: resizeImage, description: description, potAmount: num, numOfParticipants: amountOfParticipants!, paymentSchedule: paymentSchedule, userId: "nil", category: [Category(rawValue: selectedCategories.first ?? 0)!
            ], createdDate: "nil", suShareId: "nil", favId: "nil"), completion:
            //susuTitle: susuTitle, description: susuDes, potAmount: num, numOfParticipants: participants, paymentSchedule: paymentSchedule, category: selectedCategories
            //, displayName: displayName
         { (result) in
            switch result {
            case .failure(let error):
                print("it didn't work, currently inside of the create controller\(error.localizedDescription)")
            case .success(let docId) :
                print("it was successfully added\(docId)")
                // need to do storage services for to add image by docId.
                self.uploadPhoto(photo: resizeImage, documentId: docId)
                
            }
        })
 */
        
    }
    
    private func uploadPhoto(photo: UIImage, documentId: String){
        // because we set the parameters to nil when the function is called again it is  not necessary to use the parameter, like below we only want the itemID because that is the only thing avaliable in this controller.. we dont have access to userID here. .
        ss.uploadPhoto(userId: "k", sushareId: documentId, image: photo) { (result) in
            switch result {
            case .failure(let error):
                self.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
            case .success(let url):
                // when the item is CREATED we do not have access to the url yet
                self.updateItemURL(url, documentId: documentId)
            }
        }
        
        
    }
    
    
    private func updateItemURL(_ url: URL, documentId: String){
        // update an exisiting doc on firebase
        Firestore.firestore().collection(DatabaseService.suShareCollection).document(documentId).updateData(["imageURL": url.absoluteString]) { [weak self]
            // firebase only accepts a string
            //
            (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "failed to update item", message: "\(error.localizedDescription)")
                }
            } else {
                // everything went okay
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                    //TODO: need to add  the closing circle animation
                    
                }
                print("all went well with the update")
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

extension CreateSusuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showingAllCategories! == false {
            return selectedCategories.count // when it is false
        } else {
            return 6 // category list should always be 6 when it is true
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        //let item = tableView[indexPath.row]
        if showingAllCategories! == false{ // if it is false then im showing based on users categories
            cell.textLabel?.text = "\(selectedCategories[indexPath.row])"
            return cell
        } else {
            // when it should show the category list
            
            let section = Category.allCases[indexPath.section]
                   switch section {
                       
                   case .technology:
                       cell.textLabel?.text = "technology"
                       cell.tag = 0
                   case .payments:
                       cell.textLabel?.text = "payments"
                       cell.tag = 1
                   case .travel:
                       cell.textLabel?.text = "travel"
                       cell.tag = 2
                   case .furniture:
                       cell.textLabel?.text = "furniture"
                       cell.tag = 3
                   case .renovations:
                       cell.textLabel?.text = "renovations"
                       cell.tag = 4
                   case .miscellaneous:
                       cell.textLabel?.text = "miscellaneous"
                       cell.tag = 5
                   
                   }
                  
              return cell
//            cell.textLabel?.text = selectedCategories[indexPath.row]
//            tableviewheight.constant = tableView.contentSize.height //+ constantValue //use the value of constant as required.
        }
//        cell.tag = currentTag
//        currentTag += 1
        
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return Category.allCases.count // what does this do?
    }
    
    
}

extension CreateSusuViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // need way to guard against two items getting added.
        // how would I get it if multiple things are seleted
//        guard let selected = tableView.cellForRow(at: indexPath)?.tag else {
//            return
//        }
        
        // inside of the empty array append the category with the raw value of whatever it is
        
        selectedCategories.append(Category(rawValue: indexPath.row)!)
        print("this is the one printed: \(Category(rawValue: indexPath.row)!)")
        print("the is only the index path: \(indexPath.row)")
        
        // they still need to be able to see the other ones
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
        
    }
}

extension CreateSusuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldnt attain original image")
        }
        selectedImage = image
        // want it to dismiss once its finished
        dismiss(animated: true)
    }
}
