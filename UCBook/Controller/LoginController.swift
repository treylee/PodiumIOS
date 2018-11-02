//
//  LoginController.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/19/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
import Firebase
import CoreData
class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var prompt: UIImageView!
    
    @IBOutlet weak var messagePanel: UIView!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var loginPanel: UIView!
    @IBOutlet weak var pinField2: UITextField!
    @IBOutlet weak var promptText: UILabel!
    @IBOutlet weak var backgroundSelector: UIImageView!
    @IBOutlet weak var backgroundSelector2: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var pinField: UITextField!
    @IBOutlet var topView: UIView!
    private var avPlayer: AVPlayer!
    private var count = 0
    private var email = ""
    private var errorMessage = "a"
    var pin = ""
    var timer = Timer()
    private var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        designButton()
        bgVideo()
        pinField.underlined()
        emailField.underlined()
       // textBox.underlined()
        self.emailField.delegate = self
        self.pinField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func designButton(){
        loginButton.layer.cornerRadius = 20
        loginButton.layer.borderWidth = 3
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        
    }
    func validateEmail()->Bool {
        email = emailField.text!
        email = email.replacingOccurrences(of: " ", with: "")
        return true;

        if email.contains("@ucsc.edu") {
            return true
        }
        return false
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
                newUser.setValue(pin, forKey: "key")
                newUser.setValue(email, forKey: "email")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
    
        } catch {
            print("In catch:")
            
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
    }
    func playText (message : String) {
        promptText.numberOfLines = 3
        promptText.lineBreakMode = NSLineBreakMode.byWordWrapping
        UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
            self.messagePanel.alpha = 0.0
            self.promptText.text = message
            self.loginPanel.isHidden = false
            self.messagePanel.isHidden = false
        }, completion: { (finished: Bool) in
            print("playing text")
            self.messagePanel.alpha = 0.8
            self.promptText.text = message
            self.loginPanel.isHidden = false
            self.messagePanel.isHidden = true

        })
       
    }
    func authenticateReturningUser(){
        print("reauthenticatin user")
        Auth.auth().signIn(withEmail: email, password: pinField.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                print("in error \(self.count)")
                print("count is now \(self.count)")
                
                return
            }

    
            DispatchQueue.main.async {
                   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            // the identifier is the storyboardID near under the class name section
            let vc = storyBoard.instantiateViewController(withIdentifier: "toHubController")
            
            // vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true, completion: nil)
            }
        }
    }
    func authenticateDBUser() {
        print("authenticatin user")
        Auth.auth().createUser(withEmail: email, password: pinField.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                print("count is \(self.count)")
                self.count -= 1;
                print("count is now \(self.count)")

                return
            }
            self.addDBUser()
            self.verifyEmail()
            print("please go verify email")
            self.playText(message: "Please go verify email")
            self.backgroundSelector.isHidden = false
        
            
        }

    }
    func addDBUser() {
        var newDBuser : [String : AnyObject]  =
            [
                "email": self.email as AnyObject,
                "key":  self.pin as AnyObject,
                "role" : "student" as AnyObject
        ]
        
        let ref = Database.database().reference(fromURL: "https://iosbookapp.firebaseio.com/")
        let values = ["email": email,"password":pin,"role":"Student"]
        let usersReference = ref.child("users").child((Auth.auth().currentUser?.uid)!)
        usersReference.updateChildValues(values)
        
        
    }
    func verifyEmail() ->Bool{
      var success = false
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                return ;
            }
            
                success = true
        }
        return success;
    }

    @IBAction func controlButton(_ sender: Any) {
        
        switch count {
            
        case 0:
            
            if validateEmail() {
                backgroundSelector.isHidden = true
                backgroundSelector2.isHidden = false
                pinLabel.isHidden = false
                pinField.isHidden = false
                pinField2.isHidden = false
                count += 1
            } else {
             playText(message: "Please enter a valid @ucsc.edu email")
            }
            break
        case 1:
            print("case 1")
            if pinField.text! == pinField2.text!
                && pinField.text!.count > 5{
                print("in case 1")
                authenticateReturningUser()
                authenticateDBUser()
                count += 1
                 // self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkEmailVerified), userInfo: nil, repeats: true)

            }else {
                playText(message: "Make sure the Pins Match")
            }
            
    break;
            
        case 2:
            print("case 2")
            Auth.auth().currentUser?.reload()
            checkEmailVerified()
            default: break
        }
    }
    
    @objc func checkEmailVerified(){
        if Auth.auth().currentUser?.isEmailVerified == true {
            timer.invalidate()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            // the identifier is the storyboardID near under the class name section
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginTransitionVC")
           // vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true, completion: nil)
        }else {
            playText(message: "Need us to resend? Click the link below")

        }
    }
    
    func bgVideo(){
        let filepath: String? = Bundle.main.path(forResource: "hubVideo", ofType: "mp4")
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
        self.topView.addSubview(avPlayerController.view)
        self.topView.sendSubview(toBack: avPlayerController.view)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: .main) { _ in
            self.avPlayer?.seek(to: kCMTimeZero)
            self.avPlayer?.play()
        }
        
    }
    
    func createEmailView() {
    
    }
}
extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
       
        
    }
    
    
}
