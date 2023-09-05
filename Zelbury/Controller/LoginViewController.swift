//
//  LoginViewController.swift
//  Zelbury
//
//  Created by Burak Emre Toker on 4.08.2023.
//

// Do not forget phone number on keyboard

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in

            if let haveError = error {
//                print(haveError.localizedDescription)
                let errorAlert = AlertForError.alert(title: "Log In Error", error: haveError)
                self.present(errorAlert, animated: true)
            } else {
                self.performSegue(withIdentifier: K.loginIdentifier, sender: self)

            }
        }
        
        
        
        
    }

}
