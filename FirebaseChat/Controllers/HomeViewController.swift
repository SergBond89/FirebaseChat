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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    private func setupElements() {
        Utilities.styleFilledButton(registerButton)
        Utilities.styleHollowButton(loginButton)
    }

}
