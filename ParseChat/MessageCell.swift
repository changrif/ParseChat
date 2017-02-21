//
//  MessageCell.swift
//  ParseChat
//
//  Created by Chandler Griffin on 2/21/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit
import Parse

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func triggerUser(user: PFUser)  {
        if let username = user.username {
            usernameLabel.text = username
            stackView.arrangedSubviews[0].isHidden = false
        }   else    {
            hideUser()
        }
    }
    
    func hideUser() {
        stackView.arrangedSubviews[0].isHidden = true
    }

}
