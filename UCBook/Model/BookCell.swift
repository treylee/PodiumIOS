//
//  BookCell.swift
//  UCBook
//
//  Created by Trieveon Cooper on 3/3/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
        //cheat/hack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
