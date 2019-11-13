//
//  Message.swift
//  FirebaseChat
//
//  Created by Sergey on 10/20/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import FirebaseAuth

class Message: NSObject {
    var fromId: String?
    var text: String?
    var toId: String?
    var timestamp: NSNumber?
    
    init(dictionary: [String: AnyObject]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
