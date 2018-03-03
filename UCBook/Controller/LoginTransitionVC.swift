//
//  LoginTransitionVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/23/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import AVKit

class LoginTransitionVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var prompt: UILabel!

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var podiumButton: UIButton!
    @IBOutlet weak var picBar: UILabel!
    private var avPlayer: AVPlayer!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }

    @IBAction func podiumPress(_ sender: Any) {
        if nameField.text != "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "HubVC")
         //   vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true, completion: nil)
        }else {
            prompt.text = "Dont Forget To Enter Your Name"
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        pic.image = image
        dismiss(animated: true,completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        if touch.view == pic {
            print("touching image")
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller,animated: true,completion: nil)
        }
    }
    func setup(){
        bgVideo()
        // set background image
        /*
         let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
         backgroundImage.image = UIImage(named: "cloudPic")
         backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
         self.view.insertSubview(backgroundImage, at: 0)
     */
        nameField.underlined()

        pic.layer.borderWidth = 1
        pic.layer.borderColor = UIColor.white.cgColor
        pic.backgroundColor = UIColor.gray
        pic.layer.masksToBounds = false
        pic.layer.cornerRadius = pic.frame.height/2
        pic.clipsToBounds = true
        //adding gesture recognizer alternative to IBaction
        pic.isUserInteractionEnabled = true
        let picTap = UITapGestureRecognizer()
        picTap.addTarget(self, action: "profileImageHasBeenTapped")

        pic.addGestureRecognizer(picTap)
 
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
        self.view.sendSubview(toBack: avPlayerController.view)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: .main) { _ in
            self.avPlayer?.seek(to: kCMTimeZero)
            self.avPlayer?.play()
    }
}
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        podiumButton.isHidden = self.pic.image == nil
    }
    func picHasbeenTapped(){
        print("touching image")
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller,animated: true,completion: nil)    }


}
