//
//  ChatViewController.swift
//  myChat
//
//  Created by ErnestG on 08.09.2018.
//  Copyright © 2018 ErnestG. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import ChameleonFramework

/***********************/
/*  User to log in:    */
/*  email: a@b.com     */
/*  password: 123456   */
/***********************/

/*****************************/
/*  Another user to log in:  */
/*  email: b@c.com           */
/*  password: 123456         */
/*****************************/

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messageArray : [Message] = [Message]()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightField: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextField.delegate = self
        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        configureTableView()
        
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
        
    }
    
    //MARK: - TableView methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.userName.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "color-apple")
        
        if cell.userName.text == Auth.auth().currentUser?.email as String? {
            
            //Message that I sent
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        } else {
            
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
        
    }
    
    @objc func tableViewTapped() {
        
        messageTextField.endEditing(true)
        
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    //MARK: - TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 1) {
            self.heightField.constant = 270.0
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 1) {
            self.heightField.constant = 50
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    //MARK: - Send & Receive from Firebase
    
    @IBAction func sendPressed(_ sender: Any) {
        
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDatabase = Database.database().reference().child("messages")
        
        //        let childRef = messagesDatabase.childByAutoId()
        //        let values = ["text": messageTextField.text!]
        //        childRef.updateChildValues(values)
        
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextField.text!]
        
        messagesDatabase.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("Message saved successfully!")
                
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
        }
    }
    
    //MARK: - Retrieve message method
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("messages")
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let messageR = Message()
            messageR.messageBody = text
            messageR.sender = sender
            
            self.messageArray.append(messageR)
            
            self.configureTableView()
            
            self.messageTableView.reloadData()
            
        })
        
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("There was a problem with signing out.")
        }
    }
    
}
