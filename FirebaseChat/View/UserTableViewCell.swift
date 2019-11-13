//
//  UserTableViewCell.swift
//  FirebaseChat
//
//  Created by Sergey on 10/9/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var message: Message? {
        didSet {
            setupNameAndAvatarImage()
            
            self.detailInfoLabel.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setupNameAndAvatarImage() {
        
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        self.nameLabel.text = dictionary["name"] as? String
                        if let avatarImageUrl = dictionary["avatarImageUrl"] as? String {
                            self.avatarImage.loadImageUsingCasheWithUrlString(avatarImageUrl)
                        }
                    }
                }
                
            }, withCancel: nil)
        }
    }

}
