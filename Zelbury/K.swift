//
//  K.swift
//  Zelbury
//
//  Created by Burak Emre Toker on 26.08.2023.
//

import Foundation

struct K {
    static let loginIdentifier = "loginToChat"
    static let registerIdentifier = "registerToChat"
    static let reusableCell = "reusableMessageCell"
    static let cellNibName = "MessageCell"
    
    struct Firestore {
        static let userNameField = "userName"
        static let collectionField = "messages"
        static let messageField = "message"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
    
    struct Storyboard {
        static let nameStoryboard = "AskNameStroyboard"
        static let nameStoryboardIdentifier = "askForName"
    }
}
