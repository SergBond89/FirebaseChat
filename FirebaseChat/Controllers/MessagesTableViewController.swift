//
//  MessagesTableTableViewController.swift
//  FirebaseChat
//
//  Created by Sergey on 10/7/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserAndSetupNavBarTitle()
//        observeUserMessages()
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let message = Message(dictionary: dictionary)
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort { (message1, message2) -> Bool in
                        return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                    }
                }
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    func fetchUserAndSetupNavBarTitle() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user: user)
            }
        }
        
    }
    
    @objc func handleReloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupNavBarWithUser(user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        let titleLbl = UILabel()
        titleLbl.text = user.name
        titleLbl.textColor = .black
        titleLbl.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        
        let avatarImageView = UIImageView()
        if let avatarImageUrl = user.avatarImageUrl {
            avatarImageView.loadImageUsingCasheWithUrlString(avatarImageUrl)
        }
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        
        avatarImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let titleView = UIStackView(arrangedSubviews: [avatarImageView, titleLbl])
        titleView.axis = .horizontal
        titleView.spacing = 10.0
        navigationItem.titleView = titleView
        
    }
    
    @objc func showChatViewControllerForUser(_ user: User) {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
        chatVC.user = user
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = UINavigationController(rootViewController: homeVC)
    }
    
    @IBAction func logoutTupped(_ sender: Any) {
        handleLogout()
    }
    
    @IBAction func newMessageTupped(_ sender: Any) {
        let newMessVC = self.storyboard?.instantiateViewController(withIdentifier: "NewMessageTVC") as! NewMessageTableViewController
        newMessVC.messagesTVC = self
        self.navigationController?.pushViewController(newMessVC, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! UserTableViewCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else { return }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            self.showChatViewControllerForUser(user)
            
        }, withCancel: nil)
    }
}
