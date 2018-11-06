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
  
  
    var bookList = [Book]()
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var reviewTable: UITableView!
    var profileURL : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        postHistory()
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
    func postHistory() {
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("postHistory")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        var newBook: Book = Book(dictionary: document.data())!
                        print(newBook.sellerName,"yahh")
                        self.bookList.append(newBook)
                        
                    }
                    self.historyTable.reloadData()
        }
        
        }}
    @IBAction func changePhoto(_ sender: Any) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let storageRef = Storage.storage().reference().child("users").child("20").child("profilePic")

// let storageRef = Storage.storage().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("profilePic")
 
 let image = info[UIImagePickerControllerOriginalImage] as! UIImage
 profilePhoto.image = image
        
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
                    }
                  })
             }
        }
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
      print("lcount",bookList.count)
            let cell = historyTable.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
           // cell.bookSeller.text = bookList[indexPath.row].sellerName
            if(bookList.count > 0){
             /*   let url = URL(string: self.bookList[indexPath.row].photos?[0] as! String)
                cell.bookPhoto.kf.setImage(with: url)*/
            }
               cellToReturn = cell
        }
        
        return cellToReturn
    }
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == reviewTable{
        count = 1
        }
        else if tableView == historyTable {
            count = 2

        }
            return count
        
    }
      func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
    
    

