//
//  UIVIewExtension.swift
//  FirebaseChat
//
//  Created by Sergey on 10/3/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func dismissKeyboard() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc private func hideKeyboard() {
        self.endEditing(true)
    }
    
}
