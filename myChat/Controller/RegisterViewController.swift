//
//  RegisterViewController.swift
//  myChat
//
//  Created by ErnestG on 08.09.2018.
//  Copyright © 2018 ErnestG. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registeredPassed(_ sender: Any) {
        
        //MARK: Set up a new user on my Firebase database
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Registration successful !")
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
        
    }
    

}
