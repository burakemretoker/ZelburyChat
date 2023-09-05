//
//  RegisterViewController.swift
//  Zelbury
//
//  Created by Burak Emre Toker on 4.08.2023.
//

import UIKit
import Firebase
import FirebaseAuth



class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        let nameStoryboard = UIStoryboard(name: K.Storyboard.nameStoryboard, bundle: nil)
        let usePresentForNameController = nameStoryboard.instantiateViewController(withIdentifier: K.Storyboard.nameStoryboardIdentifier) as! PresentForNameController
        
//        navigationController!.pushViewController(usePresentForNameController, animated: true)

        usePresentForNameController.currentName = { [weak self] userName in
            self?.updateFirebaseProfile(with: userName)
            self?.createUser(email: email, password: password)
            
        }
        
        present(usePresentForNameController, animated: true)
        
    }
  
    
    func updateFirebaseProfile(with name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
            if let haveError = error {
                let errorAlert = AlertForError.alert(title: "Error of Commiting Changes", error: haveError)
                self.present(errorAlert, animated: true)
            }
        }
    }
    
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let haveError = error {
//                print(haveError.localizedDescription)
                let errorAlert = AlertForError.alert(title: "Registering Error", error: haveError)
                self.present(errorAlert, animated: true)
            } else {
                self.performSegue(withIdentifier: K.registerIdentifier, sender: self)
            }
        }

    }

    
    
    
}
