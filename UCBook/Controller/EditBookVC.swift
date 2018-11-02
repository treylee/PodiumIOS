//
//  EditBookVC.swift
//  UCBook
//
//  Created by Trey Cooper on 10/31/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData

class EditBookVC: UIViewController {

    @IBOutlet weak var bookPicture1: UIImageView!
    
    @IBOutlet weak var bookPicture2: UIImageView!
    
    @IBOutlet weak var bookPicture3: UIImageView!
    
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var priceText: UITextField!
    
    @IBOutlet weak var meetingText: UITextField!
    
    @IBOutlet weak var conditionText: UITextField!
    
    @IBOutlet weak var commentsText: UITextView!
    
    @IBOutlet weak var titleButton: UIImageView!
    
    @IBOutlet weak var priceButton: UIImageView!
    
    @IBOutlet weak var meetingButton: UIImageView!
    
    @IBOutlet weak var conditionButton: UIImageView!
    
    @IBOutlet weak var commentsButton: UIImageView!
    
    override func viewDidLoad() {
        
    }

}
