//
//  BookCell.swift
//  UCBook
//
//  Created by Trieveon Cooper on 3/3/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    var titleLabel:UILabel = {

    let label = UILabel(frame: CGRect(x:35, y: 30, width: UIScreen.main.bounds.width , height: 30))
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text =  "This is the very long description of a very boring book that I happen to read on tuesdays :( "
        label.textColor = UIColor.lightGray
        return label
    }()

    
}
