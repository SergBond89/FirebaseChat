//
//  LoginViewController.swift
//  FirebaseChat
//
//  Created by Sergey on 10/3/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = true
        setupElements()
        view.dismissKeyboard()
        emailTextField.becomeFirstResponder()
    }
    
    
    private func setupElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleHollowButton(loginButton)
    }
    
    func validateFields() -> String? {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func loginTupped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            
            showError(error!)
            
        } else {
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    self.showError(error!.localizedDescription)
                } else {
                    self.loginButton.isEnabled = false
                    let messagesTVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesTVC") as! MessagesTableViewController
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = UINavigationController(rootViewController: messagesTVC)
                }
                
            }
        }
    }
}
