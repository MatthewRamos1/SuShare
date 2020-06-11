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
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var PrivacySettingsLabel: UILabel!
    
    @IBOutlet weak var numberOfParticipaintLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    
    //MARK: needed constraints
    @IBOutlet weak var tableviewheight: NSLayoutConstraint!
    @IBOutlet weak var bottomContraintForTitle: NSLayoutConstraint!
    @IBOutlet weak var bottomContraintForDescription: NSLayoutConstraint!
    @IBOutlet weak var bottomContraintForPotAmount: NSLayoutConstraint!
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
    
    private var schedule: String?
    private var categoryList = [Category].self
    //private var currentTag = 0
    
    // I will add the categories they select here
    private var selectedCategories = [Category]() // when passing value inside of sushare func it should be the raw values
    // will it change when they click it.
    
    // privacy value
    
    private var isItPrivate : Security?

    private var amountOfParticipants: Int?
    
    
    //true or false to show category list
    private var showingAllCategories: Bool? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // variable for the image
    private var selectedImage: UIImage? {
         didSet{
             SusuImage.image = selectedImage
         }
     }
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // registerKeyboardNotifications()
        configureController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
      //  unregisterKeyboardNotifcation()
    }
    
    // MARK: helper functions
        // configure all the elements
    private func configureController(){
        
        
        // image picker configuration
        showingAllCategories = false // should show users categories, which at this point should be empty
        
        // for the image
        SusuImage.isUserInteractionEnabled = true
        SusuImage.addGestureRecognizer(longPressGesture)
        
        // for the textfields
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        potAmount.delegate = self
        
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
        sliderForParticipaints.isContinuous = false
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
        if  showingAllCategories! {
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
    
    
    
    @IBAction func PrivacySwitch(_ sender: UISwitch) {
        
        if sender.isOn { // if the switch is on then so is the privacy setting
            
            isItPrivate = Security.privateState
            
               PrivacySettingsLabel.text = "Privacy Setting: ON"
        } else { // if the switch is off then
            isItPrivate = Security.publicState
            PrivacySettingsLabel.text = "Privacy Setting: OFF"

        }
     
           
        
    }
    
    
    @IBAction func participantSlider(_ sender: UISlider) {
        // change the number label
        // assign the number label.
        
        let amount = sender.value
        
        sliderForParticipaints?.value = amount
        stepperForparticipaints?.value = Double(amount)
        
        
        amountOfParticipants = Int(amount)
                numberOfParticipaintLabel.text = String(format: "%0.f", Int(amount))
        // numberLabel.text = "\(amount)"
        // sampleSizeLabel.text = "The size is now\(sender.value)"
        
       // sender.setValue(sender.value.rounded(.down), animated: true)
          // print(sender.value)
         //String(format: "%0.f", sliderControl.value)
      //  numberLabel.text = String(format: "%0.f", sliderForParticipaints.value)
    }
    
    
    @IBAction func participantStepper(_ sender: UIStepper) {
        
        let amount = sender.value
     //   numberLabel.text = "\(amountOfParticipants))"
        
        //sampleSizeLabel.text = "The size is now\(sender.value)"
        sliderForParticipaints?.value = Float(amount)
        stepperForparticipaints?.value = amount
        amountOfParticipants = Int(amount) // need to change it
         numberOfParticipaintLabel.text = String(format: "%0.f", Int(amount))
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
    
    // MARK: keyboard handling
//    private func registerKeyboardNotifications(){
//          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//      }
//
//      private func unregisterKeyboardNotifcation(){
//          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//      }
//
//      @objc
//      private func keyboardWillShow(_ notification: Notification){
//          // get info through a dictionary...
//          // when the keyboard is on screen we wanna adjust the constraints
//        //  print(notification.userInfo ?? "")// all the keys from the user info...
//          // print this and then look in the console log and you should see UIKeyboardBoundsUserInfoKey
//          guard let keyboardFrame = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect
//              else {
//                  // casting it as a CGRect...
//              return
//          }
//
//        if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardFrame.height
//            }
//
//        // need the bottom constraint for all three
//
//        //bottomContraintForTitle
//
//   //     bottomContraintForTitle.constant = (keyboardFrame.height - view.safeAreaInsets.bottom)
////             bottomContraintForDescription.constant = (keyboardFrame.height - view.safeAreaInsets.bottom)
//       // bottomContraintForPotAmount.constant = (keyboardFrame.height - view.safeAreaInsets.bottom)
//          // adjust container bottom constraint
//        //  containerBottomConstraint.constant = (keyboardFrame.height - view.safeAreaInsets.bottom)
//          //want the text field to key the height that we input..
//      }
//
//      @objc
//      private func keyboardWillHide(_ notification: Notification){
//
//          dismissKeyboard()
//      }
//
//      @objc private func dismissKeyboard() {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//       //  bottomContraintForPotAmount.constant = originalValueForConstraint
//         // commentTextField.resignFirstResponder()
//        titleTextField.resignFirstResponder()
//        descriptionTextView.resignFirstResponder()
//        potAmount.resignFirstResponder()
//      }
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
            let selectedImage = selectedImage,
            let securitySetting = isItPrivate
                    else {
                //TODO
                 showAlert(title: "Missing Fields", message: "All fields are required, along with a photo")
               // print("error ")
                return
                
        }
        
        // categories can be empty or left nil so that is okay.
        let resizeImage = UIImage.resizeImage(originalImage: selectedImage, rect: SusuImage.bounds)

        // TODO: We are currently passing a UIImage, but in the databse function it is not passing the image.. is that okay.
        db.createASusu(sushare: SuShare(securityState: securitySetting, susuTitle: susuTitle, susuImage: resizeImage, description: description, potAmount: num, numOfParticipants: participants, paymentSchedule: paymentSchedule, userId: "nil", category: selectedCategories, createdDate: "nil", suShareId: "nil", favId: "nil"), completion:
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
         //dismissKeyboard()
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
            return Category.allCases.count
            //6 // category list should always be 6 when it is true
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)  as UITableViewCell
        
//        let categoryIndex = Category.allCases[indexPath.row]
//        //fromRaw(indexPath.row) {
//        cell.textLabel!.text = categoryIndex.categoryName()
//              //  cell.imageView.image = categoryIndex.minionImage()
//
//        return cell

        // filter if toogle otherwise category names
        
        //let item = tableView[indexPath.row]
        if showingAllCategories! == false{ // if it is false then im showing based on users categories
         //  let selected = selectedCategories[indexPath.row]
            
            
            
            for category in selectedCategories {
                let selected = category.categoryName()
                  cell.textLabel?.text = selected
                // filter the same array
                
              //  let newCell =  categoryList.filter(selectedCategories)

            }
          
            return cell
        } else {
            // when it should show the category list
            
            let category = Category.allCases[indexPath.row]
            
            cell.textLabel?.text = category.categoryName()
                 
              return cell
//            cell.textLabel?.text = selectedCategories[indexPath.row]
//            tableviewheight.constant = tableView.contentSize.height //+ constantValue //use the value of constant as required.
        }
//        cell.tag = currentTag
//        currentTag += 1
        
       
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
        
        // TODO - guard against adding multiple inside of array
        
        for item in selectedCategories {
            print("selectedCategory has ")
            print(selectedCategories.count)
        
                if selectedCategories.contains(item) {
                    print("alert that this category is being removed from the suShare")
                    selectedCategories.firstIndex(of: item)
                    print("\(item) was removed")
                    
                }
             else {
                selectedCategories.append(Category(rawValue: indexPath.row)!)
            }
            print("selectedCategory final count is ")
            print(selectedCategories.count)
            print("this is the one printed: \(Category(rawValue: indexPath.row)!)")
                   print("the is only the index path: \(indexPath.row)")
        }
        
    //    selectedCategories.append(Category(rawValue: indexPath.row)!)
       
        
        // they still need to be able to see the other ones
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
        
    }
}

// MARK: delegates for the textVIEW and the textFIELD
extension CreateSusuViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // dismissKeyboard()
        textField.resignFirstResponder()
//        titleTextField.resignFirstResponder()
//        potAmount.te
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) { // TODO: Update textView
       // dismissKeyboard()
        // TODO: need to do a touch off gesture to dismiss the keyboard
        textView.resignFirstResponder()
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
