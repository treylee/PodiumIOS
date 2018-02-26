//
//  MessageCell.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/12/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var timeStamp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

