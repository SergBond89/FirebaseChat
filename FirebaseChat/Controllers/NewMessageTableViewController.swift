//
//  NewMessageTableViewController.swift
//  FirebaseChat
//
//  Created by Sergey on 10/9/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {
    
    var users = [User]()
    var messagesTVC: MessagesTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        fetchUser()
    }
    
    @objc func handleCancel() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let user = self.users[indexPath.row]
        
        cell.nameLabel.text = user.name
        cell.detailInfoLabel.text = user.email
        
        if let avatarImageUrl = user.avatarImageUrl {
            cell.avatarImage.loadImageUsingCasheWithUrlString(avatarImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popToRootViewController(animated: true)
        let user = self.users[indexPath.row]
        self.messagesTVC?.showChatViewControllerForUser(user)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}
