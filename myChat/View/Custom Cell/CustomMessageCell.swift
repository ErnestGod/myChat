//
//  MessageCell.swift
//  myChat
//
//  Created by ErnestG on 11.09.2018.
//  Copyright © 2018 ErnestG. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {

    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
