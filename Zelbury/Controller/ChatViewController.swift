//
//  ChatViewController.swift
//  Zelbury
//
//  Created by Burak Emre Toker on 4.08.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

//protocol PresentNameControllerDelegate {
//    func halfSheetDidSendName() -> String
//}

class ChatViewController: UIViewController {

    private let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    lazy var avatarImageView = UIImageView()
    
    private var messages = [Message]()
    
//    var delegate: PresentNameControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        messageTextField.delegate = self
        
        
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.reusableCell)
        
//        guard let userName = delegate?.halfSheetDidSendName() else {
//            return
//        }
        
        if let userDisplayName = Auth.auth().currentUser?.displayName {
            print(userDisplayName)
            print("userDisplayName")
            navigationItem.title = userDisplayName
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationItem.hidesBackButton = false
        
        //        let bgImage = UIImage(named: "chatBackground")
        //        tableView.backgroundView = UIImageView(image: bgImage)
        tableView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
        
        let avatarImage = UIImage(named: "scofieldAvatar")
        
        avatarImageView.image = avatarImage
        avatarImageView.contentMode = .scaleAspectFit
        
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width * 0.3
        avatarImageView.clipsToBounds = true
        
        // below code won't work.
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ]
        
        //        avatarImageView.layer.borderWidth = 0.2
        //        avatarImageView.layer.borderColor = UIColor.white.cgColor
        
        
        //        navC.navigationBar.widthAnchor
        
        if let navC = navigationController{
            navC.navigationBar.addSubview(avatarImageView)
            //            avatarImageView.centerXAnchor.constraint(equalTo: navC.navigationBar.centerXAnchor, constant: CGFloat(150)).isActive = true
            avatarImageView.trailingAnchor.constraint(equalTo: navC.navigationBar.trailingAnchor, constant: CGFloat(50)).isActive = true
            avatarImageView.centerYAnchor.constraint(equalTo: navC.navigationBar.centerYAnchor).isActive = true
            //            avatarImageView.widthAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, constant: CGFloat(10)).isActive = true
            avatarImageView.heightAnchor.constraint(equalTo: navC.navigationBar.heightAnchor, multiplier: 0.8).isActive = true
            
            
        }
        readMessages()

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        avatarImageView.removeFromSuperview()
    }
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        sendMessage()
    }
    
    
    private func sendMessage() {
        
        if let userEmail = Auth.auth().currentUser?.email, let message = messageTextField.text {
    
            db.collection(K.Firestore.collectionField)
                .addDocument(data: [
                    K.Firestore.senderField: userEmail,
                    K.Firestore.messageField: message,
                    K.Firestore.dateField: Date()
                ]) { error in
                    if let haveError = error {
//                        print(haveError.localizedDescription)
                        let errorAlert = AlertForError.alert(title: "Message Cannot be Sending Now.", error: haveError)
                        self.present(errorAlert, animated: true)
                        
                    } else {
                        
                        print("Succesfully Added Message to Firestore")
                        
                        DispatchQueue.main.async {
                            self.messageTextField.text = ""
                    }
                }
            }
        }
        
        
    }
    
    private func readMessages() {
        
        db.collection(K.Firestore.collectionField)
            .order(by: K.Firestore.dateField)
            .addSnapshotListener { querySnapshot, error in
                
                self.messages = []
                if let haveError = error {
//                    print(haveError.localizedDescription)
                    let errorAlert = AlertForError.alert(title: "Loading Messages Caused to Error", error: haveError)
                    self.present(errorAlert, animated: true)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            if let currentSender = doc.data()[K.Firestore.senderField] as? String, let currentMessage = doc.data()[K.Firestore.messageField] as? String {
                                
                                let newMessage = Message(sender: currentSender, body: currentMessage)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
//          print("Error signing out: %@", signOutError)
            
            let errorAlert = AlertForError.alert(title: "Sign Out Error", error: signOutError)
            present(errorAlert, animated: true)
        }
        
    }
    
    
}


//MARK: - Table Data Source

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.messageText.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            
            cell.receiverAvatar.isHidden = true
            cell.senderAvatar.isHidden = false
            cell.messageArea.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.2509803922, blue: 0.6, alpha: 1)
            
        } else {
            cell.rightImageView.isHidden = false
            cell.leftImageView.isHidden = true
            
            cell.receiverAvatar.isHidden = false
            cell.senderAvatar.isHidden = true
            cell.messageArea.backgroundColor = #colorLiteral(red: 1, green: 0.5058823529, blue: 0.4862745098, alpha: 1)
        }
        
        return cell
    }
    
}


//MARK: - Table Delegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}


//MARK: - Text Field Delegate

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            return false
        } else {
            sendMessage()
            return true
        }
    }
    
}
