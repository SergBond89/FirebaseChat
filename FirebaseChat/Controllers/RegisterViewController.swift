//
//  RegisterViewController.swift
//  FirebaseChat
//
//  Created by Sergey on 10/3/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isEnabled = true
        avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectAvatarImage)))
        avatarImage.isUserInteractionEnabled = true
        setupElements()
        view.dismissKeyboard()
    }
    
    @objc func handleSelectAvatarImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    private func setupElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(nameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(registerButton)
    }
    
    func validateFields() -> String? {
        
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    @IBAction func registerTupped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
            
        else {
            
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            self.registerButton.isEnabled = false

            Auth.auth().createUser(withEmail: email, password: password) { (result: AuthDataResult?, error) in
                
                if error != nil {
                    self.showError("Error creating user")
                }
                else {
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let imageName = UUID().uuidString
                    
                    if let avatarImage = self.avatarImage.image, let uploadData = avatarImage.jpegData(compressionQuality: 0.1) {
                        let storageRef = Storage.storage().reference().child("avatar_images").child("\(imageName).jpg")
                        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                            if error != nil {
                                print(error ?? "")
                                return
                            }
                            storageRef.downloadURL { (url, error) in
                                if error != nil {
                                    print(error!.localizedDescription)
                                    return
                                }
                                if let avatarImageUrl = url?.absoluteString {
                                    let values = ["name": name, "email": email, "avatarImageUrl": avatarImageUrl]
                                    self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    private func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        
        let ref = Database.database().reference(fromURL: "https://fir-chat-fc84f.firebaseio.com/")
        
        let userReference = ref.child("users").child(uid)
        
        userReference.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                self.showError("Error saving user data")
            }
            
        }
        let messagesTVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesTVC") as! MessagesTableViewController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = UINavigationController(rootViewController: messagesTVC)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage ] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            avatarImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
