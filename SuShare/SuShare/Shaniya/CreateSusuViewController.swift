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

    private lazy var slideDownGesture: UISwipeGestureRecognizer = {
      let slide =  UISwipeGestureRecognizer()
        slide.addTarget(self, action: #selector(respondToSwipeGesture))
              //UIViewController.dismissKeyboard))
                      slide.direction = .down
          slide.cancelsTouchesInView = false
         // view.addGestureRecognizer(slide)
        return slide
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // registerKeyboardNotifications()
        configureController()
        configureBarButtons()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
      //  unregisterKeyboardNotifcation()
    }
    
    // MARK: helper functions
        // configure all the elements
    private func configureController(){
       // dropDownButton.titleLabel?.text = "ljol"
        //titleLabel?.text = "select a category"
// configures the privacy state
        isItPrivate = Security.publicState

        // configures the amountof users
        amountOfParticipants = 4
        
        navigationController?.title = "Create a SuShare"
        dropDownButton.setTitle("select a category", for: .normal)
            //.titleLabel?.text = "select a category"
        hideKeyboard()
        
        // image picker configuration
        showingAllCategories = false // should show users categories, which at this point should be empty
        
        // for the image
        SusuImage.isUserInteractionEnabled = true
        SusuImage.addGestureRecognizer(longPressGesture)
        
        // gesture to dismiss keyboard when scrolling.
        view.addGestureRecognizer(slideDownGesture)
        
        // for the textfields
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        potAmount.delegate = self
        
        // tableView configuration
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.isHidden = true
       // tableView.tableFooterView = UIView()
        tableviewheight.constant = 0
        
        // Stepper configuration
        stepperForparticipaints.value = 4.0
        stepperForparticipaints.minimumValue = 2.0
        stepperForparticipaints.maximumValue = 10.0
        stepperForparticipaints.stepValue = 1
        numberLabel.text = "\(Int(stepperForparticipaints.value))"
        
        // Slider Configuration
        sliderForParticipaints.isContinuous = false
        sliderForParticipaints.minimumValue = 2.0
        sliderForParticipaints.maximumValue = 10.0
        sliderForParticipaints.value = 4.0
    }
    
    private func configureBarButtons(){
      //  let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(goBack))
       let cancelButton = UIButton(type: .close)
        cancelButton.tintColor = .green
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(goBack))
        //cancelButton
    }
    
     @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
                dismissKeyboard()
//view.endEditing(true)
    }
    
    @objc private func goBack() {
        // have a pop up and if they select ok then it dismisses otherwise it will stay on the screen
        navigationController?.popViewController(animated: true)
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
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // show alert that everything they did will be lost 
        dismiss(animated: true)
    }
    
    
    @IBAction func WhenClickedDropDownButton(_ sender: UIButton) {
        // toggle to see more categories
        if  showingAllCategories! {
            animate(toogle: false) // show tableview

        } else {
            animate(toogle: true) // hide table view
        }
    }
    
    
    
    private func animate(toogle: Bool) {
        // the table view should only be hidden when first creating a suShare otherwise it should either show all the categories or only the categories the user selected.
        
        if toogle { // when they click the button one time
            UIView.animate(withDuration: 0.5) {
                self.tableView.isHidden = false // showing collection view
                self.showingAllCategories = true
               self.tableviewheight.constant = 200
                //     self.dropDownButton.titleLabel?.text = "select a category"
                // need this
                // MARK: adjust the height of tableView based on amount cells
                self.dropDownButton.setTitle("select a category", for: .normal)
               
            }
        } else { // when they click the button a second time, it should show the users selected categories
            UIView.animate(withDuration: 0.5) {
             //   self.tableView.isHidden = true // hide the collect
                self.showingAllCategories = false // only the users categories
                //self.tableviewheight.constant = 0
                self.dropDownButton.setTitle( "You selected ...", for: .normal)
               
                self.tableviewheight.constant = self.tableView.contentSize.height
            }
        }
    
    }
    
    override func updateViewConstraints() {
                             tableviewheight.constant = tableView.contentSize.height
                             super.updateViewConstraints()
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

        
        numberLabel.text = String(format: "%0.f", amount)
    }
    
    
    @IBAction func participantStepper(_ sender: UIStepper) {
        
        let amount = sender.value
   
        sliderForParticipaints?.value = Float(amount)
        stepperForparticipaints?.value = amount
        amountOfParticipants = Int(amount) // need to change it
         numberOfParticipaintLabel.text = String(format: "%0.f", amount)
    }
    
    
    @IBAction func paymentSchedule(_ sender: UIButton) {
        // TODO: make it so that the user can only click on one button
        
        // TOGGLE the buttons for on and off
        
        switch sender.restorationIdentifier {
        case "Weekly":
            sender.backgroundColor = .systemGray
            schedule = sender.restorationIdentifier
        case "Bi-Weekly":
            sender.backgroundColor = .systemGray
            schedule = sender.restorationIdentifier
        case "Monthly":
            sender.backgroundColor = .systemGray
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
                //TODO: if possible add in a alert(custom) to show user what field is missing
                        showAlert(title: "Missing Fields", message: "All fields are required, ")
               // print("error ")
                return
        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        // categories can be empty or left nil so that is okay.
        let resizeImage = UIImage.resizeImage(originalImage: selectedImage, rect: SusuImage.bounds)

        // TODO: We are currently passing a UIImage, but in the databse function it is not passing the image.. is that okay.
        let selectedIntValue = selectedCategories.map { $0.rawValue }
        
        db.createASusu(sushare: SuShare(securityState: securitySetting.rawValue, susuTitle: susuTitle, imageURL: "should be accessed from storage", suShareDescription: susuDes, potAmount: num, numOfParticipants: participants, paymentSchedule: paymentSchedule, userId: "nil", category: selectedIntValue , createdDate: Timestamp(date: Date()), suShareId: "nil", usersInTheSuShare: ["\(user.uid)"], isTheSuShareFlagged: false, favId: ""), completion:
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
        ss.uploadPhoto(sushareId: documentId, image: photo){ (result) in
            switch result {
            case .failure(let error):
                self.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
            case .success(let url):
                self.updateSuShareURL(url, documentId: documentId)
            }
        }
    }
    
    private func updateSuShareURL(_ url: URL, documentId: String){
        // update an exisiting doc on firebase
        Firestore.firestore().collection(DatabaseService.suShareCollection).document(documentId).updateData(["imageURL": url.absoluteString]) { [weak self]
            // firebase only accepts a string
            (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "failed to update item", message: "\(error.localizedDescription)")
                }
            } else {
                // everything went okay
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                    //TODO: need to add  the closing circle animation
                }
                print("all went well with the update")
            }
        }
    }
    
    // Actions
    @IBAction func addSusu(_ sender: UIButton) {
        addSusu()
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
                
                let newCell =  selectedCategories[indexPath.row]
                cell.textLabel?.text = newCell.categoryName()

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
        
        
        let item = Category.allCases[indexPath.row]
        
        if !selectedCategories.contains(item) {
            selectedCategories.append(item)
                    print("alert that this category is being removed from the suShare")
                } else {
                    if let index = selectedCategories.firstIndex(of: item) {
                        selectedCategories.remove(at: index)
                    }
           }
//            print("selectedCategory final count is ")
//            print(selectedCategories.count)
//            print("this is the one printed: \(Category(rawValue: indexPath.row)!)")
//                   print("the is only the index path: \(indexPath.row)")
        
        
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

extension UIViewController {
    func hideKeyboard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
//
//    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//       swipeDown.direction = .down
//       self.view.addGestureRecognizer(swipeDown)
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

    
}
