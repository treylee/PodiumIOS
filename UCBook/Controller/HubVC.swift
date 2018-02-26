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

class HubVC: UIViewController {
    private var ref: DatabaseReference!
    private var email:String = ""
    private var uuid:String = ""
    private var avPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        bgVideo()
        //loginDBUser()

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
        self.view.addSubview(avPlayerController.view)
        self.view.sendSubview(toBack: avPlayerController.view)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: .main) { _ in
            self.avPlayer?.seek(to: kCMTimeZero)
            self.avPlayer?.play()
        }
        
    }


    
}
