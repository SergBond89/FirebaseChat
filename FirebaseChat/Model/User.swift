//
//  User.swift
//  FirebaseChat
//
//  Created by Sergey on 10/9/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var avatarImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.avatarImageUrl = dictionary["avatarImageUrl"] as? String
    }
}
