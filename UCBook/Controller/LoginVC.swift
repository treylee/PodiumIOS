//
//  ViewController.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/5/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import LocalAuthentication
import Foundation
import CoreData
import Firebase
class LoginVC: UIViewController {
    var avPlayer: AVPlayer!

    var FFID: String = ""
    var returningUser: Int = 0  //if returning 1 is populated
    var ref: DatabaseReference!

    @IBOutlet weak var FFLoginButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var email:String = ""
    var password:String = ""
    var key:String = ""
    
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
    
    func bgVideo(){
        let filepath: String? = Bundle.main.path(forResource: "loginVideo", ofType: "mp4")
        // guard let unwrappedVideoPath = filepath else {return}
        let fileURL = URL.init(fileURLWithPath: filepath!)
        
        
        avPlayer = AVPlayer(url: fileURL)
        
        
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        //fits video to screen in both orientations very important
        avPlayerController.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        
        //  hide show control
        avPlayerController.showsPlaybackControls = false
        // play video
        
        avPlayerController.player?.play()
        self.view.addSubview(avPlayerController.view)
    }
    func traditionalLogin(){
        
        email = emailField.text!
        email = "\(email)@ucsc.edu"
        email = email.replacingOccurrences(of: " ", with: "")
        print(email as String)
        createDBUser() // create
        //password = passwordField.text!
        
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
       // bgVideo()
        panelView.asCircle()
        emailField.underlined()
        //passwordField.underlined()
        biometricType()
        checkReturningUser()
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .up
        view.addGestureRecognizer(slideDown)
    }

   
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        let originalTransform = self.panelView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.001, y: 0.001)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: 250.0)
        UIView.animate(withDuration: 0.9) {
            self.panelView.transform = scaledAndTranslatedTransform
        }
        playTransition()
        
    }
    
    func displayName(){
        let fullName    = UIDevice.current.name
        let fullNameArr = fullName.components(separatedBy: " ")
        
        var name = fullNameArr[0]
        name.removeLast(2)
        
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
                    "key":self.key as AnyObject,
                    "role" : "student" as AnyObject
            ]
            self.ref.child("users").child((user?.uid)!).setValue(["user": newDBuser])
            print("\(user!.email!) created")
            
            self.verifyEmail()
            
        }
        
        
    }
    func playTransition(){
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let originalTransform2 = self.containerView.transform
        let scaledTransform2 = originalTransform2.scaledBy(x:width, y: height)
        let scaledAndTranslatedTransform2 = scaledTransform2.translatedBy(x: 0, y: 0)
        self.containerView.isHidden = false;

        UIView.animate(withDuration: 2.0, delay: 0.0, options: [], animations: {
            self.containerView.isHidden = false;
            
            self.containerView.transform = scaledTransform2
            
        }, completion: { (finished: Bool) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "HubVC")
            vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true, completion: nil)
        })
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
    switch swipeGesture.direction {
    case UISwipeGestureRecognizerDirection.right:
    print("Swiped right")
    case UISwipeGestureRecognizerDirection.down:
    print("Swiped down")
    case UISwipeGestureRecognizerDirection.left:
    print("Swiped left")
    case UISwipeGestureRecognizerDirection.up:
    print("Swiped up")
    default:
    break
    }
    }
    }
    
    /*
        sets up the background,panel,textfield placeholder
 */
    func setup(){
        //top view image
        /*
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "skywolf")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        */
        //panel view image
        let panelImage = UIImageView(frame: UIScreen.main.bounds)
        panelImage.image = UIImage(named: "panel")
        panelImage.contentMode = UIViewContentMode.scaleAspectFill
         panelView.insertSubview(panelImage, at: 0)
        //email/password  extension underline and placeholder
        emailField.underlined()
        emailField.attributedPlaceholder = NSAttributedString(string: "email",
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
/*       passwordField.underlined()
        passwordField.attributedPlaceholder = NSAttributedString(string: "password",
                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])*/
        
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

extension UIView {
    func asCircle(){
        
        let size:CGFloat = 35.0
        self.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        self.layer.cornerRadius = size / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
       // self.layer.cornerRadius = self.frame.width / 2;
      //  self.layer.masksToBounds = true
    }
    func animateTo(fram: CGRect, withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        guard let _ = superview else {
            return
        }
        
        let xScale = frame.size.width / self.frame.size.width
        let yScale = frame.size.height / self.frame.size.height
        let x = frame.origin.x + (self.frame.width * xScale) * self.layer.anchorPoint.x
        let y = frame.origin.y + (self.frame.height * yScale) * self.layer.anchorPoint.y
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            self.layer.position = CGPoint(x: x, y: y)
            self.transform = self.transform.scaledBy(x: xScale, y: yScale)
        }, completion: completion)
    }
}
