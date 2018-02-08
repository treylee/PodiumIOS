//
//  HubVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/7/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData

class HubVC: UIViewController {
    var ref: DatabaseReference!
    var email:String = ""
    var uuid:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

    }
    
    func loginDBUser(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "key") as! String)
                print(data.value(forKey: "email") as! String)
            }
         
        }catch {
            print("HUBVC LOGINDB In catch:")
            
        }
        
        
        
        Auth.auth().signIn(withEmail: email, password: uuid) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
                print("Signed in")
            
        }
 
        
     }
    func readUserInfo(){
        
    }

    
}
