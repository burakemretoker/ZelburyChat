//
//  PresentForNameController.swift
//  Zelbury
//
//  Created by Burak Emre Toker on 2.09.2023.
//

import UIKit



class PresentForNameController: UIViewController, UISheetPresentationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var currentName: ((String) -> Void)?
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetPresentationController.delegate = self
        sheetPresentationController.detents = [.medium()]
    }
    
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        
        currentName?(name)
        dismiss(animated: true)
        
    }
    
//    func halfSheetDidSendName() -> String {
//        return nameTextField.text!
//    }
    
    
}

extension PresentForNameController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "type something"
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
}
