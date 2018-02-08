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


class ProfileVC: UIViewController {
    var ref: DatabaseReference!


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    var email:String = ""
    let uuid = UUID().uuidString


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
                newUser.setValue(uuid, forKey: "key")
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

    
    func createDBUser(){
        print("in email" + email)
        print(uuid)
        Auth.auth().createUser(withEmail: email, password: uuid) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            
            self.getLoginKey()
            self.ref.child("users").child((user?.uid)!).setValue(["email": self.email
                ,"key":self.uuid])
           // self.ref.child("users").child((user?.uid)!).child("key").setValue(["key": self.uuid])
           //  self.ref.child("users").child((user?.uid)!).child("email").setValue(["something": "poper"])
          //  self.ref.child("users").child((user?.uid)!)..child("email").setValue(["addy": self.email])


                print("\(user!.email!) created")
            }
        }
    
}

