//
//  HomeViewController.swift
//  FirebaseChat
//
//  Created by Sergey on 10/3/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    private func setupElements() {
        Utilities.styleFilledButton(registerButton)
        Utilities.styleHollowButton(loginButton)
    }
    
    @IBAction func registerButtonTupped(_ sender: Any) {
        performSegue(withIdentifier: "showRegisterPageSegue", sender: nil)
    }
    
    @IBAction func loginButtonTupped(_ sender: Any) {
        performSegue(withIdentifier: "showLoginPageSegue", sender: nil)
    }
    
}
