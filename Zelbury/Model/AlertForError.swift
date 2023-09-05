//
//  UseAlertController.swift
//  Zelbury
//
//  Created by Burak Emre Toker on 1.09.2023.
//

import UIKit

struct AlertForError {
    
    static func alert(title: String, error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: String(error.localizedDescription), preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(action)
    
        return alertController
    }
    
}
