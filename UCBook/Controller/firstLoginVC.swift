//
//  ProfileVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/5/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData
import Foundation
import Firebase
import FirebaseAuth


class firstLoginVC  : UIViewController {
    var ref: DatabaseReference!

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var continueLabel: UILabel!
    @IBOutlet weak var submitField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var submitLabel: UILabel!
    var email:String = ""
    let key = UUID().uuidString
    var studentName = ""
    var newUser = ""

    override func viewDidLoad() {
         super.viewDidLoad()
         displayName()
         ref = Database.database().reference()

    }
    
    
    func displayName(){
        let fullName    = UIDevice.current.name
        let fullNameArr = fullName.components(separatedBy: " ")
        
        var name = fullNameArr[0]
        name.removeLast(2)
        nameLabel.text = "Welcome "+name
        
    }
    
    @IBAction func getEmail(_ sender: Any) {
        email = emailField.text!
        email = "\(email)@ucsc.edu"
        email = email.replacingOccurrences(of: " ", with: "")
        print(email as String)
        createDBUser() // creates
    }
    
    func getLoginKey(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            if result.count == 0 {
                print("NEW USER LOGIN")
                let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(key, forKey: "key")
                newUser.setValue(email, forKey: "email")

                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
                
            }
            /* keep this code for ref
             else {
                print("Returning User")
                var count = 0
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "key") as! String)
                    if count == result.count-1 {
                        loginDBUser()
                    }
                    count += count
                }
                
            }*/
        } catch {
            print("In catch:")
            
        }
    }

    func verifyEmail(){
        
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Verifying email ProfileVC")
            self.submitField.isHidden = true;
            self.submitLabel.isHidden = true;
            self.submitButton.isHidden = true;
            self.continueButton.isHidden = false;
            self.continueLabel.isHidden = false;
            
        }
        
    }
    
    @IBAction func checkEmailVerified(_ sender: Any) {
            Auth.auth().currentUser?.reload()
            
    
    if(Auth.auth().currentUser?.isEmailVerified) == true {
        // try dispatch async here later and see if you dont have
        // to press continue twice
            self.performSegue(withIdentifier: "HubSegue2", sender: self)
        }else {
            print("Please verify email")
        }
    }
    
    func createDBUser(){
        print("in email" + email)
        print(key)
        
        Auth.auth().createUser(withEmail: email, password: key) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            
            self.getLoginKey()
            var newDBuser : [String : AnyObject]  =
            [
                "email": self.email as AnyObject,
                "name":self.studentName as AnyObject,
                "key":self.key as AnyObject,
                "role" : "student" as AnyObject
            ]
            
            self.ref.child("users").child((user?.uid)!).setValue(["user": newDBuser])
              print("\(user!.email!) created")
            
              self.verifyEmail()
      
        }
        
            
        }
    
}

