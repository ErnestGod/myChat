//
//  ChatViewController.swift
//  myChat
//
//  Created by ErnestG on 08.09.2018.
//  Copyright © 2018 ErnestG. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
