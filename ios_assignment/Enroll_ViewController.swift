//
//  Enroll_ViewController.swift
//  ios_assignment
//
//  Created by Sai Naveen Katla on 16/02/21.
//

import UIKit
import Firebase

class Enroll_ViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var add_user: UIButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var home_town: UITextField!
    @IBOutlet weak var phone_number: UITextField!
    @IBOutlet weak var telephone_number: UITextField!
    
    let dobPicker = UIDatePicker()
    var genderPicker = UIPickerView()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    let gender_array = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        first_name.blueBorder()
        last_name.blueBorder()
        dob.blueBorder()
        gender.blueBorder()
        country.blueBorder()
        state.blueBorder()
        home_town.blueBorder()
        phone_number.blueBorder()
        telephone_number.blueBorder()
        
        self.activity.startAnimating()
        
        self.dobPickerCreation()
        
        self.genderPicker.dataSource = self
        self.genderPicker.delegate = self
        
        self.gender.inputView = genderPicker
    }
    
    @IBAction func select_profile_photo(_ sender: Any) {
        create_display_sheet()
    }
    
    func dobPickerCreation() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let Donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(Done_tapped))
        toolbar.setItems([Donebutton], animated: true)
        
        dob.inputAccessoryView = toolbar
        
        dob.inputView = dobPicker
        
        dobPicker.datePickerMode = .date
        dobPicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func Done_tapped() {
        dob.text = dateFormatter.string(from: dobPicker.date)
        self.view.endEditing(true)
    }
    
    func validateContact(contact: String) -> Bool {
        if contact.count == 10 {
            return true
        }
        return false
    }
    
    @IBAction func addUserToFirestore(_ sender: Any) {
        self.add_user.isEnabled = false
        self.activity.alpha = 1
        
        if (first_name.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (last_name.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (dob.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (gender.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (country.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (state.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (home_town.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (phone_number.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (telephone_number.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            (profileImage.image == nil)
        {
            Alert(title: "Required Fields Missing", message: "Please fill the fields")
            self.add_user.isEnabled = true
            self.activity.alpha = 0
            return
        }
        else if !validateContact(contact: phone_number.text!) {
            Alert(title: "Invalid Phone", message: "check phone")
            self.add_user.isEnabled = true
            self.activity.alpha = 0
            return
        }
        
        let profileStorage = Storage.storage().reference()
            .child("Users_Profile_Image")
            .child("\(phone_number.text!)_Image.png")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let img_data = self.profileImage.image?.jpegData(compressionQuality: 1)
        
        Firestore.firestore().collection("Users").document((phone_number.text)!).getDocument { (document, err) in
            if ((document?.exists) == nil) {
                self.Alert(title: "Phone Number already Exists", message: "Duplication not allowed")
                self.add_user.isEnabled = true
                self.activity.alpha = 0
                return
            }
            else {
                profileStorage.putData(img_data!, metadata: metadata) { [weak self] (storagemetadata, error) in
                    if error != nil {
                        self?.Alert(title: "Error Occured", message: error!.localizedDescription)
                        self?.add_user.isEnabled = true
                        self?.activity.alpha = 0
                        return
                    }
                    
                    profileStorage.downloadURL(completion: { [weak self] (url, error ) in
                        if let image_url = url?.absoluteString {
                            let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
                            let data: [String : Any] = [
                                "name": (self?.first_name.text)! + " " + (self?.last_name.text!)!,
                                "image_url": image_url,
                                "gender": self?.gender.text as Any,
                                "age": self?.dob.text as Any,
                                "place": self?.state.text as Any,
                                "timestamp": timestamp,
                                "country": self?.country.text as Any,
                                "home_town": self?.home_town.text as Any,
                                "telephone": self?.telephone_number.text as Any,
                                "phone": self?.phone_number.text as Any
                            ]
                            
                            Firestore.firestore().collection("Users").document((self?.phone_number.text)!).setData(data) { [weak self] (error) in
                                if error == nil {
                                    self?.Alert(title: "Success", message: "Data Added")
                                    self?.add_user.isEnabled = true
                                    self?.activity.alpha = 0
                                    
                                    self?.first_name.text = ""
                                    self?.last_name.text = ""
                                    self?.dob.text = ""
                                    self?.gender.text = ""
                                    self?.country.text = ""
                                    self?.state.text = ""
                                    self?.home_town.text = ""
                                    self?.phone_number.text = ""
                                    self?.telephone_number.text = ""
                                }
                                else {
                                    self?.Alert(title: "Error", message: "\(error!.localizedDescription)")
                                    self?.add_user.isEnabled = true
                                    self?.activity.alpha = 0
                                }
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    
}

extension Enroll_ViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender_array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender_array[row]
    }
    
    //Selected row displayed on the department label
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.gender.text = gender_array[row]
    }
}


extension Enroll_ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func create_display_sheet() {
        let sheet = UIAlertController(title: "Profile Picture", message: "How would you like to select ?", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: { [weak self] _ in
                                        self?.take_picture()}))
        
        sheet.addAction(UIAlertAction(title: "Choose a picture", style: .default, handler: { [weak self] _ in
                                        self?.select_pic()}))
        
        present(sheet, animated: true)
    }
    
    func take_picture() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func select_pic() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selected_img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.profileImage.image = selected_img
    }
}

extension UITextField {
    
    func blueBorder() {
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 0.09928951412, green: 0.6090357304, blue: 0.8274083138, alpha: 1)
        self.layer.masksToBounds = true
    }
}

extension UIViewController {
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
