//
//  MessageCell.swift
//  Zelbury
//
//  Created by Burak Emre Toker on 26.08.2023.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIView!
    @IBOutlet weak var rightImageView: UIView!
    @IBOutlet weak var receiverAvatar: UIImageView!
    @IBOutlet weak var senderAvatar: UIImageView!
    @IBOutlet weak var messageArea: UIView!
    @IBOutlet weak var messageText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageArea.layer.cornerRadius = messageArea.frame.height / 10
        
        receiverAvatar.layer.cornerRadius = leftImageView.frame.height / 6
        receiverAvatar.clipsToBounds = true
        receiverAvatar.layer.borderWidth = 2.0
        receiverAvatar.layer.borderColor = UIColor.white.cgColor
        
        senderAvatar.layer.cornerRadius = rightImageView.frame.height / 6
        senderAvatar.clipsToBounds = true
        senderAvatar.layer.borderWidth = 2.0
        senderAvatar.layer.borderColor = UIColor.white.cgColor
        
        messageText.sizeToFit()
        messageText.numberOfLines = 0

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
