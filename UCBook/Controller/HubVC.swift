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
import AVKit


protocol sendDataToHubProtocol {
    func inputData(data:String)
}

class HubVC: UIViewController,sendDataToViewProtocol {
    // this class recieves data from searchPopUpvC and this forwards to search screen
    var delegate:sendDataToHubProtocol? = nil
    public var goToSearch = false
    func inputData(subject: String , course: String) {


        let storyBoard: UIStoryboard = UIStoryboard(name: "PostingBoard", bundle: nil)
        // the identifier is the storyboardID near under the class name section
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        vc.subject = subject
        vc.course = course
        print("input data to be passed",subject,course)
        
        //sets the delegate in the new
      //  dismiss(animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: false)
        
    }
    private var ref: DatabaseReference!
    private var email:String = ""
    private var uuid:String = ""
    private var avPlayer: AVPlayer!
    var test:String = "xxx"
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    
    @IBAction func searchClick(_ sender: Any) {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "SearchPopupVC") as! SearchPopupVC
        vc.modalPresentationStyle = .overFullScreen
           vc.delegate = self as! sendDataToViewProtocol 
        present(vc, animated: true)

    
    }
    @IBAction func PostClick(_ sender: Any) {
      //  postButton.isHidden = true
        print(test)

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        // the identifier is the storyboardID near under the class name section
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostPopupVC") as! PostPopupVC
        
       //sets the delegate in the new
        present(vc, animated: false)
       // navigationController?.pushViewController(vc, animated: true)

    }

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (goToSearch) {
            goToSearch = false
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SearchPopupVC") as! SearchPopupVC
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self as! sendDataToViewProtocol
            present(vc, animated: true)
        }
        print("testx",test)
        ref = Database.database().reference()
        bgVideo()
        //loginDBUser()
        readFile();
       
       
        
 
    }
    
    // reads all quarters in one file , view database to make sure no collisions.
    //make another method to add new class and book.
   func readFile(){

    if let path = Bundle.main.path(forResource: "fallList2018", ofType: "txt") {
    do {
    let data = try String(contentsOfFile: path, encoding: .utf8)
    let myStrings = data.components(separatedBy: "*")
       /*
        print(myStrings[0])
        print(myStrings.count)
        print(myStrings[1])
        print("\n\n\n")
        print(myStrings[2])
       */


        var subjectRef = Database.database().reference()
        

    
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var ref: DocumentReference? = nil

        var subject = ""
        var subjectList = [String]()
        for index in 0...myStrings.count-1 {
          //  print("The subject",myStrings[index])
            let myStrings2 = myStrings[index].components(separatedBy: .newlines)
            var courseList = [String]()
            for index2 in 0...myStrings2.count-1 {
                if myStrings2[index2] != " "  && myStrings2[index2] != "" {
                if index2 == 0 {
                    print("subject", myStrings2[index2])
                    subject = myStrings2[index2]
                    if !subjectList.contains(subject){
                        subjectList.append(subject)
                    }
                }else {
                    if !courseList.contains(myStrings2[index2]) {
                        courseList.append(myStrings2[index2])
                    }
                    print("subject",subject ,"course",myStrings2[index2])
                    //subjectRef.child(subject).setValue(myStrings2[index2])
                  }
                }
            }
         //init empty dictionary
            var dict: [String: Any] = [
                :]
            // add the courses one by one into dictionary
            for string in courseList {
                dict[string] = ""
            }
            // query the database and add the dictionary to the setDataField to Read the classList
            db
                .collection("subjects").document(subject).setData(dict){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        // print("Document added with ID: \(ref!.documentID)")
                    }
            }
           
            
            
            //Database.database().reference().child("subject").child(subject).setValue(courseList)

        }
        

    //print(myStrings.joined(separator: "\n "))
    } catch {
    print(error)
    }
    }
    }
    @IBAction func websiteRedirect(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "http://www.google.com")! as URL)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //code that makes animation bigger and smaller
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        animation.values = [1.0, 1.3, 1.0]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        logo.layer.add(animation, forKey: nil)
       // self.tabBarController?.tabBarItem.isEnabled = true
        //self.tabBarController?.tabBarItem.image = UIImage(named: "wall2")
        postButton.isHidden = false

        let profilePic = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
       
        profilePic.contentMode = .scaleAspectFit
        profilePic.clipsToBounds = true
        profilePic.image = UIImage(named: "008-twitter")
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        navigationItem.titleView = profilePic
 
        let button = UIButton()
        button.addTarget(self, action: #selector(self.settingsPage), for: .touchUpInside)
        button.frame = CGRect(x:0, y:0, width:40, height:40)
        let color = UIColor(patternImage: UIImage(named: "FullSizeRender")!)
        button.backgroundColor = color
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        let barButton = UIBarButtonItem()
        barButton.customView = button
        self.navigationItem.rightBarButtonItem = barButton
    }
    @objc func settingsPage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        // the identifier is the storyboardID near under the class name section
        let vc = storyBoard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        navigationController?.pushViewController(vc, animated: true)
    }
    func loginDBUser(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                email = data.value(forKey: "email")as! String
                uuid = data.value(forKey: "key")as! String

            }
         
        }catch {
            print("HUBVC LOGINDB In catch:")
            
        }
        
        print(email+uuid)
        
        Auth.auth().signIn(withEmail: email, password: uuid) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
                print(" authenticated signed in")
            
        }
 
        
     }
    func readUserInfo(){
        
    }

    func bgVideo(){
        
        if let filePath = Bundle.main.path(forResource: "hubVideo", ofType:"mp4") {
            let filePathUrl = NSURL.fileURL(withPath: filePath)
            self.avPlayer = AVPlayer(url: filePathUrl)
            let playerLayer = AVPlayerLayer(player: avPlayer)
            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer?.currentItem, queue: nil) { (_) in
                self.avPlayer?.seek(to: kCMTimeZero)
                self.avPlayer?.play()
            }
            self.view.layer.insertSublayer(playerLayer, at: 0)
            self.avPlayer?.play()
        }
        
        /*let filepath: String? = Bundle.main.path(forResource: "hubVideo", ofType: "mp4")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        print("the file path ",fileURL)

        
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
        self.view.sendSubview(toBack: avPlayerController.view)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: .main) { _ in
            self.avPlayer?.seek(to: kCMTimeZero)
            self.avPlayer?.play()
        }*/
        
    }


    
}
