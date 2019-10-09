//
//  RegisterViewController.swift
//  FirebaseChat
//
//  Created by Sergey on 10/3/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        view.dismissKeyboard()
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
            
            Auth.auth().createUser(withEmail: email, password: password) { (result: AuthDataResult?, error) in
                
                if error != nil {
                    self.showError("Error creating user")
                }
                else {
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let ref = Database.database().reference(fromURL: "https://fir-chat-fc84f.firebaseio.com/")
                    
                    let userReference = ref.child("users").child(uid)
                    
                    let values = ["name": name, "email": email]
                    
                    userReference.updateChildValues(values) { (error, ref) in
                        
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                        
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
}
