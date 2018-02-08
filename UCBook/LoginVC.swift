//
//  ViewController.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/5/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import LocalAuthentication
import Foundation
import CoreData
class LoginVC: UIViewController {
    
    var FFID: String = ""
    var returningUser: Int = 0  //if returning 1 is populated
    @IBOutlet weak var FFLoginButton: UIButton!
    
    func biometricType()  {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                FFLoginButton.setTitle("Passcode", for: .normal)
            case .touchID:
                FFLoginButton.setTitle("Touch-ID", for: .normal)
                FFID = "Touch"
            case .faceID:
                FFLoginButton.setTitle("Face-ID", for: .normal)
                FFID = "Face"
            }
        } else {
            FFLoginButton.isHidden = true;
            
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
         biometricType()
         checkReturningUser()
        
    }


    func passcodeLogin(){
        let myContext = LAContext()
        let myLocalizedReasonString = "Waiting for \(FFID)-ID"
        var authError: NSError?
        myContext.localizedFallbackTitle = "Use Passcode"

        if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success {
                    DispatchQueue.main.async{
                        
                    }
                }
            }
        }
    }
    func checkReturningUser(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    request.returnsObjectsAsFaults = false
    
    do {
    let result = try context.fetch(request)
        self.returningUser = result.count;
    }catch {
        print("LoginVC failed retrieving user")
    }
    }
    
    @IBAction func FFLogin(_ sender: Any) {
    
    let myContext = LAContext()
    let myLocalizedReasonString = "Waiting for \(FFID)-ID"
    myContext.localizedFallbackTitle = "Use \(FFID)-ID"
    
    
    var authError: NSError?
    if #available(iOS 7.0, macOS 10.12.1, *) {
    if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
    myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
    if success {
    print("Success!")
        
        
    DispatchQueue.main.async {
        if self.returningUser  == 0 {
        self.performSegue(withIdentifier: "ProfileSegue", sender:self)
        }else {
            self.performSegue(withIdentifier: "HubSegue", sender:self)

        }
      }
    } else {
    // User did not authenticate successfully, look at error and take appropriate action
    print("Did Not Rec ID")
        self.passcodeLogin()

      }
    }
    } else {
    
    }
        }
    else {// Fallback on earlier versions
      passcodeLogin()
     }
    }
    

}


