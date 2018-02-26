//
//  PasswordResetVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/10/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import LocalAuthentication
import Foundation
import CoreData
import Firebase

class PasswordReset: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func sendReset(_ sender: Any) {
        var email:String = emailField.text!
            email = "\(email)@ucsc.edu"
            email = email.replacingOccurrences(of: " ", with: "")
           var auth = Auth.auth();
        /*
        auth.sendPasswordResetEmail(email).then(function() {
            // Email sent.
        }).catch(function(error) {
            // An error happened.
        });*/
    }
    
    
    @IBAction func emailVerified(_ sender: Any) {
        
    }
}


