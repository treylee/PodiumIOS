//
//  BookDetailsVC.swift
//  UCBook
//
//  Created by Trey Cooper on 10/31/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData
import AVKit

class BookDetailsVC: UIViewController {

    var subjectText = ""
    var courseText = ""
    var bookID = ""
    var price = ""
    

    
    @IBOutlet weak var sellerPicture: UIImageView!
    
    @IBOutlet weak var bookCondition: UILabel!
    
    @IBOutlet weak var bookISBN: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookPrice: UILabel!
    @IBOutlet weak var bookPicture: UIImageView!
    
    @IBOutlet weak var sellerName: UILabel!
    
    @IBOutlet weak var bookDescription: UILabel!
    
    
    override func viewDidLoad() {
        bookTitle.text = subjectText
        bookPrice.text = price
    }
    

}
