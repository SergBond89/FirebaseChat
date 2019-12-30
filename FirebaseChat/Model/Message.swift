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
    var imageUrl: String?
    var imageWidth: Float?
    var imageHeight: Float?
    
    init(dictionary: [String: AnyObject]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? Float
        self.imageHeight = dictionary["imageHeight"] as? Float
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
