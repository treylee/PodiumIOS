//
//  AccountVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 4/17/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import Firebase

class AccountVC : UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
  
  
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var reviewTable: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.delegate = self
        historyTable.dataSource = self
        reviewTable.delegate = self
        reviewTable.dataSource = self

        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.borderColor = UIColor.white.cgColor
        profilePhoto.backgroundColor = UIColor.gray
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
        profilePhoto.image = UIImage(named: "FullSizeRender")
        //adding gesture recognizer alternative to IBaction
        profilePhoto.isUserInteractionEnabled = true

        
        let profilePic = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        profilePic.contentMode = .scaleAspectFit
        profilePic.clipsToBounds = true
        profilePic.image = UIImage(named: "Transparent Logo-1")
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        navigationItem.titleView = profilePic
        
      /*
        let picTap = UITapGestureRecognizer()
        picTap.addTarget(self, action: "profileImageHasBeenTapped")
        
        cell.posterPic.addGestureRecognizer(picTap)
    */
        
 
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePhoto.image = image
        
        // rest of code and method adds image to storage then adds to currently logged in user object.
        let storageRef = Storage.storage().reference().child((Auth.auth().currentUser?.uid)!).child("userpic")
        
        let uploadImage = UIImagePNGRepresentation(image)
        storageRef.putData(uploadImage!, metadata: nil, completion:
            { (metadata,error) in
                if error != nil {
                    print(error)
                    return
                }
                if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                    let values =  ["profileImageUrl": profileImageURL]
                    self.addImageURL(uid:(Auth.auth().currentUser?.uid)!,values: values as [String : AnyObject])
                    
                }
                
        })
        
        print("loading image")
        
        dismiss(animated: true,completion: nil)
    }
    private func addImageURL(uid:String,values: [String: AnyObject]){
        let ref = Database.database().reference(fromURL: "https://iosbookapp.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        if touch.view == profilePhoto {
            print("touching image")
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.allowsEditing = true
            controller.sourceType = .photoLibrary
            present(controller,animated: true,completion: nil)
        }
    }
    func picHasbeenTapped(){
        print("touching image")
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller,animated: true,completion: nil)
        
    }
    
    //history table tag 1000 review table 2000
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell() // Dummy value
        print("tableview rag",tableView.tag)
        if tableView == reviewTable{
  
            let cell = reviewTable.dequeueReusableCell(withIdentifier: "AccountReviewCell") as! AccountReviewCell
            cellToReturn = cell
            
           // cell.reviewerPhoto.layer.borderWidth = 1
            cell.reviewerPhoto.layer.borderColor = UIColor.black.cgColor
           // cell.reviewerPhoto.backgroundColor = UIColor.gray
            cell.reviewerPhoto.layer.masksToBounds = false
            cell.reviewerPhoto.layer.cornerRadius = cell.reviewerPhoto.frame.height/2
            cell.reviewerPhoto.clipsToBounds = true
            cell.reviewerPhoto.image = UIImage(named: "FullSizeRender")
            //adding gesture recognizer alternative to IBaction
            cell.reviewerPhoto.isUserInteractionEnabled = true
        } else if tableView == historyTable {
      
            let cell = historyTable.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
               cellToReturn = cell
        }
        
        return cellToReturn
    }
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // can ontroll the number of items in each seciton
            return 1
        
    }
      func numberOfSections(in tableView: UITableView) -> Int {
        return 11;
    }
    
    
}
    
    

