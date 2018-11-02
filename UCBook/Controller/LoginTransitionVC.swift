//
//  LoginTransitionVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/23/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import AVKit
import Firebase
class LoginTransitionVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var prompt: UILabel!
    var profileURL = ""
    var photos = [String]()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var podiumButton: UIButton!
    @IBOutlet weak var picBar: UILabel!
    private var avPlayer: AVPlayer!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        setup()
        
    }

    @IBAction func goToHub(_ sender: Any) {
        addImageURL()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "toHubController")
        present(vc, animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let storageRef = Storage.storage().reference().child("books").child("22").child("bookPic")
        
        // let storageRef = Storage.storage().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("profilePic")
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        pic.image = image
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadImage = UIImagePNGRepresentation(image)
        storageRef.putData(uploadImage!, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Couldn't Upload Image", error)
            } else {
                print("Uploaded")
                storageRef.downloadURL(completion: { (url, error) in
                    print("inside")
                    if error != nil {
                        print(error!)
                        return
                    }
                    if url != nil {
                        print("download url:",url!.absoluteString)
                        self.profileURL =  url!.absoluteString
                        self.photos.append(self.profileURL)
                    }
                })
            }
        }
        picker.dismiss(animated: true,completion: nil)
        
        
    }
    private func addImageURL(){
        let docData: [String: Any] = [
            "profilePhoto": photos
            ]
        var ref4 = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("profilePhoto").addDocument(data: docData)

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        if touch.view == pic {
            print("touching image")
        let controller = UIImagePickerController()
        controller.delegate = self
            controller.allowsEditing = true
        controller.sourceType = .photoLibrary
        present(controller,animated: true,completion: nil)
        }
    }
    func setup(){
        //bgVideo()
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
        //podiumButton.isHidden = false
    }
    func picHasbeenTapped(){
        print("touching image")
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller,animated: true,completion: nil)    }


}
